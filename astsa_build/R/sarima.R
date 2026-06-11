sarima <- function(xdata, p = 0, d = 0, q = 0,
                   P = 0, D = 0, Q = 0, S = -1,
                   details = TRUE, xreg = NULL, Model = TRUE,
                   fixed = NULL, tol = sqrt(.Machine$double.eps),
                   no.constant = FALSE, col = 1, ...) {

  # Capture xreg name from the unevaluated call
  mc        <- match.call()
  xreg_name <- if (!is.null(mc$xreg)) deparse(mc$xreg) else NULL

  # --- Input validation ---
  stopifnot(
    is.numeric(xdata),
    length(xdata) > 0,
    p >= 0, d >= 0, q >= 0,
    P >= 0, D >= 0, Q >= 0
  )

  trans    <- is.null(fixed)
  trc      <- as.integer(details)
  n        <- length(xdata)
  constant <- 1:n
  xmean    <- if (no.constant) NULL else matrix(rep(1, n), dimnames=list(NULL, 'xmean'))

  # --- Build common args  ---
  base_args <- list(
    x              = xdata,
    order          = c(p, d, q),
    seasonal       = list(order = c(P, D, Q), period = S),
    fixed          = fixed,
    transform.pars = trans,
    optim.control  = list(trace = trc, REPORT = 1, reltol = tol)
  )

  # --- Sanitize xreg names ---
  .named_xreg <- function(xr, default_name) {
    if (is.null(xr)) return(NULL)
    xr <- as.matrix(xr)
    if (is.null(colnames(xr)))
      colnames(xr) <- if (ncol(xr) == 1) default_name else paste0(default_name, seq_len(ncol(xr)))
    xr
  }

  # --- Fit model ---
  if (is.null(xreg)) {
    if (d == 0 && D == 0) {
      fitit <- do.call(arima, c(base_args, list(xreg = xmean, include.mean = FALSE)))
    } else if (xor(d == 1, D == 1) && !no.constant) {
      fitit <- do.call(arima, c(base_args, list(xreg = constant)))
    } else {
      fitit <- do.call(arima, c(base_args, list(include.mean = !no.constant)))
    }
  } else {
    xreg  <- .named_xreg(xreg, xreg_name)
    fitit <- do.call(arima, c(base_args, list(xreg = xreg)))
  }

  # --- Coefficients & statistics ---
  coefs   <- if (is.null(fixed)) fitit$coef else fitit$coef[is.na(fixed)]
  k       <- length(coefs)
  n       <- fitit$nobs
  dfree   <- n - k
  t.value <- coefs / sqrt(diag(fitit$var.coef))
  p.two   <- pf(t.value^2, df1 = 1, df2 = dfree, lower.tail = FALSE)
  ttabl   <- round(cbind(Estimate = coefs, SE = sqrt(diag(fitit$var.coef)),
                         t.value, p.value = p.two), 4)

  # --- Information criteria ---
  AIC  <- AIC(fitit) / n
  BIC  <- BIC(fitit) / n
  AICc <- (n * AIC + (2 * k^2 + 2 * k) / (n - k - 1)) / n

  # --- Print summary ---
  cat("<><><><><><><><><><><><><><>\n\n")
  if (k > 0) {
    cat("Coefficients:\n")
    print(ttabl)
    cat("\n")
  }
  cat(sprintf("sigma^2 estimated as %.6g on %d degrees of freedom\n\n",
              fitit$sigma2, dfree))
  cat(sprintf("AIC = %.4f   AICc = %.4f   BIC = %.4f\n\n", AIC, AICc, BIC))

  out <- list(
    fit                = fitit,
    sigma2             = fitit$sigma2,
    degrees_of_freedom = dfree,
    t.table            = ttabl,
    ICs                = c(AIC = AIC, AICc = AICc, BIC = BIC)
  )

  # --- Diagnostics plots ---
  if (details) {
    old.par <- par(no.readonly = TRUE)
    on.exit(par(old.par), add = TRUE)

    layout(matrix(c(1, 2, 4, 1, 3, 4), ncol = 2))
    par(cex = 0.85)

    rs     <- fitit$residuals
    stdres <- rs / sqrt(fitit$sigma2)

    # [1] Standardised residuals
    lt <- ifelse(anyNA(xdata), "o", "l")
    tsplot(stdres, main = "Standardized Residuals", ylab = "",
           col = col, type = lt, ...)
    if (Model) {
      model_label <- if (S < 0) {
        bquote("Model: (" ~ .(p) * "," * .(d) * "," * .(q) ~ ")")
      } else {
        bquote("Model: (" ~ .(p) * "," * .(d) * "," * .(q) ~ ")" ~
                 "\u00D7" ~ "(" ~ .(P) * "," * .(D) * "," * .(Q) ~ ")" [~ .(S)])
      }
      title(model_label, adj = 0, cex.main = 0.95)
    }

    # [2] ACF of residuals
    acf1(rs, max.lag = NULL, main = "ACF of Residuals", col = col, ...)

    # [3] Normal Q-Q plot
    QQnorm(stdres, col = col, main = "Normal Q-Q Plot of Std Residuals", ...)

    # [4] Ljung-Box p-values  
    nlag <- min(ifelse(S < 7, 20, 3 * S), 52)
    ppq  <- p + q + P + Q - sum(!is.na(fixed))
    nlag <- max(nlag, ppq + 8)

    lags  <- (ppq + 1):nlag
    stats <- vapply(lags,
                    function(i) Box.test(rs, i, type = "Ljung-Box")$statistic,
                    numeric(1))
    pval  <- pchisq(stats, lags - ppq, lower.tail = FALSE)

    tsplot(lags, pval, type = "p",
           xlab = "LAG (H)", ylab = "p value",
           ylim = c(-0.14, 1),
           main = "p values for Ljung-Box Statistic",
           col = col, minor = FALSE, ...)
    abline(h = 0.05, lty = 2, col = 4)
  }

  invisible(out)
}
