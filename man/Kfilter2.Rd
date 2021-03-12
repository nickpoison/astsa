\name{Kfilter2}
\alias{Kfilter2}
\title{Kalman Filter - Model may be time varying or have inputs or correlated errors
}
\description{Returns the filtered values  for the state space model.  In addition, the script returns the evaluation of the likelihood at the given parameter values and the innovation sequence.  
}
\usage{
Kfilter2(num, y, A, mu0, Sigma0, Phi, Ups, Gam, Theta, cQ, cR, 
          S, input)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{data matrix, vector or time series
}
  \item{A}{time-varying observation matrix, an array with \code{dim = c(q,p,n)}
}
  \item{mu0}{initial state mean
}
  \item{Sigma0}{initial state covariance matrix
}
  \item{Phi}{state transition matrix
}
  \item{Ups}{state input matrix; use \code{Ups = 0} if not needed
}
  \item{Gam}{observation input matrix; use \code{Gam = 0} if not needed
}
  \item{Theta}{state error pre-matrix
}
  \item{cQ}{Cholesky decomposition of state error covariance matrix Q -- see details below
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
}
  \item{S}{covariance-type matrix of state and observation errors
}
  \item{input}{matrix or vector of inputs having the same row dimension as y; use \code{input = 0} if not needed
}
}
\value{
\item{xp }{one-step-ahead prediction of the state}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{innov }{innovation series}
\item{sig }{innovation covariances}
\item{K }{last value of the gain, needed for smoothing}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{D.S. Stoffer
}
\details{\code{cQ} and \code{cR} are the Cholesky-type decompositions of \code{Q} and \code{R}. In particular, \code{Q = t(cQ)%*%cQ} and \code{R = t(cR)%*%cR} is all that is required (assuming \code{Q} and \code{R} are valid covariance matrices). 
}
\keyword{ ts }
