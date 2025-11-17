% taken from the stats package almost 'as is'

\name{lag}
\alias{lag}
\title{Lag for Time Series}
\description{
  Compute a lagged version of a time series, shifting the time base
  back by a given number of observations.
  }
\usage{
lag(x, \dots)

\method{lag}{default}(x, k = 1, \dots)
}
\arguments{
  \item{x}{A vector or matrix or univariate or multivariate time series}
  \item{k}{The number of lags (in units of observations). 
           Forward lag is k > 0, and backward lag is k < 0.}
  \item{\dots}{further arguments to be passed to or from methods.}
}
\details{  
  For a time series \eqn{x_t}, note that \code{lag(x,1)} is \eqn{x_{t+1}},
  and \code{lag(x,-1)} is \eqn{x_{t-1}}.
}
\value{
  A time series object with the same class as \code{x}.
}

\note{
This is \code{stats::lag}. Because of the mess created by \code{dplyr}, now if \code{astsa} is loaded after \code{dplyr}, this will take back the script as originally intended.
}

\examples{
# lag(x,  1) is forward lag
# lag(x, -1) is backward lag
# to wit, `lag(x)` is ahead by one and `lag(x,-1)` is behind:
x = ts(1:5)
cbind(x, lag(x), lag(x,-1))
}
\keyword{ts}
