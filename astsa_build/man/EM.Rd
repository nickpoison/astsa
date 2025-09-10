\name{EM}
\alias{EM}
\title{
EM Algorithm for State Space Models
} 
\description{Estimation of the parameters in general linear state space models via the EM algorithm.   
Missing data may be entered as \code{NA} or as zero (0), however, use \code{NA}s if zero (0) can be an
observation. Inputs in both the state and observation equations are allowed. This script replaces \code{EM0} and \code{EM1}.
}
\usage{
EM(y, A, mu0, Sigma0, Phi, Q, R, Ups = NULL, Gam = NULL, input = NULL, 
    max.iter = 100, tol = 1e-04)
}
\arguments{
  \item{y}{
data matrix (n \code{x} q), vector or time series, n = number of observations, q = number of series.
Use \code{NA} or  zero (0) for missing data, however, use \code{NA}s if zero (0) can be an
observation.
}
  \item{A}{
measurement matrices; can be constant or an array with dimension \code{dim=c(q,p,n)} if time varying.
Use \code{NA} or  zero (0) for missing data.
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
  \item{Q}{
state error matrix (p \code{x} p)
}
  \item{R}{
observation error matrix (q \code{x} q - diagonal only)
}
  \item{Ups}{
state input matrix (p \code{x} r); leave as NULL (default) if not needed
}
  \item{Gam}{
observation input matrix (q \code{x} r); leave as NULL (default) if not needed
}
  \item{input}{
NULL (default) if not needed or a   
matrix (n \code{x} r) of inputs having the same row dimension (n) as y
}
  \item{max.iter}{
maximum number of iterations
}
  \item{tol}{
relative tolerance for determining convergence
}
}
\details{
This script replaces \code{EM0}  and \code{EM1} by combining all cases and allowing inputs in the state
and observation equations. It uses version 1 of the new \code{\link{Ksmooth}} script (hence correlated errors
is not allowed).

The states \eqn{x_t} are p-dimensional, the data \eqn{y_t} are q-dimensional, and 
the inputs \eqn{u_t} are r-dimensional for \eqn{t=1, \dots, n}. The initial state is \eqn{x_0 \sim N(\mu_0, \Sigma_0)}.

The general model  is 
\deqn{x_t = \Phi  x_{t-1} + \Upsilon u_{t} +    w_t \quad w_t \sim iid\ N(0, Q)}
\deqn{y_t = A_t  x_{t-1} + \Gamma u_{t} +   v_t \quad v_t \sim iid\ N(0, R)}
where \eqn{w_t \perp v_t}. The observation noise covariance matrix is assumed to be diagonal and it is forced
to diagonal otherwise.

The measurement matrices \eqn{A_t} can be constant or time varying.  If time varying, they should be entered as an array of dimension \code{dim = c(q,p,n)}.  Otherwise, just enter the constant value making sure it has the appropriate \eqn{q \times p} dimension.
}
\value{
\item{Phi }{Estimate of Phi}
\item{Q }{Estimate of Q}
\item{R }{Estimate of R}
\item{Ups }{Estimate of Upsilon (NULL if not used)}
\item{Gam }{Estimate of Gamma (NULL if not used)}
\item{mu0 }{Estimate of initial state mean}
\item{Sigma0 }{Estimate of initial state covariance matrix}
\item{like }{-log likelihood at each iteration}
\item{niter }{number of iterations to convergence}
\item{cvg }{relative tolerance at convergence}
}
\references{You can find demonstrations of astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\note{The script does not allow for constrained estimation directly, however, constrained estimation is possible with some extra manipulations. There is an example of constrained estimation using \code{EM} at \href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}, where the fun never stops.
}
\author{D.S. Stoffer
}
\seealso{
\code{\link{Kfilter}, \link{Ksmooth} }
}
\examples{
y = ar1miss   # an 'astsa' data set with missing values
A = 1; Phi = .1; Ups = 1
Q = 0.1; R = 0.1; Gam=1
mu0 = 0; Sigma0 = 1
input = rep(1, length(y))
( em = EM(y, A, mu0, Sigma0, Phi, Q, R, Ups, Gam, input) ) 

# run Kalman smoother at the final estimates
ks = Ksmooth(y, A=1, em$mu0, em$Sigma0, em$Phi, sQ=sqrt(em$Q), sR=sqrt(em$R),
              Ups=em$Ups, Gam=em$Gam, input=input) 

# admire your work
tsplot(cbind(y, drop(ks$Xs)), type='o', pch=c(19,NA), col=2*2:3, lwd=1:2, 
        gg=TRUE, spag=TRUE, addLegend=TRUE, legend=c('data', 'smooth'))
miss = cbind(which(is.na(y)), min(y, na.rm=TRUE)-.2)   # show yourself
points(miss, pch=18)
}
\keyword{ ts }


