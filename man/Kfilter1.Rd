\name{Kfilter1}
\alias{Kfilter1}
\title{Kalman Filter -  Model may be time varying or have inputs
}
\description{Returns both the predicted and filtered values for a linear  state space model. Also evaluates
the likelihood at the given parameter values.
}
\usage{
Kfilter1(num, y, A, mu0, Sigma0, Phi, Ups, Gam, cQ, cR, input)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{data matrix, vector or time series
}
  \item{A}{time-varying observation matrix, an array with \code{dim=c(q,p,n)}
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
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
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
\item{Kn }{last value of the gain, needed for smoothing}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/}\cr

See also \url{https://www.stat.pitt.edu/stoffer/tsa4/chap6.htm} for an explanation of the difference between levels 0, 1, and 2.
}
\author{D.S. Stoffer
}
\keyword{ ts }
