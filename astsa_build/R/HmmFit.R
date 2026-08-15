## ================================================================
## HmmFit.R
##
## Poisson and Normal Hidden Markov Models 
## EM with k-means-based automatic initialization, 
## randomized-restart perturbations, and optional
## Hessian-based or parametric bootstrap  SEs. 
## ================================================================


## ------------------------------------------------------------
## HmmFit: (entry point)
## x      : time series (counts for "pois", continuous for "norm")
## m      : number of states
## family : "pois" (default) or "norm"
## ...    : passed through to .HmmPois()/.HmmNorm()
## ------------------------------------------------------------
HmmFit <- function(x, m = 2, family = c("pois", "norm"), ...) {
  family <- match.arg(family)
  dots <- list(...)

  ## init_method only has meaning for family = "norm" (the Poisson case
  ## has just one automatic initializer, plain k-means on x). Rather than
  ## silently absorbing it into .pois_hmm_em's ... and doing nothing,
  ## warn the caller and drop it before dispatching.
  if (family == "pois" && "init_method" %in% names(dots)) {
    warning("init_method is only used for family = \"norm\" (there is ",
            "only one automatic initializer for family = \"pois\"); ",
            "ignoring init_method for this fit.")
    dots$init_method <- NULL
  }

  switch(family,
         pois = do.call(.HmmPois, c(list(x = x, m = m), dots)),
         norm = do.call(.HmmNorm, c(list(x = x, m = m), dots)))
}



## ------------------------------------------------------------
## .statdist: stationary distribution of a transition matrix
## ------------------------------------------------------------
.statdist <- function(Gamma) {
  ev  <- eigen(t(Gamma))
  vec <- Re(ev$vectors[, which.min(abs(ev$values - 1))])
  distout <- vec / sum(vec)
}


## ------------------------------------------------------------
## Shared helpers for se = "hessian"
## ------------------------------------------------------------
.gamma_logit_pack <- function(Gamma) {
  m <- nrow(Gamma)
  out <- numeric(m * (m - 1))
  idx <- 1
  for (i in 1:m) {
    p <- pmax(Gamma[i, ], 1e-10)
    out[idx:(idx + m - 2)] <- log(p[1:(m - 1)] / p[m])
    idx <- idx + (m - 1)
  }
  out
}

.gamma_logit_unpack <- function(logits, m) {
  Gamma <- matrix(0, m, m)
  idx <- 1
  for (i in 1:m) {
    lg <- c(logits[idx:(idx + m - 2)], 0)     # column m is the reference (logit 0)
    p  <- exp(lg - max(lg)); p <- p / sum(p)
    Gamma[i, ] <- p
    idx <- idx + (m - 1)
  }
  Gamma
}


## ------------------------------------------------------------
## .central_diff_jacobian: Used for the delta-method step in
## se = "hessian" 
## ------------------------------------------------------------
.central_diff_jacobian <- function(f, x, h = 1e-4) {
  fx <- f(x)
  n  <- length(x)
  J  <- matrix(0, length(fx), n)
  for (i in seq_len(n)) {
    xp <- x; xp[i] <- xp[i] + h
    xm <- x; xm[i] <- xm[i] - h
    J[, i] <- (f(xp) - f(xm)) / (2 * h)
  }
  J
}


## ------------------------------------------------------------
## .perturb_gamma: mixes each row of a transition matrix with a
## fresh random point on the simplex, at a random strength.
## ------------------------------------------------------------
.perturb_gamma <- function(Gamma0, m, strength = NULL) {
  if (is.null(strength)) strength <- runif(1, 0.1, 0.7)
  Gnew <- matrix(0, m, m)
  for (i in 1:m) {
    rand_row  <- rgamma(m, shape = 1)      # a draw from Dirichlet(1,...,1), i.e. uniform on the simplex
    rand_row  <- rand_row / sum(rand_row)
    Gnew[i, ] <- (1 - strength) * Gamma0[i, ] + strength * rand_row
    Gnew[i, ] <- Gnew[i, ] / sum(Gnew[i, ])    # renormalize defensively against floating-point drift
  }
  Gnew
}



