SV.mle <-
function(returns, gamma=0, phi=.95, sQ=.1, alpha=NULL, sR0=1, mu1=-3, sR1=2, rho=NULL,
           feedback=FALSE)
{
  if (!is.null(rho) && abs(rho) >= 1) rho <- 0

  del <- returns
  returns[abs(returns) < 1e-8] <- jitter(returns[abs(returns) < 1e-8], amount=1e-5)

  y   <- log(returns^2)
  num <- length(y)
  if (is.null(alpha)) alpha <- mean(y)

  # --- build init.par and Linn closure depending on feedback/rho ---
  if (feedback) {
    if (is.null(rho)) {
      init.par <- c(gamma, phi, sQ, alpha, sR0, mu1, sR1)
      Linn <- function(para) {
        sv <- .SVfilter(num, y, del,
                        gamma=para[1], phi=para[2], sQ=para[3],
                        alpha=para[4], sR0=para[5], mu1=para[6], sR1=para[7], rho=0)
        k <- k + 1; setTxtProgressBar(pb, k)
        sv$like
      }
      par_names <- c('gamma','phi','sQ','alpha','sigv0','mu1','sigv1')
    } else {
      init.par <- c(gamma, phi, sQ, alpha, sR0, mu1, sR1, rho)
      Linn <- function(para) {
        sv <- .SVfilter(num, y, del,
                        gamma=para[1], phi=para[2], sQ=para[3],
                        alpha=para[4], sR0=para[5], mu1=para[6], sR1=para[7], rho=para[8])
        k <- k + 1; setTxtProgressBar(pb, k)
        sv$like
      }
      par_names <- c('gamma','phi','sQ','alpha','sigv0','mu1','sigv1','rho')
    }
  } else {
    init.par <- c(phi, sQ, alpha, sR0, mu1, sR1)
    Linn <- function(para) {
      sv <- .SVfilter(num, y, del,
                      gamma=0, phi=para[1], sQ=para[2],
                      alpha=para[3], sR0=para[4], mu1=para[5], sR1=para[6], rho=0)
      k <- k + 1; setTxtProgressBar(pb, k)
      sv$like
    }
    par_names <- c('phi','sQ','alpha','sigv0','mu1','sigv1')
  }

  # --- estimation (for all branches) ---
  pb <- txtProgressBar(min=0, max=100, initial=0, style=2, char=' ')
  k  <- 0
  est <- optim(init.par, Linn, NULL, method='BFGS',
               hessian=TRUE, control=list(trace=1, REPORT=5))
  close(pb)

  SE <- sqrt(diag(solve(est$hessian)))
  u  <- rbind(estimates=est$par, SE)
  colnames(u) <- par_names
  cat("<><><><><><><><><><><><><><>\n\n")
  cat("Coefficients:\n")
  print(round(u, 4))
  cat("\n")

  # --- extract final parameters for plotting ---
  if (feedback) {
    gamma <- est$par[1]; phi <- est$par[2]; sQ  <- est$par[3]
    alpha <- est$par[4]; sR0 <- est$par[5]; mu1 <- est$par[6]; sR1 <- est$par[7]
    rho   <- if (is.null(rho)) 0 else est$par[8]
  } else {
    phi   <- est$par[1]; sQ  <- est$par[2]; alpha <- est$par[3]
    sR0   <- est$par[4]; mu1 <- est$par[5]; sR1   <- est$par[6]
    rho   <- 0;          gamma <- 0
  }
  sv <- .SVfilter(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho)

  # --- graphics (for all branches) ---
  old.par <- par(no.readonly=TRUE)
  on.exit(par(old.par))

  layout(matrix(1:2, 2), heights=c(3, 2))

  tapp <- tsp(y)
  tsxp <- ts(sv$Xp, start=tapp[1], frequency=tapp[3])
  tsPp <- ts(sv$Pp, start=tapp[1], frequency=tapp[3])
  Low  <- min(10 * returns, tsxp - 2 * sqrt(tsPp))
  Upp  <- max(10 * returns, tsxp + 2 * sqrt(tsPp)) + .2
  tsplot(cbind(10 * returns, tsxp), col=astsa.col(c(2, 4), .7),
         spaghetti=TRUE, ylim=c(Low, Upp), gg=TRUE, margins=c(0, -.6, 0, 0) + .2)
  xx <- c(time(y), rev(time(y)))
  yy <- c(tsxp - 2 * sqrt(tsPp), rev(tsxp + 2 * sqrt(tsPp)))
  polygon(xx, yy, border=NA, col=astsa.col(4, alpha=.2))
  legend('topright', legend=c('log-volatility', 'returns (\u00D7 10)'),
         lty=1, col=c(4, astsa.col(2, .9)), bty='n')

  # densities
  x       <- seq(-15, 6, by=.01)
  inv_sqrt2pi <- 1 / sqrt(2 * pi)
  f   <- exp(-.5 * (exp(x) - x)) * inv_sqrt2pi
  f0  <- exp(-.5 * x^2      / sR0^2) * (inv_sqrt2pi / sR0)
  f1  <- exp(-.5 * (x-mu1)^2 / sR1^2) * (inv_sqrt2pi / sR1)
  fm  <- .5 * f0 + .5 * f1
  Upp <- max(f, fm)
  tsplot(x, f, yaxt='n', ylab=NA, col=4, ylim=c(0, Upp), gg=TRUE,
         xlab=NA, margins=c(-.6, -.6, 0, 0) + .2)
  lines(x, fm, lty=5, lwd=2, col=5)
  cs <- expression(log ~ chi[1]^2)
  legend('topleft', legend=c(cs, 'normal mixture'), lty=c(1, 5), lwd=1:2, col=4, bty='n')

  output <- list(PredLogVol=tsxp, RMSPE=sqrt(tsPp), Coefficients=t(u))
  invisible(output)
}


