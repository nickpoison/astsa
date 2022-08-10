\name{ffbs}
\alias{ffbs}
\title{
Forward Filter Backward Sampling
}
\description{
FFBS algorithm for state space models
}
\usage{
ffbs(y, A, mu0, Sigma0, Phi, Ups, Gam, sQ, sR, input)
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
  \item{Ups }{State input matrix; use \code{Ups = 0} if not needed.
}
  \item{Gam }{Observation input matrix; use \code{Gam = 0} if not needed.
}
  \item{sQ }{Pre-state error covariance matrix is \code{Q = t(sQ)\%*\%sQ} -- see details below. In the univariate case, it is the standard deviation.
}
  \item{sR }{Pre-observation error covariance matrix is \code{R = t(sR)\%*\%sR} -- see details below. In the univariate case, it is the standard deviation.
}
  \item{input }{matrix or vector of inputs having the same row dimension as y; use \code{input = 0} if not needed
}
}
\details{Refer to Section 6.12 of edition 4 text. For a linear state space model,
the FFBS algorithm provides a way to sample a state sequence \eqn{x_{0:n}} 
from the posterior \eqn{\pi(x_{0:n} \mid \Theta, y_{1:n})}
with parameters \eqn{\Theta} and  data \eqn{y_{1:n}} as described
in Procedure 6.1.



The general model  is
\deqn{x_t = \Phi  x_{t-1} + \Upsilon u_{t} +   sQ\,  w_t \quad w_t \sim iid\ N(0,I)}
\deqn{y_t = A_t  x_{t-1} + \Gamma u_{t} +   sR\, v_t \quad v_t \sim iid\ N(0,I)}
where \eqn{w_t \perp v_t}. Consequently the state noise covariance matrix is
\eqn{Q = sQ' sQ} and the observation noise covariance matrix is
\eqn{R = sR' sR}.


\eqn{x_t} is p-dimensional and \eqn{y_t} is q-dimensional. 
With everything being  conformable,  \eqn{u_t} is \eqn{r\times 1} vector of inputs, 
\eqn{\Upsilon} is \eqn{p \times r} and \eqn{\Gamma} is \eqn{q \times r};
either of these matrices may be the zero matrix.
}
\value{
  \item{xs }{A p-dimensional matrix of sampled states}
  \item{x0n }{The sampled initial state (because R is 1-based) }
}
\source{Shumway & Stoffer (2017) Edition 4, Section 6.12. 
}
\references{You can find demonstrations of  astsa capabilities at 
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\author{
D.S. Stoffer
}
\note{
The script uses \code{\link{Kfilter1}}. To match the input, \code{sQ} and \code{sR} are transposed prior
to calling  \code{Kfilter1}.  Also, if \eqn{A_t} is constant wrt time, it is not necessary to
input an array; see the example.
}
\examples{
\dontrun{

## -- this is just one pass - see FUN WITH ASTSA for the real fun --##
# generate some data
 set.seed(1)
 sQ  = 1; sR = 3; n = 100  
 mu0 = 0; Sigma0 = 10; x0 = rnorm(1,mu0,Sigma0)
 w = rnorm(n,0,sQ); v = rnorm(n,0,sR)
 x = c(x0 + w[1]);  y = c(x[1] + v[1])   # initialize
for (t in 2:n){
  x[t] = x[t-1] + w[t]
  y[t] = x[t] + v[t]   
  }
## run one pass of FFBS, plot data, states and sampled states  
run = ffbs(y,A=1,mu0=0,Sigma0=10,Phi=1,Ups=0,Gam=0,sQ=1,sR=3,input=0)
tsplot(cbind(y,run$xs), spaghetti=TRUE, type='o', col=c(8,4), pch=c(1,NA))
legend('topleft', legend=c("y(t)","xs(t)"), lty=1, col=c(8,4), bty="n", pch=c(1,NA))
}
}
\keyword{ ts }