## ------------------------------------------------------------
## .HmmPois
## Automatically initializes lambda0/Gamma0/delta0 via k-means,
## fits by EM, and tries a few perturbations of the starting
## point in case the k-means partition was slightly awkward.
## ------------------------------------------------------------
.HmmPois <- function(x, m = 2, n_perturb = 5, start = NULL,
                          se = c("hessian", "boot", "none"), B = 200,
                          boot_n_perturb = 1, ...) {

  se <- match.arg(se)
  x <- as.numeric(x)       # strip any ts attributes if there

  if (!is.null(start)) {
    if (is.null(start$lambda0) || is.null(start$Gamma0)) {
      stop("start must include lambda0 and Gamma0")
    }
    init <- list(lambda0 = start$lambda0, Gamma0 = start$Gamma0,
                 delta0  = if (is.null(start$delta0)) rep(1 / m, m) else start$delta0)
  } else {
    init <- .auto_init_pois_hmm(x, m)
  }

  ## fit at the starting point
  best <- .pois_hmm_em(x, m,
                        lambda0 = init$lambda0,
                        Gamma0  = init$Gamma0,
                        delta0  = init$delta0, ...)

  ## a few small perturbations around it, in case kmeans landed
  ## on a slightly awkward partition.
  ## NOTE: seq_len(n_perturb), not 1:n_perturb -- 1:0 is c(1, 0) in R
  ## (length 2!), so n_perturb = 0 would silently still run 2 perturbed
  ## restarts instead of none. seq_len(0) is correctly empty.
  for (i in seq_len(n_perturb)) {
    ## NOTE: do NOT sort lam_p here. init$lambda0 is already sorted, but
    ## the independent runif(m, 0.7, 1.3) jitter can flip the order of
    ## two close rates; sorting afterwards would silently relabel the
    ## states without applying the same permutation to Gamma0_p/delta0
    ## (which are still in the pre-jitter label order), handing EM an
    ## internally inconsistent (emission, transition) pairing. EM's
    ## likelihood doesn't depend on label order, so we just leave lam_p
    ## as-is and canonically relabel the final winner once, below.
    lam_p    <- pmax(init$lambda0 * runif(m, 0.7, 1.3), 0.1)
    Gamma0_p <- .perturb_gamma(init$Gamma0, m)
    fit <- tryCatch(
      .pois_hmm_em(x, m, lambda0 = lam_p,
                   Gamma0 = Gamma0_p, delta0 = init$delta0, ...),
      error = function(e) NULL
    )
    if (!is.null(fit) && fit$loglik > best$loglik) best <- fit
  }

  ## canonical relabeling: state 1 = lowest rate (mirrors .HmmNorm's
  ## final relabel by mu). Needed because the winning fit could have
  ## come from any restart, in any label order.
  ord_final <- order(best$lambda)
  best$lambda    <- best$lambda[ord_final]
  best$delta     <- best$delta[ord_final]
  best$pis       <- best$pis[ord_final]
  best$Pmatrix   <- best$Pmatrix[ord_final, ord_final]
  best$posterior <- best$posterior[, ord_final]

  best$init <- init

  ## AIC/BIC
  n <- length(x)
  best$npar <- m + m * (m - 1) + (m - 1)
  best$AIC  <- -2 * best$loglik + 2 * best$npar
  best$BIC  <- -2 * best$loglik + log(n) * best$npar

  if (se == "boot") {
    best$se <- .pois_hmm_boot(best, x, m = m, B = B,
                               n_perturb = boot_n_perturb, ...)
  } else if (se == "hessian") {
    best$se <- .pois_hmm_hessian_se(best, x, m = m)
  }

  best
}


## ------------------------------------------------------------
## .pois_hmm_em: core EM engine for an m-state Poisson HMM
## ------------------------------------------------------------
.pois_hmm_em <- function(x, m = 2,
                          lambda0 = NULL,
                          Gamma0  = NULL,
                          delta0  = NULL,
                          maxiter = 500, tol = 1e-8, ...) {

  n <- length(x)

  if (is.null(lambda0)) {
    qs <- quantile(x, seq(0, 1, length.out = m + 2))[2:(m + 1)]
    lambda <- as.numeric(qs)
  } else lambda <- lambda0

  if (is.null(Gamma0)) {
    Gamma <- matrix(0.1 / (m - 1), m, m); diag(Gamma) <- 0.9
  } else Gamma <- Gamma0

  delta <- if (is.null(delta0)) rep(1 / m, m) else delta0

  oldloglik <- -Inf

  for (iter in 1:maxiter) {

    ## ---- emission probabilities: n x m ----
    B <- sapply(1:m, function(j) dpois(x, lambda[j]))

    ## ---- scaled forward pass ----
    alpha <- matrix(0, n, m)
    cvec  <- numeric(n)

    a         <- delta * B[1, ]
    cvec[1]   <- sum(a)
    alpha[1,] <- a / cvec[1]

    for (t in 2:n) {
      a          <- (alpha[t - 1, ] %*% Gamma) * B[t, ]
      cvec[t]    <- sum(a)
      alpha[t, ] <- a / cvec[t]
    }
    loglik <- sum(log(cvec))

    ## ---- scaled backward pass ----
    beta      <- matrix(0, n, m)
    beta[n, ] <- 1
    for (t in (n - 1):1) {
      beta[t, ] <- (Gamma %*% (B[t + 1, ] * beta[t + 1, ])) / cvec[t + 1]
    }

    ## ---- E-step: state probs (gamma) and transition probs (xi) ----
    gam <- alpha * beta
    gam <- gam / rowSums(gam)

    xi <- matrix(0, m, m)
    for (t in 1:(n - 1)) {
      num <- outer(alpha[t, ], B[t + 1, ] * beta[t + 1, ]) * Gamma
      xi  <- xi + num / cvec[t + 1]
    }

    ## ---- M-step ----
    Gamma_new  <- xi / rowSums(xi)
    lambda_new <- colSums(gam * x) / colSums(gam)
    delta_new  <- gam[1, ]

    diff <- abs(loglik - oldloglik)
    Gamma <- Gamma_new; lambda <- lambda_new; delta <- delta_new
    if (diff < tol) break
    oldloglik <- loglik
  }
  distout <- .statdist(Gamma)
  qres    <- .pois_hmm_qresiduals(x, lambda, Gamma, delta)
  list(lambda = lambda, Pmatrix = Gamma, delta = delta, pis=distout,
       loglik = loglik, posterior = gam, niter = iter, resid = qres)
}


