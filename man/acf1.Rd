\name{acf1}
\alias{acf1}
\title{Plot and print ACF of a time series
}
\description{
Produces a plot (and a printout) of the sample ACF. The zero lag value of the ACF is removed.
}
\usage{
acf1(series, max.lag=NULL, plot=TRUE, main= NULL, na.action = na.pass, ...)
}
\arguments{
  \item{series}{The data.  Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}.  If the series is seasonal, this will be at least 4 seasons by default.  
}
  \item{plot}{If FALSE, no graph is produced but the values are still printed.
}
  \item{main}{Title of graphic; defaults to name of series.
}
  \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{acf} }
}
\value{\item{ACF}{The sample ACF}
}
\details{This is basically a wrapper for \code{acf()} provided in \code{tseries}. The zero lag (which is always 1) has been removed. The error bounds are approximate white noise bounds, \eqn{0 \pm 2/\sqrt{n}}; no other option is given.    
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{
D.S. Stoffer 
}
\examples{
acf1(rnorm(100))
acf1(rnorm(100), 25, main='')  # no title
}
\keyword{ts}
