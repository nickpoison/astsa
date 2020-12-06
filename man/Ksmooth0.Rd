\name{Ksmooth0}
\alias{Ksmooth0}
\title{Kalman Filter and Smoother - Time invariant model without inputs
}
\description{Returns both the filtered values  and  smoothed values   for the state-space model.
}
\usage{
Ksmooth0(num, y, A, mu0, Sigma0, Phi, cQ, cR)
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
\item{xs }{state smoothers}
\item{Ps }{smoother mean square error}
\item{x0n }{initial mean smoother}
\item{P0n }{initial smoother covariance}
\item{J0 }{initial value of the J matrix}
\item{J }{the J matrices}
\item{xp }{one-step-ahead prediction of the state}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{Kn }{last value of the gain}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/}\cr

See also \url{https://www.stat.pitt.edu/stoffer/tsa4/chap6.htm} for an explanation of the difference between levels 0, 1, and 2.
}
\author{D.S. Stoffer
}
\keyword{ ts }