## ------------------------------------------------------------
## .pois_hmm_qresiduals: one-step-ahead quantile (normal
## pseudo-)residuals, computed from the predictive state
## distribution eta_t = P(S_t | x_1,...,x_{t-1}) (eta_1 = delta).
## Since x_t | S_t=j ~ Poisson(lambda_j), the one-step-ahead
## predictive CDF is the mixture
##   F_t(q) = sum_j eta_t(j) * ppois(q, lambda_j)
## Because Poisson data are discrete, F_t has jumps; plugging in
## F_t(x_t) directly would bias residuals near those jumps, so a
## randomized (jittered) residual is used instead:
##   u_t ~ Uniform(F_t(x_t - 1), F_t(x_t)),   resid_t = qnorm(u_t)
## Under a correctly specified model, resid_t is i.i.d. N(0,1).
## qres_seed: optional seed for reproducible jittering (NULL = no
## fixed seed, i.e. residuals vary slightly run to run).
## Returns a plain numeric vector (length n), one residual per x_t.
## ------------------------------------------------------------
.pois_hmm_qresiduals <- function(x, lambda, Gamma, delta, qres_seed = NULL) {
  n <- length(x)
  m <- length(lambda)
  B <- sapply(1:m, function(j) dpois(x, lambda[j]))

  eta <- delta                 # eta = P(S_t | x_1,...,x_{t-1}), starts at t = 1
  Fu  <- numeric(n)
  Fl  <- numeric(n)

  for (t in 1:n) {
    Fu[t] <- sum(eta * sapply(1:m, function(j) ppois(x[t],     lambda[j])))
    Fl[t] <- sum(eta * sapply(1:m, function(j) ppois(x[t] - 1, lambda[j])))

    ## filter in x_t, then push forward one step to get eta for t + 1
    a   <- eta * B[t, ]
    a   <- a / sum(a)
    eta <- as.numeric(a %*% Gamma)
  }

  Fl <- pmin(Fl, Fu)            # guard tiny floating-point overshoot
  if (!is.null(qres_seed)) set.seed(qres_seed)
  u <- runif(n, min = Fl, max = Fu)

  eps <- 1e-10                  # keep off the boundary so qnorm() isn't +-Inf
  u <- pmin(pmax(u, eps), 1 - eps)

  qnorm(u)
}


## ------------------------------------------------------------
## .auto_init_pois_hmm: data-driven starting values
## ------------------------------------------------------------
.auto_init_pois_hmm <- function(x, m = 2) {
  n <- length(x)

  ## --- hard clustering step ---
  if (n >= 5 * m) {
    km  <- kmeans(x, centers = m, nstart = 25)
    cl  <- km$cluster
    ord <- order(km$centers)              # relabel so state 1 = lowest rate
    map <- match(cl, ord)
    lambda0 <- sort(km$centers)
  } else {
    ## fallback for tiny samples: rank-based binning instead of kmeans.
    ## NOTE: quantile()-derived breaks + cut() used to be used here, but
    ## quantile() breaks aren't guaranteed unique when x has ties (the
    ## norm for small Poisson samples), which either (a) crashes cut()
    ## directly with "'breaks' are not unique", (b) leaves a bin empty
    ## -> mean(x[map==j]) = NaN -> NaN propagates through dpois()/EM
    ## silently, or (c) produces an NA map entry -> crashes the
    ## Gamma0[map[t], map[t+1]] <- ... assignment below with "NAs are
    ## not allowed in subscripted assignments". rank(ties.method =
    ## "first") is always a permutation of 1:n regardless of ties, so
    ## splitting into m contiguous rank-blocks guarantees every state
    ## gets at least one point whenever n >= m.
    rk  <- rank(x, ties.method = "first")
    map <- pmin(pmax(ceiling(rk / n * m), 1), m)
    lambda0 <- sapply(1:m, function(j) mean(x[map == j]))
  }

  ## --- empirical transition matrix from the hard-assigned state sequence ---
  Gamma0 <- matrix(0, m, m)
  for (t in 1:(n - 1)) {
    Gamma0[map[t], map[t + 1]] <- Gamma0[map[t], map[t + 1]] + 1
  }
  Gamma0 <- Gamma0 + 0.5              # small pseudo-count: avoids zero rows
  Gamma0 <- Gamma0 / rowSums(Gamma0)

  ## --- initial-state distribution from marginal cluster frequencies ---
  delta0 <- as.numeric(table(factor(map, levels = 1:m)))
  delta0 <- delta0 / sum(delta0)

  list(lambda0 = lambda0, Gamma0 = Gamma0, delta0 = delta0, cluster = map)
}


## ------------------------------------------------------------
## .sim_pois_hmm: simulate a length-n series from a Poisson HMM
## (used only by .pois_hmm_boot below)
## ------------------------------------------------------------
.sim_pois_hmm <- function(n, lambda, Gamma, delta) {
  m <- length(lambda)
  state <- integer(n)
  state[1] <- sample(m, 1, prob = delta)
  for (t in 2:n) {
    state[t] <- sample(m, 1, prob = Gamma[state[t - 1], ])
  }
  rpois(n, lambda[state])
}


## ------------------------------------------------------------
## .pois_hmm_hessian_se: asymptotic SEs/CIs 
## ------------------------------------------------------------
.pois_hmm_hessian_se <- function(fit, x, m = 2) {
  if (!requireNamespace("nlme", quietly = TRUE)) {
    stop("se = \"hessian\" requires the 'nlme' package (normally included ",
         "with R by default). Install it with install.packages(\"nlme\").")
  }
  n <- length(x)
  delta <- fit$delta   # held fixed -- see note above .gamma_logit_pack

  pack <- function(lambda, Gamma) c(log(lambda), .gamma_logit_pack(Gamma))
  unpack <- function(theta) {
    lambda <- exp(theta[1:m])
    Gamma  <- .gamma_logit_unpack(theta[(m + 1):(m + m * (m - 1))], m)
    list(lambda = lambda, Gamma = Gamma)
  }

  loglik_fn <- function(lambda, Gamma) {
    B <- sapply(1:m, function(j) dpois(x, lambda[j]))
    a <- delta * B[1, ]; c1 <- sum(a); ll <- log(c1); a <- a / c1
    for (t in 2:n) {
      a  <- (a %*% Gamma) * B[t, ]
      ct <- sum(a); ll <- ll + log(ct); a <- a / ct
    }
    as.numeric(ll)
  }

  negloglik <- function(theta) {
    u <- unpack(theta)
    -loglik_fn(u$lambda, u$Gamma)
  }
  natural <- function(theta) {
    u <- unpack(theta)
    c(u$lambda, as.vector(u$Gamma))
  }

  theta_hat <- pack(fit$lambda, fit$Pmatrix)
  H  <- nlme::fdHess(theta_hat, negloglik)$Hessian   # observed information (Hessian of -loglik)
  Vt <- tryCatch(solve(H), error = function(e) {
    warning("Hessian is not invertible at this fit -- SEs may be unreliable ",
            "(this can happen at a boundary or a poorly separated fit)")
    matrix(NA_real_, length(theta_hat), length(theta_hat))
  })

  J    <- .central_diff_jacobian(natural, theta_hat)   # delta method: map SEs back to the natural scale
  Vnat <- J %*% Vt %*% t(J)
  se_natural <- suppressWarnings(sqrt(diag(Vnat)))

  se_lambda <- se_natural[1:m]
  se_Gamma  <- matrix(se_natural[(m + 1):(m + m * m)], m, m)

  out <- data.frame(
    state     = 1:m,
    lambda    = fit$lambda,
    se_lambda = se_lambda,
    lower95   = fit$lambda - 1.96 * se_lambda,
    upper95   = fit$lambda + 1.96 * se_lambda
  )
  attr(out, "Gamma_se") <- se_Gamma   # SEs for the transition matrix, as a bonus
  out
}


