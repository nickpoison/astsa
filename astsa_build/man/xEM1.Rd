\name{xEM1}
\alias{xEM1}
\title{EM Algorithm for General State Space Models - This script has been superseded by \code{\link{EM}}.
}

\description{Estimation of the parameters in the general state space  model via the EM algorithm.   Inputs are not allowed; see the note.  NOTE: This script has been superseded by \code{\link{EM}} and 
scripts starting with an x are scheduled to be phased out.
}
\usage{
xEM1(num, y, A, mu0, Sigma0, Phi, cQ, cR, max.iter = 100, tol = 0.001)
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
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\author{D.S. Stoffer
}
\details{\code{cQ} and \code{cR} are the Cholesky-type decompositions of \code{Q} and \code{R}. In particular, \code{Q = t(cQ)\%*\%cQ} and \code{R = t(cR)\%*\%cR} is all that is required (assuming \code{Q} and \code{R} are valid covariance matrices). 
}
\note{NOTE: This script has been superseded by \code{\link{EM}}
}
\keyword{ ts }
