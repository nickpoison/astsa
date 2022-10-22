\name{xKfilter1}
\alias{xKfilter1}
\title{Kalman Filter - This script has been superseded by \code{\link{Kfilter}}.  
}

\description{Returns both the predicted and filtered values for a linear  state space model. Also evaluates
the likelihood at the given parameter values.  NOTE: This script has been superseded by \code{\link{Kfilter}}.
Note that
scripts starting with an x are scheduled to be phased out.
}
\usage{
xKfilter1(num, y, A, mu0, Sigma0, Phi, Ups, Gam, cQ, cR, input)
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
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\author{D.S. Stoffer
}
\details{NOTE: This script has been superseded by \code{\link{Kfilter}}
}
\keyword{ ts }