## ------------------------------------------------------------
## .pois_hmm_boot: parametric bootstrap SEs/CIs for lambda
## ------------------------------------------------------------
.pois_hmm_boot <- function(fit, x, m = 2, B = 200, progress = TRUE,
                            n_cores = 1, ...) {
  n <- length(x)

  dots <- list(...)               # whatever n_perturb/maxiter/tol arrived with
  dots$m  <- NULL                 # guard against accidental collisions
  dots$se <- NULL

  can_fork  <- n_cores > 1 && .Platform$OS.type == "unix"
  can_psock <- n_cores > 1 && !can_fork

  cl <- NULL
  if (can_psock) {
    cl <- parallel::makeCluster(n_cores)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    ## PSOCK workers are fresh R sessions -- they don't have this script's
    ## functions loaded, so they have to be shipped over explicitly. envir
    ## is the environment .pois_hmm_boot itself was defined in (wherever
    ## the script was source()'d into), so this finds its sibling helpers
    ## regardless of what that environment happens to be.
    parallel::clusterExport(
      cl,
      varlist = c(".sim_pois_hmm", ".HmmPois", ".pois_hmm_em",
                  ".auto_init_pois_hmm", ".statdist"),
      envir = environment(.pois_hmm_boot)
    )
    ## independent, statistically sound RNG streams per worker 
    parallel::clusterSetRNGStream(cl)
  }

  one_rep <- function(i) {
    x_sim <- .sim_pois_hmm(n, fit$lambda, fit$Pmatrix, fit$delta)
    fit_b <- tryCatch(
      do.call(.HmmPois, c(list(x = x_sim, m = m, se = "none"), dots)),
      error = function(e) NULL
    )
    if (is.null(fit_b) || is.null(fit_b$lambda) || length(fit_b$lambda) != m ||
        anyNA(fit_b$lambda)) return(NULL)
    fit_b$lambda[order(fit_b$lambda)]
  }

  if (progress) pb <- txtProgressBar(min = 0, max = B, initial = 0, style = 3)

  ## chunk size controls how often the progress bar updates:  
  chunk_size <- if (n_cores > 1) n_cores else 1

  results   <- list()
  tries     <- 0
  max_tries <- 5 * B
  while (length(results) < B && tries < max_tries) {
    chunk <- min(chunk_size, B - length(results), max_tries - tries)
    tries <- tries + chunk
    batch <- if (can_fork) {
      parallel::mclapply(seq_len(chunk), one_rep, mc.cores = n_cores)
    } else if (can_psock) {
      parallel::parLapply(cl, seq_len(chunk), one_rep)
    } else {
      lapply(seq_len(chunk), one_rep)
    }
    results <- c(results, Filter(Negate(is.null), batch))
    if (progress) setTxtProgressBar(pb, min(length(results), B))
  }
  if (progress) close(pb)

  b <- length(results)
  if (b < B) warning(sprintf("only %d/%d bootstrap fits converged", b, B))
  lam_boot <- if (b > 0) do.call(rbind, results) else matrix(NA_real_, 0, m)

  if (nrow(lam_boot) < 2) {
    stop("fewer than 2 bootstrap fits converged -- check .pois_hmm_boot for errors, ",
         "or increase boot_n_perturb")
  }

  se_boot <- apply(lam_boot, 2, sd, na.rm = TRUE)
  ci      <- apply(lam_boot, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)

  data.frame(
    state   = 1:m,
    lambda  = sort(fit$lambda),
    se_boot = se_boot,
    lower95 = ci[1, ],
    upper95 = ci[2, ],
    n_boot  = nrow(lam_boot)
  )
}


