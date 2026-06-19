ar.boot <- function(series, order.ar, nboot=500, seed=NULL, plot=TRUE, ...) {

  num   <- length(series)
  tspar <- tsp(series)
  arp   <- order.ar

  fit    <- ar.yw(series, aic=FALSE, order.max=arp)
  m      <- fit$x.mean
  phi    <- as.numeric(fit$ar)
  resids <- na.omit(fit$resid)

  set.seed(seed)

  phi.star <- matrix(0, nboot, arp)
  x.sim    <- matrix(0, num, nboot)

  # Center series
  series.c <- as.numeric(series) - m

  pb <- txtProgressBar(min=0, max=nboot, initial=0, style=3)

  for (i in 1:nboot) {
    setTxtProgressBar(pb, i)

    # Bootstrap residuals: prepend arp zeros as burn-in
    resid.star <- c(rep(0, arp), sample(resids, size=num - arp, replace=TRUE))

    # Simulate centered series
    xc <- series.c                         # centred x*
    for (t in arp:(num - 1)) {
      xc[t + 1] <- sum(phi * xc[t:(t - arp + 1)]) + resid.star[t + 1]
    }

    x.sim[, i]    <- xc + m                # un-center
    phi.star[i, ] <- ar.yw(xc + m, order=arp, aic=FALSE)$ar
  }
  close(pb)

  x.sim    <- ts(x.sim, start=tspar[1], frequency=tspar[3])
  colnames(phi.star) <- paste0('ar', seq_len(arp))

  # Summary statistics
  quants     <- apply(phi.star, 2, quantile,
                      probs=c(.01,.025,.05,.1,.25,.5,.75,.9,.95,.975,.99))
  phi.means  <- colMeans(phi.star)
  bias       <- matrix(phi.means - phi, nrow=1,
                       dimnames=list(NULL, paste0('ar', seq_len(arp))))
  rmse       <- sqrt(diag(var(phi.star)) + drop(bias^2))

  cat('Quantiles:\n');  print(quants,      digits=4)
  cat('\nMean:\n');     print(phi.means,   digits=4)
  cat('\nBias:\n');     print(bias,        digits=4)
  cat('\nrMSE:\n');     print(rmse,        digits=4); cat('\n')

  if (plot) {
    if (arp > 1) {
      tspairs(phi.star, smooth=FALSE, ...)
    } else {
      hist(phi.star, main='', xlab=expression(phi^'*'),
           col=astsa.col(col, .4), breaks='FD', freq=FALSE)
      abline(v=quantile(phi.star, probs=c(.025, .5, .975)), col=6)
    }
  }

  invisible(list(phi.star=phi.star, x.sim=x.sim,
                 mean.star=colMeans(x.sim),
                 var.star=apply(x.sim, 2, var),
                 yw.fit=fit))
}
