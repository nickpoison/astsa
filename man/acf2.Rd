\name{acf2}
\alias{acf2}
\title{Plot and print ACF and PACF of a time series
}
\description{
Produces a simultaneous plot (and a printout) of the sample ACF and PACF on the same scale. The zero lag value of the ACF is removed.
}
\usage{
acf2(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL,
     na.action = na.pass, ...)
}
\arguments{
  \item{series}{The data.  Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}. If the series is seasonal, this will be at least 4 seasons by default.  
}
   \item{plot}{If TRUE (default), a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script.
}
  \item{main}{Title of graphic; defaults to name of series.
}
  \item{ylim}{Specify limits for the y-axis.
}
 \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{acf} }
}
\value{\item{ACF}{The sample ACF}
\item{PACF}{The sample PACF}
}
\details{This is basically a wrapper for \code{acf()} provided in \code{tseries}.  The error bounds are approximate white noise bounds, \eqn{0 \pm 2/\sqrt{n}}; no other option is given.    
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{
D.S. Stoffer 
}
\examples{
acf2(rnorm(100))
acf2(rnorm(100), 25, main='')  # no title
acf2(rnorm(100), plot=FALSE)[,'ACF']  # print only ACF
}
\keyword{ts}
