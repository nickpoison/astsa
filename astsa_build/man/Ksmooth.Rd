\name{Ksmooth}
\alias{Ksmooth}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Quick Kalman Smoother
}
\description{
Returns the smoother values for various linear  state space models
(version 1 or 2 - see details). The predicted and filtered values and
 the likelihood at the given parameter values are also returned (via \code{Kfilter}),
}
\usage{
Ksmooth(y, A, mu0, Sigma0, Phi, sQ, sR, Ups = NULL, Gam = NULL, 
         input = NULL, S = NULL, version = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{
data matrix (n \code{x} q), vector or time series, n = number of observations}
  \item{A}{
can be constant or an array with dimension \code{dim=c(q,p,n)} if time varying (see details)
}
  \item{mu0}{
initial state mean vector (p \code{x} 1)
}
  \item{Sigma0}{
initial state covariance matrix (p \code{x} p)
}
  \item{Phi}{
state transition matrix (p \code{x} p)
}
  \item{sQ}{
state error pre-matrix (see details)
}
  \item{sR}{
observation error pre-matrix (see details)
}
  \item{Ups}{
state input matrix (p \code{x} r); not necessary to specify if not needed
}
  \item{Gam}{
observation input matrix (q \code{x} r); not necessary to specify if not needed
}
  \item{input}{
matrix (n \code{x} r) or vector of inputs having the same row dimension (n) as y; not necessary to specify if not needed
}
  \item{S}{
covariance matrix (p \code{x} q) between state and observation errors; not necessary to specify if not needed and only used if version=2.
}
  \item{version}{
either 1 (default) or 2; version 2 allows for correlated errors
}
}
\details{This script replaces \code{Ksmooth0}, \code{Ksmooth1}, and \code{Ksmooth2} by combining all
cases. The major difference is how to specify the covariance matrices; in particular, 
\code{sQ = t(cQ)} and \code{sR = t(cR)} where \code{cQ} and \code{cR} were used in \code{Kfilter0-1-2} scripts.

The states \eqn{x_t} are p-dimensional, the data \eqn{y_t} are q-dimensional, and 
the inputs \eqn{u_t} are r-dimensional for \eqn{t=1, \dots, n}. The initial state is \eqn{x_0 \sim N(\mu_0, \Sigma_0)}.

The measurement matrices \eqn{A_t} can be constant or time varying.  If   time varying, they should be entered as an array of dimension \code{dim = c(q,p,n)}.  Otherwise, just enter the constant value making sure it has the appropriate \eqn{q \times p} dimension.

Version 1 (default): The general model  is 
\deqn{x_t = \Phi  x_{t-1} + \Upsilon u_{t} +   sQ\,  w_t \quad w_t \sim iid\ N(0,I)}
\deqn{y_t = A_t  x_{t-1} + \Gamma u_{t} +   sR\, v_t \quad v_t \sim iid\ N(0,I)}
where \eqn{w_t \perp v_t}. Consequently the state noise covariance matrix is
\eqn{Q = sQ\, sQ'} and the observation noise covariance matrix is
\eqn{R = sR\, sR'} and \eqn{sQ, sR}  do not have to be square as long as everything is
conformable.  Notice the specification of the state and observation covariances has changed from the original scripts.

Version 2 (correlated errors): The general model  is
\deqn{x_{t+1} = \Phi  x_{t} + \Upsilon u_{t+1} +   sQ\,  w_t \quad w_t \sim iid\ N(0,I)}
\deqn{y_t = A_t  x_{t-1} + \Gamma u_{t} +   sR\, v_t \quad v_t \sim iid\ N(0,I)}
where \eqn{\text{Cov}(w_t, v_t) = S}.


Note that in either version, \eqn{sQ\, w_t}  has to be p-dimensional, but  \eqn{w_t} does not, and
 \eqn{sR\, v_t}  has to be q-dimensional, but  \eqn{v_t} does not.
 }

 \value{ 
\item{Xs }{state smoothers}
\item{Ps }{smoother mean square error}
\item{X0n }{initial mean smoother}
\item{P0n }{initial smoother covariance}
\item{J0 }{initial value of the J matrix}
\item{J }{the J matrices}
\item{Xp }{state predictors}
\item{Pp }{mean square prediction error}
\item{Xf }{state filters}
\item{Pf }{mean square filter error}
\item{like }{negative of the log likelihood}
\item{innov }{innovation series}
\item{sig }{innovation covariances}
}

\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\note{Note that \code{Ksmooth} is similar to \code{Ksmooth-0-1-2} except that only the essential values need to be entered (and come first in the statement); the optional values such as 
   \code{input} are set to \code{NULL} by default if they are not needed. This version is faster
   than the older versions. The biggest change was to how the covarainces are specified. For example, if you have code that used \code{Ksmooth1}, just use \code{sQ = t(cQ)} and \code{sR = t(cR)} here.
}
\author{D.S. Stoffer
}
\seealso{
\code{\link{Kfilter}}
}
\examples{
# generate some data
 set.seed(1)
 sQ  = 1; sR = 3; n = 100  
 mu0 = 0; Sigma0 = 10; x0 = rnorm(1,mu0,Sigma0)
 w = rnorm(n); v = rnorm(n)
 x = c(x0 + sQ*w[1]);  y = c(x[1] + sR*v[1])   # initialize
for (t in 2:n){
  x[t] = x[t-1] + sQ*w[t]
  y[t] = x[t] + sR*v[t]   
  }
# run and plot the filter  
run = Ksmooth(y, A=1, mu0, Sigma0, Phi=1, sQ, sR)
tsplot(cbind(y,run$Xs), spaghetti=TRUE, type='o', col=c(4,6), pch=c(1,NA))
legend('topleft', legend=c("y(t)","Xs(t)"), lty=1, col=c(4,6), bty="n", pch=c(1,NA))
}
\keyword{ ts }
