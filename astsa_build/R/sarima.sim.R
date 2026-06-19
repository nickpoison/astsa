sarima.sim <-
function(ar=NULL, d=0, ma=NULL, sar=NULL, D=0, sma=NULL, S=NULL, n=500,
           rand.gen=rnorm, innov=NULL, burnin=NA, t0=0, red.tol=.1, ...)
{
  if (length(burnin) > 1) burnin <- burnin[1]
  if (length(ar) == 1 && ar == 0) ar <- NULL
  if (length(ma) == 1 && ma == 0) ma <- NULL
  po <- length(ar)
  qo <- length(ma)

  if (po > 0 && min(Mod(polyroot(c(1, -ar)))) <= 1)
      stop("AR side is not causal")
  if (qo > 0 && min(Mod(polyroot(c(1,  ma)))) <= 1)
      stop("MA side is not invertible")

  if (is.null(S)) {
    if (length(sar) > 0 || length(sma) > 0)
        stop("the seasonal period 'S' is not specified")
    burnin_default <- 50 + po + qo + d
    if (is.na(burnin) || burnin != round(burnin) || burnin < 0)
        burnin <- burnin_default
    num   <- n + burnin
    innov <- if (is.null(innov)) rand.gen(num, ...) else innov
    x     <- .arima_sim(model=list(order=c(po, d, qo), ar=ar, ma=ma),
                        n=num, innov=innov, ...)
    Po <- 0; Qo <- 0; SAR <- NULL; SMA <- NULL
  } else {
    if (length(sar) == 1 && sar == 0) sar <- NULL
    if (length(sma) == 1 && sma == 0) sma <- NULL
    if (S <= po) stop("AR order should be less than seasonal order 'S'")
    if (S <= qo) stop("MA order should be less than seasonal order 'S'")
    if (D != round(D) || D < 0)
        stop("seasonal difference order 'D' must be a positive integer")
    Po <- length(sar)
    Qo <- length(sma)
    if (S > 0 && Po + Qo + D < 1)
        message("Note that S > 0 but no seasonal parameter is specified")

    # Build seasonal AR polynomial and combine with non-seasonal AR
    if (Po > 0) {
      SAR <- c(1, rep(0, Po * S))
      SAR[seq(S + 1, Po * S + 1, by = S)] <- -sar
      if (min(Mod(polyroot(SAR))) <= 1) stop("AR side is not causal")
      arnew <- -polyMul(if (po > 0) c(1, -ar) else 1, SAR)[-1]
    } else {
      SAR   <- NULL
      arnew <- ar
    }

    # Build seasonal MA polynomial and combine with non-seasonal MA
    if (Qo > 0) {
      SMA <- c(1, rep(0, Qo * S))
      SMA[seq(S + 1, Qo * S + 1, by = S)] <- sma
      if (min(Mod(polyroot(SMA))) <= 1) stop("MA side is not invertible")
      manew <- polyMul(if (qo > 0) c(1, ma) else 1, SMA)[-1]
    } else {
      SMA   <- NULL
      manew <- ma
    }

    arorder      <- length(arnew)
    maorder      <- length(manew)
    burnin_default <- 50 + (D + Po + Qo) * S + d + po + qo
    if (is.na(burnin) || burnin != round(burnin) || burnin < 0)
        burnin <- burnin_default
    num   <- n + burnin
    innov <- if (is.null(innov)) rand.gen(num, ...) else innov
    x     <- .arima_sim(model=list(order=c(arorder, d, maorder),
                                   ar=arnew, ma=manew),
                        n=num, innov=innov, ...)
    if (D > 0) x <- diffinv(x, lag=S, differences=D)
  }

  if (red.tol > 0)
    .red_check(ar=ar, ma=ma, SAR=SAR, SMA=SMA, S=S,
               red.tol=red.tol, po=po, qo=qo, Po=Po, Qo=Qo)

  frq <- ifelse(is.null(S), 1, S)
  x   <- ts(x[(burnin + 1):(burnin + n)], start=t0, frequency=frq)
  return(x)
}


##
.arima_sim <-
function(model, n, innov, ...)
{
  if (length(innov) < n)
    warning(paste("the number of innovations should be at least 'n + burnin' =", n))
  if (n <= 0L)
    stop("'n' must be strictly positive")
  d <- model$order[2L]
  if (d != round(d) || d < 0)
    stop("'d' must be a positive integer")
  x <- ts(innov)
  if (length(model$ma)) {
    x <- filter(x, c(1, model$ma), sides=1L)
    x[seq_along(model$ma)] <- 0
  }
  if (length(model$ar))
    x <- filter(x, model$ar, method="recursive")
  if (d > 0)
    x <- diffinv(x, differences=d)
  as.ts(x)
}


.red_check <-
function(ar, ma, SAR, SMA, S, red.tol, po, qo, Po, Qo)
{
  # Compute roots  
  if (po > 0 && qo > 0) {
    ar_roots  <- 1 / polyroot(c(1, -ar))
    ma_roots  <- 1 / polyroot(c(1,  ma))
    redundant <- any(outer(ar_roots, ma_roots, function(a, b) Mod(a - b)) < red.tol)
    if (redundant) cat("\nWARNING: (Possible) Parameter Redundancy\n")
  }

  if (Po > 0 && Qo > 0) {
    sar_roots <- 1 / polyroot(SAR)
    sma_roots <- 1 / polyroot(SMA)
    redundant <- any(outer(sar_roots, sma_roots, function(a, b) Mod(a - b)) < red.tol)
    if (redundant) cat("\nWARNING: (Possible) Seasonal Parameter Redundancy\n")
  }
}
