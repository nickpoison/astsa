\name{ffbs}
\alias{ffbs}
\title{
Forward Filtering Backward Sampling
} 
\description{
FFBS algorithm for state space models
}
\usage{
ffbs(y, A, mu0, Sigma0, Phi, sQ, sR, Ups = NULL, Gam = NULL, input = NULL)
}
\arguments{
  \item{y }{Data matrix, vector or time series.
}
  \item{A }{Observation matrix. Can be constant or an array with 
           \code{dim=c(q,p,n)} if time varying.
}
  \item{mu0 }{Initial state mean.
}
  \item{Sigma0 }{Initial state covariance matrix.
}
  \item{Phi }{State transition matrix.
}
  \item{sQ }{State error covariance matrix is \code{Q = sQ\%*\%t(sQ)} -- see details below. In the univariate case, it is the standard deviation.
}
  \item{sR }{Observation error covariance matrix is \code{R = sR\%*\%t(sR)} -- see details below. In the univariate case, it is the standard deviation.
}
  \item{Ups }{State input matrix.
}
  \item{Gam }{Observation input matrix.
}
  \item{input }{matrix or vector of inputs having the same row dimension as y.
}
}
\details{For a linear state space model,
the FFBS algorithm provides a way to sample a state sequence \eqn{x_{0:n}} 
from the posterior \eqn{\pi(x_{0:n} \mid \Theta, y_{1:n})}
with parameters \eqn{\Theta} and  data \eqn{y_{1:n}}.


The general model  is
\deqn{x_t = \Phi  x_{t-1} + \Upsilon u_{t} +   sQ\,  w_t \quad w_t \sim iid\ N(0,I)}
\deqn{y_t = A_t  x_{t-1} + \Gamma u_{t} +   sR\, v_t \quad v_t \sim iid\ N(0,I)}
where \eqn{w_t \perp v_t}. Consequently the state noise covariance matrix is
\eqn{Q = sQ\, sQ'} and the observation noise covariance matrix is
\eqn{R = sR\, sR'} and \eqn{sQ, sR}  do not have to be square as long as everything is
conformable.


\eqn{x_t} is p-dimensional, \eqn{y_t} is q-dimensional, and  \eqn{u_t} is r-dimensional.
Note that \eqn{sQ\, w_t}  has to be p-dimensional, but  \eqn{w_t} does not, and
 \eqn{sR\, v_t}  has to be q-dimensional, but  \eqn{v_t} does not.
}
\value{
  \item{Xs }{An array of sampled states}
  \item{X0n }{The sampled initial state (because R is 1-based) }
}
\source{Chapter 6 of the Shumway and Stoffer Springer text. 
}
\references{You can find demonstrations of  astsa capabilities at 
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{
D.S. Stoffer
}
\note{
The script uses \code{\link{Kfilter}}.  If \eqn{A_t} is constant wrt time, it is not necessary to
input an array; see the example.  The example below is just one pass of the algorithm; see the example
at \href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md#gibbs-sampling-for-linear-state-space-models}{FUN WITH ASTSA} for the real fun.
}
\examples{
\dontrun{

## -- this is just one pass --##
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

## run one pass of FFBS, plot data, states and sampled states  
run = ffbs(y, A=1, mu0=0, Sigma0=10, Phi=1, sQ=1, sR=3)
tsplot(cbind(y,run$Xs), spaghetti=TRUE, type='o', col=c(8,4), pch=c(1,NA))
legend('topleft', legend=c("y(t)","xs(t)"), lty=1, col=c(8,4), bty="n", pch=c(1,NA))
}
}
\keyword{ ts }