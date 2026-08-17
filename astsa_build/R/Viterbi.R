Viterbi <-
function(fit, x = NULL, type = c("auto", "HmmFit", "msmFit"),
         family = c("auto", "pois", "norm"), use = NULL){
##########################################################################
# Viterbi decoding for a fitted hidden-state / Markov-switching model.
# One call, dispatching on 'type' to build the log-likelihood matrix, log
# transition matrix, and log initial-state distribution from either:
#
#   type = "HmmFit"  an object returned by HmmFit()      (Poisson/Normal HMM)
#   type = "msmFit"  an object returned by MSwM::msmFit() (Markov-switching)
#
# type = "auto" (default) detects which one 'fit' is: msmFit objects are
# S4 (class "MSM.lm"/"MSM.glm"), HmmFit objects are plain lists.
#
#   fit    : the fitted model object (see above)
#   x      : (HmmFit only) optional; the data vector originally passed to
#            HmmFit(). HmmFit() now stores this on the fit object itself
#            (fit$x), so x normally doesn't need to be supplied here --
#            pass it only to override fit$x (e.g. decoding some other
#            series under the same fitted parameters). Unused/ignored for
#            type = "msmFit" (msmFit already stores regime-conditional
#            residuals on the fit object).
#   family : (HmmFit only) "pois", "norm", or "auto" (default; detected
#            from fit$mu)
#   use    : initial-state prior. Defaults depend on type:
#              HmmFit: "delta" (fit's fitted initial-state estimate) or
#                      "stationary" (fit$pis)
#              msmFit: "stationary" (stationary dist. of fit@transMat,
#                      the safer default) or "iniProb" (fit@iniProb --
#                      MSwM's own docs describe this slot ambiguously as
#                      "initial values of the parameters", so it is NOT
#                      guaranteed to be the initial-state distribution)
#
# The actual dynamic-programming recursion lives in the internal
# .viterbi_core(), shared by both branches.
##########################################################################

  type <- match.arg(type)
  if (type == "auto") {
    type <- if (isS4(fit)) "msmFit" else "HmmFit"
  }

  if (type == "HmmFit") {

    family <- match.arg(family)
    if (family == "auto") family <- if (!is.null(fit$mu)) "norm" else "pois"
    if (is.null(use)) use <- "delta"
    use <- match.arg(use, c("delta", "stationary"))

    if (is.null(x)) {
      if (is.null(fit$x)) {
        stop("'x' was not supplied and fit$x is not present -- either pass ",
             "x explicitly, or re-fit with the current HmmFit(), which ",
             "stores the data on the fit object automatically.")
      }
      x <- fit$x
    }
    x <- as.numeric(x)
    m <- nrow(fit$Pmatrix)

    loglik <- switch(family,
      pois = sapply(1:m, function(j) dpois(x, lambda = fit$lambda[j], log = TRUE)),
      norm = sapply(1:m, function(j) dnorm(x, mean = fit$mu[j], sd = fit$sigma[j], log = TRUE))
    )

    logA  <- log(fit$Pmatrix)
    logpi <- log(if (use == "delta") fit$delta else fit$pis)

    out <- .viterbi_core(loglik, logA, logpi)
    out$family <- family
    out

  } else {

    if (is.null(use)) use <- "stationary"
    use <- match.arg(use, c("stationary", "iniProb"))

    m      <- fit@k
    errmat <- fit@Fit@error          # T x k, residuals under each regime
    std    <- fit@std                # length k

    loglik <- sapply(1:m, function(j) dnorm(errmat[, j], mean = 0, sd = std[j], log = TRUE))

    logA  <- log(fit@transMat)
    pi0   <- if (use == "iniProb") fit@iniProb else .statdist(fit@transMat)
    logpi <- log(pi0)

    out <- .viterbi_core(loglik, logA, logpi)
    out$regimes <- out$states        # alias, since MSwM calls states "regimes"
    out
  }
}


.viterbi_core <-
function(loglik, logA, logpi){
##########################################################################
# Generic log-space Viterbi recursion, shared by both branches of
# Viterbi() above.
#   loglik : T x m matrix, loglik[t, j] = log p(obs_t | state = j)
#   logA   : m x m matrix, logA[i, j]   = log P(state_t=j | state_{t-1}=i)
#   logpi  : length-m vector, logpi[j]  = log P(state_1 = j)
##########################################################################

  Tn <- nrow(loglik)
  m  <- ncol(loglik)

  delta <- matrix(-Inf, Tn, m)   # delta[t, j] = log prob of best path ending in state j at time t
  psi   <- matrix(0L, Tn, m)     # psi[t, j]   = argmax predecessor state

  delta[1, ] <- logpi + loglik[1, ]

  for (t in 2:Tn) {
    for (j in 1:m) {
      scores      <- delta[t - 1, ] + logA[, j]
      psi[t, j]   <- which.max(scores)
      delta[t, j] <- max(scores) + loglik[t, j]
    }
  }

  states <- integer(Tn)
  states[Tn] <- which.max(delta[Tn, ])
  for (t in (Tn - 1):1) {
    states[t] <- psi[t + 1, states[t + 1]]
  }

  list(states = states, logprob = max(delta[Tn, ]), delta = delta, psi = psi)
}
