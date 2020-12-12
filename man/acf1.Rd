\name{acf1}
\alias{acf1}
\title{Plot and print ACF or PACF of a time series
}
\description{
Produces a plot (and a printout) of the sample ACF or PACF. The zero lag value of the ACF is removed.
}
\usage{
acf1(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, pacf=FALSE,
     na.action = na.pass, ...)
}
\arguments{
  \item{series}{The data.  Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}.  If the series is seasonal, this will be at least 4 seasons by default.  
}
  \item{plot}{If TRUE (default), a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script.
}
  \item{main}{Title of graphic; defaults to name of series.
}
  \item{ylim}{Specify limits for the y-axis.
}
  \item{pacf}{If TRUE, the sample PACF is returned instead of ACF.
}
  \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{acf} }
}
\value{\item{ACF}{The sample ACF or PACF}
}
\details{Will plot and print the sample ACF or PACF (if \code{pacf=TRUE}). The zero lag of the ACF (which is always 1) has been removed. If \code{plot=TRUE}, a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script. The error bounds are approximate white noise bounds, \eqn{0 \pm 2/\sqrt{n}}; no other option is given.    
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{
D.S. Stoffer 
}
\examples{
acf1(rnorm(100))
acf1(sarima.sim(ar=.9), pacf=TRUE)
}
\keyword{ts}
