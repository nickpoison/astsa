\name{ssm}
\alias{ssm}
\title{State Space Model
}
\description{
Fits a simple univariate state space model, x[t] = alpha + phi x[t-1] + w[t],
and y[t] = A x[t] + v[t].  The parameters alpha, phi, sigma[w] and sigma[v]
are estimated; parameter phi may be fixed.  State predictions and smoothers
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
\details{The script works for a specific univariate state space model.
The initial state conditions use a default calculation and cannot be specified. 
The parameter estimates are printed and the script returns the state predictors and
smoothers. 
}
\value{At the MLEs, these are returned invisibly:
\item{Xp }{time series - state prediction, \eqn{x_t^t-1}}
\item{Pp }{corresponding MSPEs, \eqn{P_t^t-1}}
\item{Xf }{time series - state filter, \eqn{x_t^t}}
\item{Pf }{corresponding MSEs, \eqn{P_t^t}}
\item{Xs }{time series - state smoother, \eqn{x_t^n}}
\item{Ps }{corresponding MSEs, \eqn{P_t^n}}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{D.S. Stoffer
}
\keyword{ ts }
