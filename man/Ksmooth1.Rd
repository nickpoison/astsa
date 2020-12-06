\name{Ksmooth1}
\alias{Ksmooth1}
\title{Kalman Filter and Smoother - General model 
}
\description{Returns both the filtered  and the smoothed values for the state-space model.
}
\usage{
Ksmooth1(num, y, A, mu0, Sigma0, Phi, Ups, Gam, cQ, cR, input)
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
\details{Practically, the script only requires that Q or R may be reconstructed as 
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