## ================================================================
## Normal HMM   
# ================================================================
.HmmNorm <- function(x, m = 2, n_perturb = 5, start = NULL,
                          se = c("hessian", "boot", "none"), B = 200,
                          boot_n_perturb = 1,
                          order_by = c("mean", "sd"),
                          init_method = c("auto", "location", "volatility"),
                          ...) {

  se          <- match.arg(se)
  order_by    <- match.arg(order_by)
  init_method <- match.arg(init_method)
  x <- as.numeric(x)       # strip any ts attributes if there
  n <- length(x)

  best        <- NULL
  best_init   <- NULL
  best_method <- NA_character_
  init_loc    <- NULL
  init_vol    <- NULL

  if (!is.null(start)) {
    ## your own starting values -- skip both automatic initializers
    if (is.null(start$mu0) || is.null(start$sigma0) || is.null(start$Gamma0)) {
      stop("start must include mu0, sigma0, and Gamma0")
    }
    start_delta0 <- if (is.null(start$delta0)) rep(1 / m, m) else start$delta0
    best <- .norm_hmm_em(x, m,
                          mu0 = start$mu0, sigma0 = start$sigma0,
                          Gamma0 = start$Gamma0, delta0 = start_delta0, ...)
    best_init   <- list(mu0 = start$mu0, sigma0 = start$sigma0,
                         Gamma0 = start$Gamma0, delta0 = start_delta0)
    best_method <- "user"

  } else {

  ## Two candidate initializers, because "state" can mean two different
  ## things for real-valued data: a difference in LEVEL (the usual case --
  ## e.g. low/medium/high readings) or a difference in SPREAD (e.g. calm
  ## vs. volatile regimes in returns data, where every state has a mean
  ## near zero).  
  if (init_method != "volatility") {
    init_loc <- .auto_init_norm_hmm(x, m)
    fit_loc  <- tryCatch(
      .norm_hmm_em(x, m,
                    mu0    = init_loc$mu0,
                    sigma0 = init_loc$sigma0,
                    Gamma0 = init_loc$Gamma0,
                    delta0 = init_loc$delta0, ...),
      error = function(e) NULL
    )
    if (!is.null(fit_loc)) {
      best <- fit_loc; best_init <- init_loc; best_method <- "location"
    }
  }

  if (init_method != "location" && n >= 5 * m) {
    init_vol <- tryCatch(.auto_init_norm_hmm_vol(x, m), error = function(e) NULL)
    if (!is.null(init_vol)) {
      fit_vol <- tryCatch(
        .norm_hmm_em(x, m,
                      mu0    = init_vol$mu0,
                      sigma0 = init_vol$sigma0,
                      Gamma0 = init_vol$Gamma0,
                      delta0 = init_vol$delta0, ...),
        error = function(e) NULL
      )
      if (!is.null(fit_vol) && is.finite(fit_vol$loglik) &&
          (is.null(best) || fit_vol$loglik > best$loglik)) {
        best <- fit_vol; best_init <- init_vol; best_method <- "volatility"
      }
    }
  }

  ## safety net:  fall back to  the location initializer 
  if (is.null(best)) {
    init_loc <- .auto_init_norm_hmm(x, m)
    best <- .norm_hmm_em(x, m,
                          mu0 = init_loc$mu0, sigma0 = init_loc$sigma0,
                          Gamma0 = init_loc$Gamma0, delta0 = init_loc$delta0, ...)
    best_init <- init_loc; best_method <- "location"
  }

  } # end of else (auto initializer search) -- skipped entirely if start was supplied

  ## a few small perturbations around whichever initializer is currently
  ## winning,  .
  jitter_scale <- 0.3 * sd(x)
  ## NOTE: seq_len(n_perturb), not 1:n_perturb -- 1:0 is c(1, 0) in R
  ## (length 2!), so n_perturb = 0 would silently still run 2 perturbed
  ## restarts instead of none. seq_len(0) is correctly empty, which
  ## matters if you want to test a user-supplied start point (e.g. an
  ## exact saddle point) with NO perturbation added around it.
  for (i in seq_len(n_perturb)) {
    ## NOTE: mu_p/sigma_p used to be reordered by ord_p = order(mu_p)
    ## while Gamma0_p/delta0 stayed in the pre-jitter label order --
    ## an inconsistent (emission, transition) pairing at the start of
    ## EM. EM's likelihood doesn't depend on label order, and the
    ## canonical relabel below (ord_final) already fixes up whichever
    ## fit wins, so no permutation is needed here.
    mu_p     <- best_init$mu0 + rnorm(m, 0, jitter_scale)
    sigma_p  <- pmax(best_init$sigma0 * runif(m, 0.7, 1.3), 1e-3)
    Gamma0_p <- .perturb_gamma(best_init$Gamma0, m)
    fit <- tryCatch(
      .norm_hmm_em(x, m, mu0 = mu_p, sigma0 = sigma_p,
                   Gamma0 = Gamma0_p, delta0 = best_init$delta0, ...),
      error = function(e) NULL
    )
    if (!is.null(fit) && is.finite(fit$loglik) && fit$loglik > best$loglik) best <- fit
  }

  ## canonical relabeling: by default state 1 = lowest mean (matches
  ## .HmmPois's convention). If states differ mainly in spread rather
  ## than level ordering by mean is close to arbitrary; order_by = "sd"
  ## gives state 1 = lowest volatility instead
  ord_final <- if (order_by == "sd") order(best$sigma) else order(best$mu)
  best$mu        <- best$mu[ord_final]
  best$sigma     <- best$sigma[ord_final]
  best$delta     <- best$delta[ord_final]
  best$pis       <- best$pis[ord_final]
  best$Pmatrix   <- best$Pmatrix[ord_final, ord_final]
  best$posterior <- best$posterior[, ord_final]

  best$init        <- list(location = init_loc, volatility = init_vol)
  best$init_method <- best_method

  ## AIC/BIC
  best$npar <- 2 * m + m * (m - 1) + (m - 1)
  best$AIC  <- -2 * best$loglik + 2 * best$npar
  best$BIC  <- -2 * best$loglik + log(n) * best$npar

  if (se == "boot") {
    best$se <- .norm_hmm_boot(best, x, m = m, B = B,
                               n_perturb = boot_n_perturb,
                               order_by = order_by, ...)
  } else if (se == "hessian") {
    best$se <- .norm_hmm_hessian_se(best, x, m = m)
  }

  best
}


