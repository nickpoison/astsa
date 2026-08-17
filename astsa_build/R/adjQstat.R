## ================================================================
## adjQstat
##
## Implements the "Adjusted Box-Pierce" statistic of Kan & Wang (2010,
## "On the distribution of the sample autocorrelation coefficients",
## Journal of Econometrics 154(2), 101-121), eq. (67):
##
##   Q^a_BP = m + sqrt(2m / Var[Q_BP]) * (Q_BP - E[Q_BP])   ~ chi^2_m
##
## where Q_BP = n * sum_{k=1}^m rho_hat(k)^2 is the ordinary Box-Pierce
## statistic, and E[Q_BP], Var[Q_BP] are its EXACT finite-sample mean
## and variance under the null of an uncorrelated (elliptically
## distributed) series -- not the asymptotic chi^2_m approximation
## (mean m, variance 2m) that Q_BP itself only satisfies as n -> Inf.
##
## This is the test that Danioko et al. (2022, Frontiers in Applied
## Mathematics and Statistics 8:873746) build their further rejection-
## region correction on top of; this script implements Kan & Wang's
## Q^a_BP itself, not Danioko et al.'s additional simulation-calibrated
## critical-value adjustment (which requires their fitted regression
## coefficients, not published as a closed-form formula).
##
## E[Q_BP] and Var[Q_BP] are built here from the exact per-lag moments
## rather than Kan & Wang's own further-simplified closed forms for
## E[Q_BP] and E[Q_BP^2] (their eqs. 60 and 62) -- summing the per-lag
## moments directly is mathematically identical (they say so explicitly
## just before their eq. 62) and far less error-prone to transcribe by
## hand than their fully-expanded polynomials.
##
## IMPORTANT: no R interpreter was available to execute/verify this
## code before delivery. Run .abp_selfcheck() below FIRST and confirm
## the Monte Carlo columns agree with the formula columns before
## trusting this on real data.
## ================================================================


## ------------------------------------------------------------
## adjBoxPierce: the actual test.
##   x   : numeric vector (a time series, or residuals -- see note below)
##   lag : number of lags, m
##
## Returns a list modeled on stats::Box.test()'s output: statistic
## (Q^a_BP), parameter (df = m), p.value, plus the raw Q_BP and its
## exact E[]/Var[] for reference.
##
## NOTE ON RESIDUALS / fitdf: Kan & Wang derive E[rho_hat(k)^s] and
## the joint moments under the assumption that x itself is an
## uncorrelated (elliptically distributed) series -- NOT under the
## assumption that x is the residual series from a fitted ARMA(p,q)
## model. The usual fitdf = p+q correction for Box.test() on residuals
## is a heuristic large-sample df adjustment; nothing in Kan & Wang
## (2010) or Danioko et al. (2022) establishes that subtracting fitdf
## from m here (in the chi^2 reference distribution, while still using
## the raw x for Q_BP/E[Q_BP]/Var[Q_BP]) preserves the near-exact size
## properties they demonstrate for a genuinely raw, unfitted series.
## Treat fitdf > 0 here as the same heuristic extension stats::Box.test()
## uses, not as something this paper's derivation directly covers.
## ------------------------------------------------------------

adjQstat <- function(x, lag, fitdf = 0) {
  x <- as.numeric(x)
  n <- sum(!is.na(x))
  m <- lag

  if (m <= fitdf) {
    stop("lag must be greater than fitdf")
  }

  rho <- as.numeric(acf(x, lag.max = m, plot = FALSE, na.action = na.pass)$acf[-1])
  QBP <- n * sum(rho^2)

  mom <- .QBP_moments(n, m)

  df    <- m - fitdf
  Qadj  <- df + sqrt(2 * df / mom$VarQ) * (QBP - mom$EQ)
  pval  <- 1 - pchisq(Qadj, df = df)

  list(statistic = Qadj, parameter = df, p.value = pval,
       method = "Adjusted Box-Pierce (Kan & Wang, 2010, exact moments)",
       data.name = deparse(substitute(x)),
       QBP = QBP, E_QBP = mom$EQ, Var_QBP = mom$VarQ)
}







## ------------------------------------------------------------
## .pp: positive-part operator, a+ = max(a, 0), used throughout
## Kan & Wang's formulas.
## ------------------------------------------------------------
.pp <- function(a) pmax(a, 0)


## ------------------------------------------------------------
## .Erho2: exact E[rho_hat(k)^2], Kan & Wang eq. (39)
## ------------------------------------------------------------
.Erho2 <- function(k, n) {
  (n - k) * (n^2 + n - 3 * k) / (n^2 * (n^2 - 1)) -
    2 * .pp(n - 2 * k) / (n * (n^2 - 1))
}


## ------------------------------------------------------------
## .Erho4: exact E[rho_hat(k)^4], Kan & Wang eq. (41)
## ------------------------------------------------------------
.Erho4 <- function(k, n) {
  term1 <- 3 * (n - k) * (n^3 * (n + 1) * (n + 3) -
                           n^2 * (n^2 + 8 * n + 21) * k +
                           3 * n * (2 * n + 15) * k^2 -
                           35 * k^3) /
    (n^4 * (n^2 - 1) * (n + 3) * (n + 5))

  term2 <- -12 * (2 * n^2 - n * (n + 6) * k + 15 * k^2) * .pp(n - 2 * k) /
    (n^3 * (n^2 - 1) * (n + 3) * (n + 5))

  term3 <- 24 * (.pp(n - 3 * k)^2 - n * .pp(n - 4 * k)) /
    (n^2 * (n^2 - 1) * (n + 3) * (n + 5))

  term1 + term2 + term3
}


