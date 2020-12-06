\name{Kfilter0}
\alias{Kfilter0}
\title{Kalman Filter - Time Invariant Model 
}
\description{Returns the filtered values for the basic time invariant state-space model; inputs are not allowed.
}
\usage{
Kfilter0(num, y, A, mu0, Sigma0, Phi, cQ, cR)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{data matrix, vector or time series
}
  \item{A}{time-invariant observation matrix
}
  \item{mu0}{initial state mean vector
}
  \item{Sigma0}{initial state covariance matrix
}
  \item{Phi}{state transition matrix
}
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
}
}
\value{
\item{xp }{one-step-ahead state prediction}
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
