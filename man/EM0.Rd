\name{EM0}
\alias{EM0}
\title{EM Algorithm for Time Invariant State Space Models 
}
\description{Estimation of the parameters in a simple state space via the EM algorithm.  
}
\usage{
EM0(num, y, A, mu0, Sigma0, Phi, cQ, cR, max.iter = 50, tol = 0.01)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{observation vector or time series
}
  \item{A}{time-invariant observation matrix
}
  \item{mu0}{initial state mean vector
}
  \item{Sigma0}{initial state covariance matrix
}
  \item{Phi}{state transition matrix
}
  \item{cQ}{Cholesky-like decomposition of state error covariance matrix Q -- see details below
}
  \item{cR}{Cholesky-like decomposition of state error covariance matrix R -- see details below
}
  \item{max.iter}{maximum number of iterations
}
  \item{tol}{relative tolerance for determining convergence
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as 
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


\keyword{ ts}
