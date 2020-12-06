\name{EM1}
\alias{EM1}
\title{EM Algorithm for General State Space Models
}
\description{Estimation of the parameters in the general state space  model via the EM algorithm.   Inputs are not allowed; see the note.
}
\usage{
EM1(num, y, A, mu0, Sigma0, Phi, cQ, cR, max.iter = 100, tol = 0.001)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{observation vector or time series; use 0 for missing values
}
  \item{A}{observation matrices, an array with \code{dim=c(q,p,n)}; use 0 for missing values
}
  \item{mu0}{initial state mean
}
  \item{Sigma0}{initial state covariance matrix
}
  \item{Phi}{state transition matrix
}
  \item{cQ}{Cholesky-like decomposition of state error covariance matrix Q -- see details below
}
  \item{cR}{R is diagonal here, so \code{cR = sqrt(R)} -- also, see details below
}
  \item{max.iter}{maximum number of iterations
}
  \item{tol}{relative tolerance for determining convergence
}
}
\value{
\item{Phi }{Estimate of Phi}
\item{Q }{Estimate of Q}
\item{R }{Estimate of R}
\item{mu0 }{Estimate of initial state mean}
\item{Sigma0 }{Estimate of initial state covariance matrix}
\item{like }{-log likelihood at each iteration}
\item{niter }{number of iterations to convergence}
\item{cvg }{relative tolerance at convergence}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/}
}
\author{D.S. Stoffer
}
\note{
  Inputs are not allowed (and hence not estimated). The script uses Ksmooth1 and everything related to inputs are set equal to zero when it is called.  
  
  It would be relatively easy to include estimates of 'Ups' and 'Gam' because conditional on the states, these are just regression coefficients.  If you decide to alter EM1 to include estimates of the 'Ups' or 'Gam', feel free to notify me with a workable example and I'll include it in the next update.
}
\keyword{ ts }
