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
  \item{x}{Numeric vector: the time series (or model residuals -- see
    \strong{Residuals and fitdf} below) to test.}
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
\details{
The ordinary Box-Pierce statistic is
\deqn{Q_{BP} = n \sum_{k=1}^{m} \hat\rho(k)^2,}
and is conventionally compared to a \eqn{\chi^2_m} distribution, which
assumes \eqn{E[Q_{BP}] = m} and \eqn{\mathrm{Var}[Q_{BP}] = 2m}. In
finite samples this is often a poor approximation, especially when
\code{lag} is not small relative to \code{length(x)}, leading to
Box-Pierce/Ljung-Box type I error rates that deviate substantially from
their nominal level.

Kan and Wang (2010) derive closed-form expressions for the
\emph{exact} mean and variance of \eqn{Q_{BP}} under the null of an
uncorrelated, elliptically distributed series, and use them to define
the adjusted statistic
\deqn{Q^a_{BP} = m + \sqrt{\frac{2m}{\mathrm{Var}[Q_{BP}]}}
  \left(Q_{BP} - E[Q_{BP}]\right) \;\sim\; \chi^2_m,}
which by construction has \eqn{E[Q^a_{BP}] = m} and
\eqn{\mathrm{Var}[Q^a_{BP}] = 2m} exactly, matching the first two
moments of the reference \eqn{\chi^2_m} distribution regardless of
sample size.

\code{E_QBP} and \code{Var_QBP} are computed here from the exact
per-lag moments \eqn{E[\hat\rho(k)^2]}, \eqn{E[\hat\rho(k)^4]}, and the
joint moments \eqn{E[\hat\rho(j)^2 \hat\rho(k)^2]} for \eqn{j < k}
(Kan and Wang's eqs. 39, 41, and 45), via
\deqn{E[Q_{BP}] = n \sum_{k=1}^{m} E[\hat\rho(k)^2],}
\deqn{E[Q_{BP}^2] = n^2 \left( \sum_{k=1}^{m} E[\hat\rho(k)^4] +
  2 \sum_{j<k} E[\hat\rho(j)^2 \hat\rho(k)^2] \right),}
\deqn{\mathrm{Var}[Q_{BP}] = E[Q_{BP}^2] - E[Q_{BP}]^2.}
This is mathematically identical to Kan and Wang's own further-
simplified closed forms for \eqn{E[Q_{BP}]} and \eqn{E[Q_{BP}^2]} (their
eqs. 60 and 62), which are kept only for computational speed in their
own code; summing the per-lag moments directly is less error-prone to
reproduce and is what is implemented here.
}
\section{Relationship to Danioko et al. (2022)}{
Danioko, Zheng, Anderson, Barrett, and Rakovski (2022) propose a
\emph{further} correction on top of \eqn{Q^a_{BP}}: rather than
comparing \eqn{Q^a_{BP}} to an ordinary \eqn{\chi^2_m} critical value,
they inflate the rejection region itself, using a regression model
fit to a large simulation study spanning many sample sizes and lags,
to bring type I error rates even closer to nominal than \eqn{Q^a_{BP}}
alone achieves. \code{adjQstat} implements Kan and Wang's
\eqn{Q^a_{BP}} only; Danioko et al.'s additional rejection-region
inflation is not implemented, as it depends on their fitted regression
coefficients, which are not published in closed form.
}
\section{Residuals and fitdf}{
Kan and Wang derive \eqn{E[\hat\rho(k)^s]} and the joint moments under
the assumption that \code{x} itself is directly an uncorrelated,
elliptically distributed series -- not under the assumption that
\code{x} is the residual series from a fitted ARMA(p, q) model. The
\code{fitdf} argument here follows the same convention as
\code{\link{Box.test}} (subtracting \code{fitdf} degrees of freedom
from the \eqn{\chi^2} reference distribution), but this is a heuristic
extension carried over from the asymptotic theory; neither Kan and Wang
(2010) nor Danioko et al. (2022) establish that the exact-moment
correction retains its near-nominal size properties once \code{x} is a
residual series rather than a raw one.
}
\seealso{
\code{\link{Box.test}}
}
\references{
Kan, R., Wang, X. (2010). On the distribution of the sample
autocorrelation coefficients. \emph{Journal of Econometrics}, 154(2),
101-121.

Danioko, S., Zheng, J., Anderson, K., Barrett, A., Rakovski, C. S.
(2022). A Novel Correction for the Adjusted Box-Pierce Test.
\emph{Frontiers in Applied Mathematics and Statistics}, 8:873746.

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
