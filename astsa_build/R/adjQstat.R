## ------------------------------------------------------------
## adjQstat: the actual test.
##   x   : numeric vector (a time series, or residuals -- see note below)
##   lag : number of lags, m
##
## Returns a list modeled on stats::Box.test()'s output: statistic
## (Q^a_BP), parameter (df = m), p.value, plus the raw Q_BP and its
## exact E[]/Var[] for reference.
##
## ================================================================
## Implements the "Adjusted Box-Pierce" statistic of Kan & Wang (2010,
## "On the distribution of the sample autocorrelation coefficients",
## Journal of Econometrics 154(2), 101-121), eq. (67):


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

  list(statistic = Qadj, df = df, p.value = pval,
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
