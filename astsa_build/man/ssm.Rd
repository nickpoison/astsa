\name{ssm}
\alias{ssm}
\title{State Space Model
}
\description{
Fits a simple univariate state space model to data. The parameters
are estimated (the state regression parameter may be fixed).  State 
predictions, filters, and smoothers
and corresponding error variances are evaluated at the estimates.  The sample
size must be at least 20.
}
\usage{
ssm(y, A, phi, alpha, sigw, sigv, fixphi = FALSE)
}
\arguments{
  \item{y}{
data
}
  \item{A}{
measurement value (fixed constant)
}
  \item{phi}{
initial value of phi, may be fixed
}
  \item{alpha}{
initial value for alpha
}
  \item{sigw}{
initial value for sigma[w]
}
  \item{sigv}{
initial value for sigma[v]
}
  \item{fixphi}{
if TRUE, the phi parameter is fixed
}
}
\details{The script works for a specific univariate state space model,
\deqn{x_t = \alpha + \phi x_{t-1} + w_t \quad \text{and} \quad y_t = A x_t + v_t.}
The initial state conditions use a default calculation and cannot be specified.
The parameter estimates are printed and the script returns the state predictors and
smoothers.  The regression parameter \eqn{\phi} may be fixed.
}
\value{At the MLEs, these are returned invisibly:
\item{Xp }{time series - state prediction, \eqn{x_t^{t-1}}}
\item{Pp }{corresponding MSPEs, \eqn{P_t^{t-1}}}
\item{Xf }{time series - state filter, \eqn{x_t^t}}
\item{Pf }{corresponding MSEs, \eqn{P_t^t}}
\item{Xs }{time series - state smoother, \eqn{x_t^n}}
\item{Ps }{corresponding MSEs, \eqn{P_t^n}}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\examples{
\dontrun{

u = ssm(gtemp_land, A=1, alpha=.01, phi=1, sigw=.05, sigv=.15)
tsplot(gtemp_land, type='o', col=4)
lines(u$Xs, col=6, lwd=2)
}
}
\author{D.S. Stoffer
}
\keyword{ ts }