.SVfilter <- function(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho) {

  # Precompute scalars used inside the loop
  Q    <- sQ^2
  R0   <- sR0^2
  R1   <- sR1^2
  phi2 <- phi^2
  cov0 <- abs(sQ * sR0) * rho
  cov1 <- abs(sQ * sR1) * rho
  inv_sqrt2pi <- 1 / sqrt(2 * pi)

  # Pre-allocate full-length vectors (avoids repeated reallocation)
  Xp   <- numeric(num)
  Pp   <- numeric(num)
  Pp[1] <- phi2 + Q

  like <- 0

  for (i in 2:num) {
    Pp_prev <- Pp[i-1]
    sig1 <- Pp_prev + R1
    sig0 <- Pp_prev + R0
    k1   <- (phi * Pp_prev + cov1) / sig1
    k0   <- (phi * Pp_prev + cov0) / sig0
    e1   <- y[i] - Xp[i-1] - mu1 - alpha
    e0   <- y[i] - Xp[i-1] - alpha

    # Inline Gaussian densities; reuse 1/sqrt(2pi) and avoid recomputing sig
    den1  <- inv_sqrt2pi / sqrt(sig1) * exp(-.5 * e1^2 / sig1)
    den0  <- inv_sqrt2pi / sqrt(sig0) * exp(-.5 * e0^2 / sig0)
    denom <- .5 * (den1 + den0)        # pi0 = pi1 = 0.5 always
    pit1  <- .5 * den1 / denom
    pit0  <- .5 * den0 / denom

    Xp[i]  <- gamma * del[i-1] + phi * Xp[i-1] + pit0 * k0 * e0 + pit1 * k1 * e1
    Pp_new  <- phi2 * Pp_prev + Q - pit0 * k0^2 * sig0 - pit1 * k1^2 * sig1
    Pp[i]   <- max(Pp_new, 1e-8)      # fix for roundoff errors
    like    <- like - log(denom)       # -0.5*log(pi*den + ...) = -log(0.5*(den0+den1))
  }

  list(Xp=Xp, Pp=Pp, like=like)
}