## ------------------------------------------------------------
## .norm_hmm_em: core EM engine for an m-state Normal HMM with
## state-specific mean AND standard deviation
## ------------------------------------------------------------
.norm_hmm_em <- function(x, m = 2,
                          mu0     = NULL,
                          sigma0  = NULL,
                          Gamma0  = NULL,
                          delta0  = NULL,
                          maxiter = 500, tol = 1e-8, ...) {

  n <- length(x)

  if (is.null(mu0)) {
    qs <- quantile(x, seq(0, 1, length.out = m + 2))[2:(m + 1)]
    mu <- as.numeric(qs)
  } else mu <- mu0

  if (is.null(sigma0)) {
    sigma <- rep(sd(x), m)
  } else sigma <- sigma0

  if (is.null(Gamma0)) {
    Gamma <- matrix(0.1 / (m - 1), m, m); diag(Gamma) <- 0.9
  } else Gamma <- Gamma0

  delta <- if (is.null(delta0)) rep(1 / m, m) else delta0

  ## floor for sigma, scaled to the data rather 
  sigma_floor <- max(1e-6, 1e-4 * sd(x))

  oldloglik <- -Inf

  for (iter in 1:maxiter) {

    ## ---- emission probabilities: n x m ----
    B <- sapply(1:m, function(j) dnorm(x, mean = mu[j], sd = sigma[j]))

    ## ---- scaled forward pass ----
    alpha <- matrix(0, n, m)
    cvec  <- numeric(n)

    a         <- delta * B[1, ]
    cvec[1]   <- sum(a)
    alpha[1,] <- a / cvec[1]

    for (t in 2:n) {
      a          <- (alpha[t - 1, ] %*% Gamma) * B[t, ]
      cvec[t]    <- sum(a)
      alpha[t, ] <- a / cvec[t]
    }
    loglik <- sum(log(cvec))

    ## ---- scaled backward pass ----
    beta      <- matrix(0, n, m)
    beta[n, ] <- 1
    for (t in (n - 1):1) {
      beta[t, ] <- (Gamma %*% (B[t + 1, ] * beta[t + 1, ])) / cvec[t + 1]
    }

    ## ---- E-step: state probs (gamma) and transition probs (xi) ----
    gam <- alpha * beta
    gam <- gam / rowSums(gam)

    xi <- matrix(0, m, m)
    for (t in 1:(n - 1)) {
      num <- outer(alpha[t, ], B[t + 1, ] * beta[t + 1, ]) * Gamma
      xi  <- xi + num / cvec[t + 1]
    }

    ## ---- M-step ----
    Gamma_new  <- xi / rowSums(xi)
    mu_new     <- colSums(gam * x) / colSums(gam)
    ## weighted per-state variance: sum_t gam[t,j]*(x_t - mu_j)^2 / sum_t gam[t,j]
    sigma_new  <- sqrt(colSums(gam * (outer(x, mu_new, "-"))^2) / colSums(gam))
    ## floor scaled to the data (not a fixed constant)
    sigma_new  <- pmax(sigma_new, sigma_floor)
    delta_new  <- gam[1, ]

    diff <- abs(loglik - oldloglik)
    Gamma <- Gamma_new; mu <- mu_new; sigma <- sigma_new; delta <- delta_new
    if (diff < tol) break
    oldloglik <- loglik
  }
  distout <- .statdist(Gamma)
  qres    <- .norm_hmm_qresiduals(x, mu, sigma, Gamma, delta)
  list(mu = mu, sigma = sigma, Pmatrix = Gamma, delta = delta, pis = distout,
       loglik = loglik, posterior = gam, niter = iter, resid = qres)
}


## ------------------------------------------------------------
## .norm_hmm_qresiduals: one-step-ahead quantile (normal
## pseudo-)residuals, computed from the predictive state
## distribution eta_t = P(S_t | x_1,...,x_{t-1}) (eta_1 = delta).
## Since x_t | S_t=j ~ N(mu_j, sigma_j^2), the one-step-ahead
## predictive CDF is the mixture
##   F_t(q) = sum_j eta_t(j) * pnorm(q, mu_j, sigma_j)
## x is continuous here, so no jittering is needed (unlike the
## Poisson case): resid_t = qnorm(F_t(x_t)). Under a correctly
## specified model, resid_t is i.i.d. N(0,1).
## Returns a plain numeric vector (length n), one residual per x_t.
## ------------------------------------------------------------
.norm_hmm_qresiduals <- function(x, mu, sigma, Gamma, delta) {
  n <- length(x)
  m <- length(mu)
  B <- sapply(1:m, function(j) dnorm(x, mean = mu[j], sd = sigma[j]))

  eta <- delta                 # eta = P(S_t | x_1,...,x_{t-1}), starts at t = 1
  u   <- numeric(n)

  for (t in 1:n) {
    u[t] <- sum(eta * sapply(1:m, function(j) pnorm(x[t], mean = mu[j], sd = sigma[j])))

    ## filter in x_t, then push forward one step to get eta for t + 1
    a   <- eta * B[t, ]
    a   <- a / sum(a)
    eta <- as.numeric(a %*% Gamma)
  }

  eps <- 1e-10                  # keep off the boundary so qnorm() isn't +-Inf
  u <- pmin(pmax(u, eps), 1 - eps)

  qnorm(u)
}