## ------------------------------------------------------------
## .Erho2rho2: exact E[rho_hat(j)^2 * rho_hat(k)^2] for j < k,
## Kan & Wang eq. (45)
## ------------------------------------------------------------
.Erho2rho2 <- function(j, k, n) {
  stopifnot(j < k)

  d2jk <- as.numeric(2 * j == k)   # delta_{2j,k}

  A <- -(n - k) * (105 * j^2 * k -
                   (75 * j^2 + 60 * j * k) * n +
                   (36 * j - 3 * j^2 + 15 * k - 3 * j * k) * n^2 +
                   (5 * j + 3 * k - 5) * n^3 +
                   (j - 6) * n^4 -
                   n^5) /
    (n^4 * (n^2 - 1) * (n + 3) * (n + 5))

  B <- -2 * ((15 * j^2 + 9 * n^2 - j * n^2 + n^3) * .pp(n - 2 * k) +
             (15 * k^2 - 24 * k * n + 9 * n^2 - k * n^2 + n^3) * .pp(n - 2 * j) +
             (60 * j * k - 24 * j * n - 4 * n^3) * .pp(n - j - k)) /
    (n^3 * (n^2 - 1) * (n + 3) * (n + 5))

  C <- 2 * (6 * (n - 3 * k) * .pp(n - 2 * j - k) +
            6 * (n - 3 * j) * .pp(n - j - 2 * k) +
            2 * (n - 3 * j) * .pp(n + j - 2 * k) -
            12 * n * .pp(n - 2 * j - 2 * k) +
            4 * (2 * n - 3 * k) * .pp(n - max(2 * j, k)) -
            2 * n * .pp(n + 2 * j - 2 * max(2 * j, k)) -
            2 * n * (n - k)^2 * d2jk) /
    (n^2 * (n^2 - 1) * (n + 3) * (n + 5))

  A + B + C
}


## ------------------------------------------------------------
## .QBP_moments: exact E[Q_BP] and Var[Q_BP] for given n (series
## length) and m (number of lags), built from the per-lag moments
## above via
##   E[Q_BP]   = n   * sum_k E[rho(k)^2]
##   E[Q_BP^2] = n^2 * ( sum_k E[rho(k)^4] + 2 * sum_{j<k} E[rho(j)^2 rho(k)^2] )
##   Var[Q_BP] = E[Q_BP^2] - E[Q_BP]^2
## (Kan & Wang state this decomposition explicitly, just before their
## eq. 62, as the route to Var[Q_BP] -- their eq. 62 is only the fully
## expanded/simplified closed form of the same double sum, kept for
## computational speed in their own code, not a different quantity.)
## ------------------------------------------------------------
.QBP_moments <- function(n, m) {
  ks <- 1:m

  S2 <- sum(vapply(ks, .Erho2, numeric(1), n = n))
  S4 <- sum(vapply(ks, .Erho4, numeric(1), n = n))

  Scross <- 0
  if (m >= 2) {
    for (j in 1:(m - 1)) {
      for (k in (j + 1):m) {
        Scross <- Scross + .Erho2rho2(j, k, n)
      }
    }
  }

  EQ   <- n * S2
  EQ2  <- n^2 * (S4 + 2 * Scross)
  VarQ <- EQ2 - EQ^2

  list(EQ = EQ, VarQ = VarQ)
}




## ================================================================
## Self-check: run this FIRST.
##
## Compares the formula-based E[Q_BP]/Var[Q_BP] against a Monte Carlo
## estimate under the null (iid N(0,1) series) for a few (n, m)
## combinations. If the "formula" and "MC" columns disagree by more
## than MC noise, something in the transcription above is wrong --
## please flag it back rather than trusting adjBoxPierce() on real data.
## ================================================================
.abp_selfcheck <- function(n_vals = c(60, 120, 300),
                            m_vals = c(5, 10, 20),
                            B = 20000, seed = 1) {
  set.seed(seed)
  out <- data.frame()

  for (n in n_vals) {
    for (m in m_vals) {
      if (m >= n) next

      form <- .QBP_moments(n, m)

      QBP_sim <- numeric(B)
      for (b in seq_len(B)) {
        x <- rnorm(n)
        rho <- as.numeric(acf(x, lag.max = m, plot = FALSE)$acf[-1])
        QBP_sim[b] <- n * sum(rho^2)
      }

      out <- rbind(out, data.frame(
        n = n, m = m,
        E_formula   = form$EQ,
        E_MC        = mean(QBP_sim),
        Var_formula = form$VarQ,
        Var_MC      = var(QBP_sim)
      ))
    }
  }

  print(out, row.names = FALSE)
  invisible(out)
}


## ================================================================
## Example usage
## ================================================================
if (FALSE) {

  ## 0. RUN THIS FIRST -- confirms the formulas above are transcribed
  ##    correctly before you trust adjBoxPierce() on real data.
  .abp_selfcheck()

  ## 1. On a raw series
  set.seed(1)
  x <- rnorm(200)
  adjBoxPierce(x, lag = 10)

  ## 2. Side-by-side with the ordinary Box-Pierce / Ljung-Box tests
  Box.test(x, lag = 10, type = "Box-Pierce")
  Box.test(x, lag = 10, type = "Ljung-Box")
  adjBoxPierce(x, lag = 10)

  ## 3. On ARMA residuals (heuristic fitdf adjustment -- see note above)
  fit <- arima(x, order = c(1, 0, 0))
  adjBoxPierce(residuals(fit), lag = 10, fitdf = 1)
}
