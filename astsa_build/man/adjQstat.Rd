\name{adjQstat}
\alias{adjQstat}
\title{Adjusted Box-Pierce Test (Exact Moments)}
\description{
Computes Kan and Wang's (2010) adjusted Box-Pierce statistic, which
recenters and rescales the ordinary Box-Pierce statistic using its
\emph{exact} finite-sample mean and variance (rather than the
asymptotic \eqn{\chi^2_m} mean and variance that the ordinary
Box-Pierce and Ljung-Box statistics only approach as \eqn{n
\to \infty}). This gives a portmanteau test of uncorrelatedness with
much better finite-sample size properties than \code{\link{Box.test}}.
}
\usage{
adjQstat(x, lag, fitdf = 0)
}
\arguments{
  \item{x}{Numeric vector: a time series (or model residuals - see \code{fitdf}) to test.}
  \item{lag}{Number of lags, \code{m}, to include in the test.}
  \item{fitdf}{Degrees of freedom to subtract, if \code{x} is the
    residual series from a fitted ARMA(p, q) model (\code{fitdf = p + q},
    as in \code{\link{Box.test}}). Default \code{0}, appropriate when
    \code{x} is a raw, unfitted series. Must be less than \code{lag}.}
}

\value{
A list with:
  \item{statistic}{The adjusted Box-Pierce statistic, \eqn{Q^a_{BP}}.}
  \item{df}{Degrees of freedom used for the reference
    \eqn{\chi^2} distribution, \code{lag - fitdf}.}
  \item{p.value}{The p-value, \code{1 - pchisq(statistic, parameter)}.}
  \item{method}{A character description of the test.}
  \item{data.name}{The name of the data argument.}
  \item{QBP}{The ordinary (unadjusted) Box-Pierce statistic,
    \eqn{Q_{BP} = n \sum_{k=1}^{m} \hat\rho(k)^2}.}
  \item{E_QBP}{The exact mean of \code{QBP} under the null, used to
    build the adjustment.}
  \item{Var_QBP}{The exact variance of \code{QBP} under the null, used
    to build the adjustment.}
}

\details{ Kan and Wang (2010) derive closed-form expressions for the
\emph{exact} mean and variance of \eqn{Q_{BP}} under the null of an
uncorrelated, elliptically distributed series, and use them to define
the adjusted statistic
\deqn{Q^a_{BP} = m + \sqrt{\frac{2m}{\mathrm{Var}[Q_{BP}]}}
  \left(Q_{BP} - E[Q_{BP}]\right) \;\sim\; \chi^2_m,}
which by construction has \eqn{E[Q^a_{BP}] = m} and
\eqn{\mathrm{Var}[Q^a_{BP}] = 2m} exactly, matching the first two
moments of the reference \eqn{\chi^2_m} distribution regardless of
sample size.
}

\seealso{
\code{\link{Box.test}}
}
\references{
Kan, R., Wang, X. (2010). On the distribution of the sample
autocorrelation coefficients. \emph{Journal of Econometrics}, 154(2),
101-121.


You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}

\examples{
set.seed(1)
x <- rnorm(200)

## compare against the ordinary Box-Pierce and Ljung-Box tests
Box.test(x, lag = 10, type = "Box-Pierce")
Box.test(x, lag = 10, type = "Ljung-Box")
adjQstat(x, lag = 10)[1:3]

## p-values across a range of lags
lags   <- 1:10
res    <- lapply(lags, function(L) adjQstat(x, lag = L))
pvals  <- sapply(res, function(r) r$p.value)
names(pvals) <- lags
pvals

## ARMA residuals + infinite variance :) 
x   <- sarima.sim(ar = c(1.5, -.75), rand.gen=function(n, ...) rt(n, df=2)) + 50
sarima(x, p=2)  # resid diagnostics included in output
sarima(x, p=1)  # wrong p
}
\keyword{ts}
\keyword{htest}
