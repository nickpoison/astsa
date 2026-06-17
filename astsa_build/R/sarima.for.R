sarima.for <- function(xdata, n.ahead, p = 0, d = 0, q = 0,
                       P = 0, D = 0, Q = 0, S = -1,
                       tol = sqrt(.Machine$double.eps),
                       no.constant = FALSE, plot = TRUE, plot.all = FALSE,
                       ylab = NULL, xreg = NULL, newxreg = NULL,
                       fixed = NULL, pcol = 2, pch = 1, ...) {

  # Capture xreg name from the unevaluated call
  mc        <- match.call()
  xreg_name <- if (!is.null(mc$xreg)) deparse(mc$xreg) else NULL

  # --- Input validation ---
  stopifnot(
    is.numeric(xdata),
    length(xdata) > 0,
    is.numeric(n.ahead), length(n.ahead) == 1, n.ahead >= 1,
    p >= 0, d >= 0, q >= 0,
    P >= 0, D >= 0, Q >= 0
  )

  trans <- is.null(fixed)
  if (is.null(ylab)) ylab <- deparse(substitute(xdata))

  n        <- length(xdata)
  constant <- 1:n
  xmean    <- if (no.constant) NULL else matrix(rep(1, n), dimnames = list(NULL, "xmean"))

  # --- Build common args ---
  base_args <- list(
    x              = xdata,
    order          = c(p, d, q),
    seasonal       = list(order = c(P, D, Q), period = S),
    fixed          = fixed,
    transform.pars = trans,
    optim.control  = list(reltol = tol)
  )

  # --- Sanitize xreg names ---
  .named_xreg <- function(xr, default_name) {
    if (is.null(xr)) return(NULL)
    xr <- as.matrix(xr)
    if (is.null(colnames(xr)))
      colnames(xr) <- if (ncol(xr) == 1) default_name else paste0(default_name, seq_len(ncol(xr)))
    xr
  }

  # --- Fit model & build newxreg for prediction ---
  if (is.null(xreg)) {
    if (d == 0 && D == 0) {
      fitit <- do.call(arima, c(base_args, list(xreg = xmean, include.mean = FALSE)))
      nureg  <- if (no.constant) NULL else rep(1, n.ahead)
    } else if (xor(d == 1, D == 1) && !no.constant) {
      fitit <- do.call(arima, c(base_args, list(xreg = constant)))
      nureg  <- (n + 1):(n + n.ahead)
    } else {
      fitit <- do.call(arima, c(base_args, list(include.mean = !no.constant)))
      nureg  <- NULL
    }
  } else {
    xreg  <- .named_xreg(xreg, xreg_name)
    fitit <- do.call(arima, c(base_args, list(xreg = xreg)))
    nureg  <- newxreg
  }

  # --- Forecast ---
  fore <- predict(fitit, n.ahead, newxreg = nureg)

  # --- Plot ---
  if (plot) {
#    old.par <- par(no.readonly = TRUE)
#    on.exit(par(old.par), add = TRUE)

    U  <- fore$pred + 2 * fore$se
    L  <- fore$pred - 2 * fore$se
    U1 <- fore$pred + fore$se
    L1 <- fore$pred - fore$se
    a  <- ifelse(plot.all, 1, max(1, n - 100))

    minx <- min(xdata[a:n], L,  na.rm = TRUE)
    maxx <- max(xdata[a:n], U,  na.rm = TRUE)

    t1   <- xy.coords(xdata, y = NULL)$x
    strt <- if (length(t1) < 101) t1[1] else t1[length(t1) - 100]
    t2   <- xy.coords(fore$pred, y = NULL)$x
    endd <- t2[length(t2)]
    if (plot.all) strt <- time(xdata)[1]

    typel    <- ifelse(plot.all, "l", "o")
    typel    <- ifelse(anyNA(xdata), "o", typel)
    xdatanew <- ts(c(xdata, fore$pred),
                   start     = tsp(xdata)[1],
                   frequency = tsp(xdata)[3])

    tsplot(xdatanew, type = typel,
           xlim = c(strt, endd), ylim = c(minx, maxx),
           ylab = ylab, pch = pch, ...)

    xx <- c(time(U), rev(time(U)))
    polygon(xx, c(L,  rev(U)),  border = 8, col = gray(0.6, alpha = 0.2))
    polygon(xx, c(L1, rev(U1)), border = 8, col = gray(0.6, alpha = 0.2))
    lines(fore$pred, col = pcol, type = "o", pch = pch)
  }

  return(fore)
}