## ------------------------------------------------------------
## .auto_init_norm_hmm: data-driven starting values for mu0,
## sigma0, Gamma0, and delta0 via k-means clustering of x
## ------------------------------------------------------------
.auto_init_norm_hmm <- function(x, m = 2) {
  n <- length(x)

  ## --- hard clustering step ---
  if (n >= 5 * m) {
    km  <- kmeans(x, centers = m, nstart = 25)
    cl  <- km$cluster
    ord <- order(km$centers)              # relabel so state 1 = lowest mean
    map <- match(cl, ord)
    mu0 <- sort(km$centers)
  } else {
    ## fallback for tiny samples: rank-based binning instead of kmeans.
    ## See .auto_init_pois_hmm for why quantile()+cut() is avoided here --
    ## quantile() breaks aren't guaranteed unique (rounded/discretized
    ## continuous data can tie too), which can crash cut(), leave a bin
    ## empty (mean(x[map==j]) = NaN), or produce an NA map entry that
    ## crashes the Gamma0 assignment below. rank(ties.method = "first")
    ## is always a permutation of 1:n, so every bin is non-empty whenever
    ## n >= m.
    rk  <- rank(x, ties.method = "first")
    map <- pmin(pmax(ceiling(rk / n * m), 1), m)
    mu0 <- sapply(1:m, function(j) mean(x[map == j]))
  }

  ## --- per-state SD from the hard-assigned clusters (fallback to
  ##     overall sd(x) if a cluster has <2 points, or zero spread) ---
  sigma0 <- sapply(1:m, function(j) {
    s <- sd(x[map == j])
    if (is.na(s) || s <= 0) sd(x) else s
  })

  ## --- empirical transition matrix from the hard-assigned state sequence ---
  Gamma0 <- matrix(0, m, m)
  for (t in 1:(n - 1)) {
    Gamma0[map[t], map[t + 1]] <- Gamma0[map[t], map[t + 1]] + 1
  }
  Gamma0 <- Gamma0 + 0.5              # small pseudo-count: avoids zero rows
  Gamma0 <- Gamma0 / rowSums(Gamma0)

  ## --- initial-state distribution from marginal cluster frequencies ---
  delta0 <- as.numeric(table(factor(map, levels = 1:m)))
  delta0 <- delta0 / sum(delta0)

  list(mu0 = mu0, sigma0 = sigma0, Gamma0 = Gamma0, delta0 = delta0, cluster = map)
}


## ------------------------------------------------------------
## .auto_init_norm_hmm_vol: a SECOND initializer for cases where
## states differ mainly in SPREAD rather than level
## ------------------------------------------------------------
.auto_init_norm_hmm_vol <- function(x, m = 2, w = NULL) {
  n <- length(x)
  if (is.null(w)) w <- max(3, min(10, floor(n / (2 * m))))

  dev2 <- (x - mean(x))^2
  roll <- sapply(seq_len(n), function(t) {
    lo <- max(1, t - w + 1)
    mean(dev2[lo:t])
  })
  logroll <- log(roll + 1e-8 * var(x))   # log-scale: variances are skewed/positive

  km  <- kmeans(logroll, centers = m, nstart = 25)
  cl  <- km$cluster
  ord <- order(km$centers)               # relabel so state 1 = lowest local variance
  map <- match(cl, ord)

  mu0    <- sapply(1:m, function(j) mean(x[map == j]))
  sigma0 <- sapply(1:m, function(j) {
    s <- sd(x[map == j])
    if (is.na(s) || s <= 0) sd(x) else s
  })

  Gamma0 <- matrix(0, m, m)
  for (t in 1:(n - 1)) {
    Gamma0[map[t], map[t + 1]] <- Gamma0[map[t], map[t + 1]] + 1
  }
  Gamma0 <- Gamma0 + 0.5
  Gamma0 <- Gamma0 / rowSums(Gamma0)

  delta0 <- as.numeric(table(factor(map, levels = 1:m)))
  delta0 <- delta0 / sum(delta0)

  list(mu0 = mu0, sigma0 = sigma0, Gamma0 = Gamma0, delta0 = delta0, cluster = map)
}


## ------------------------------------------------------------
## .sim_norm_hmm: simulate a length-n series from a Normal HMM
## (used only by .norm_hmm_boot below)
## ------------------------------------------------------------
.sim_norm_hmm <- function(n, mu, sigma, Gamma, delta) {
  m <- length(mu)
  state <- integer(n)
  state[1] <- sample(m, 1, prob = delta)
  for (t in 2:n) {
    state[t] <- sample(m, 1, prob = Gamma[state[t - 1], ])
  }
  rnorm(n, mean = mu[state], sd = sigma[state])
}


## ------------------------------------------------------------
## .norm_hmm_hessian_se: asymptotic SEs/CIs for mu and sigma 
## ------------------------------------------------------------
.norm_hmm_hessian_se <- function(fit, x, m = 2) {
  if (!requireNamespace("nlme", quietly = TRUE)) {
    stop("se = \"hessian\" requires the 'nlme' package (normally included ",
         "with R by default). Install it with install.packages(\"nlme\").")
  }
  n <- length(x)
  delta <- fit$delta   # held fixed -- see note above .gamma_logit_pack

  pack <- function(mu, sigma, Gamma) c(mu, log(sigma), .gamma_logit_pack(Gamma))
  unpack <- function(theta) {
    mu    <- theta[1:m]
    sigma <- exp(theta[(m + 1):(2 * m)])
    Gamma <- .gamma_logit_unpack(theta[(2 * m + 1):(2 * m + m * (m - 1))], m)
    list(mu = mu, sigma = sigma, Gamma = Gamma)
  }

  loglik_fn <- function(mu, sigma, Gamma) {
    B <- sapply(1:m, function(j) dnorm(x, mean = mu[j], sd = sigma[j]))
    a <- delta * B[1, ]; c1 <- sum(a); ll <- log(c1); a <- a / c1
    for (t in 2:n) {
      a  <- (a %*% Gamma) * B[t, ]
      ct <- sum(a); ll <- ll + log(ct); a <- a / ct
    }
    as.numeric(ll)
  }

  negloglik <- function(theta) {
    u <- unpack(theta)
    -loglik_fn(u$mu, u$sigma, u$Gamma)
  }
  natural <- function(theta) {
    u <- unpack(theta)
    c(u$mu, u$sigma, as.vector(u$Gamma))
  }

  theta_hat <- pack(fit$mu, fit$sigma, fit$Pmatrix)
  H  <- nlme::fdHess(theta_hat, negloglik)$Hessian   # observed information (Hessian of -loglik)
  Vt <- tryCatch(solve(H), error = function(e) {
    warning("Hessian is not invertible at this fit -- SEs may be unreliable ",
            "(this can happen at a boundary or a poorly separated fit)")
    matrix(NA_real_, length(theta_hat), length(theta_hat))
  })

  J    <- .central_diff_jacobian(natural, theta_hat)   # delta method: map SEs back to the natural scale
  Vnat <- J %*% Vt %*% t(J)
  se_natural <- suppressWarnings(sqrt(diag(Vnat)))

  se_mu    <- se_natural[1:m]
  se_sigma <- se_natural[(m + 1):(2 * m)]
  se_Gamma <- matrix(se_natural[(2 * m + 1):(2 * m + m * m)], m, m)

  out <- data.frame(
    state         = 1:m,
    mu            = fit$mu,
    se_mu         = se_mu,
    mu_lower95    = fit$mu - 1.96 * se_mu,
    mu_upper95    = fit$mu + 1.96 * se_mu,
    sigma         = fit$sigma,
    se_sigma      = se_sigma,
    sigma_lower95 = fit$sigma - 1.96 * se_sigma,
    sigma_upper95 = fit$sigma + 1.96 * se_sigma
  )
  attr(out, "Gamma_se") <- se_Gamma   # SEs for the transition matrix, as a bonus
  out
}


## ------------------------------------------------------------
## .norm_hmm_boot: parametric bootstrap SEs/CIs for mu and sigma
## ------------------------------------------------------------
.norm_hmm_boot <- function(fit, x, m = 2, B = 200,
                            order_by = c("mean", "sd"), progress = TRUE,
                            n_cores = 1, ...) {
  order_by <- match.arg(order_by)
  n <- length(x)

  dots <- list(...)               # whatever n_perturb/maxiter/tol arrived with
  dots$m  <- NULL                 # guard against accidental collisions
  dots$se <- NULL
  dots$order_by <- order_by       # keep replicate fits in the same convention

  ## the main fit already determined whether states differ mainly in
  ## level or in spread (fit$init_method) 
  if (!is.null(fit$init_method) && !is.na(fit$init_method)) {
    dots$init_method <- fit$init_method
  }

  can_fork  <- n_cores > 1 && .Platform$OS.type == "unix"
  can_psock <- n_cores > 1 && !can_fork

  cl <- NULL
  if (can_psock) {
    cl <- parallel::makeCluster(n_cores)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    parallel::clusterExport(
      cl,
      varlist = c(".sim_norm_hmm", ".HmmNorm", ".norm_hmm_em",
                  ".auto_init_norm_hmm", ".auto_init_norm_hmm_vol", ".statdist"),
      envir = environment(.norm_hmm_boot)
    )
    parallel::clusterSetRNGStream(cl)
  }

  one_rep <- function(i) {
    x_sim <- .sim_norm_hmm(n, fit$mu, fit$sigma, fit$Pmatrix, fit$delta)
    fit_b <- tryCatch(
      do.call(.HmmNorm, c(list(x = x_sim, m = m, se = "none"), dots)),
      error = function(e) NULL
    )
    if (is.null(fit_b) || is.null(fit_b$mu) || length(fit_b$mu) != m ||
        anyNA(fit_b$mu)) return(NULL)
    ## fit_b already came back relabeled by .HmmNorm using the same
    ## order_by convention, so no re-sorting needed here
    list(mu = fit_b$mu, sigma = fit_b$sigma)
  }

  if (progress) pb <- txtProgressBar(min = 0, max = B, initial = 0, style = 3)

  chunk_size <- if (n_cores > 1) n_cores else 1

  results   <- list()
  tries     <- 0
  max_tries <- 5 * B
  while (length(results) < B && tries < max_tries) {
    chunk <- min(chunk_size, B - length(results), max_tries - tries)
    tries <- tries + chunk
    batch <- if (can_fork) {
      parallel::mclapply(seq_len(chunk), one_rep, mc.cores = n_cores)
    } else if (can_psock) {
      parallel::parLapply(cl, seq_len(chunk), one_rep)
    } else {
      lapply(seq_len(chunk), one_rep)
    }
    results <- c(results, Filter(Negate(is.null), batch))
    if (progress) setTxtProgressBar(pb, min(length(results), B))
  }
  if (progress) close(pb)

  b <- length(results)
  if (b < B) warning(sprintf("only %d/%d bootstrap fits converged", b, B))

  mu_boot    <- if (b > 0) do.call(rbind, lapply(results, `[[`, "mu"))    else matrix(NA_real_, 0, m)
  sigma_boot <- if (b > 0) do.call(rbind, lapply(results, `[[`, "sigma")) else matrix(NA_real_, 0, m)

  if (nrow(mu_boot) < 2) {
    stop("fewer than 2 bootstrap fits converged -- check .norm_hmm_boot for errors, ",
         "or increase boot_n_perturb")
  }

  se_mu     <- apply(mu_boot, 2, sd, na.rm = TRUE)
  ci_mu     <- apply(mu_boot, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)
  se_sigma  <- apply(sigma_boot, 2, sd, na.rm = TRUE)
  ci_sigma  <- apply(sigma_boot, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)

  data.frame(
    state         = 1:m,
    mu            = fit$mu,
    se_mu         = se_mu,
    mu_lower95    = ci_mu[1, ],
    mu_upper95    = ci_mu[2, ],
    sigma         = fit$sigma,
    se_sigma      = se_sigma,
    sigma_lower95 = ci_sigma[1, ],
    sigma_upper95 = ci_sigma[2, ],
    n_boot        = nrow(mu_boot)
  )
}
