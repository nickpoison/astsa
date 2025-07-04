\name{acf2}
\alias{acf2}
\title{Plot and print ACF and PACF of a time series
} 
\description{
Produces a simultaneous plot (and a printout) of the sample ACF and PACF on the same scale. The zero lag value of the ACF is removed.
}
\usage{
acf2(series, max.lag = NULL, plot = TRUE, main = NULL, ylim = NULL, 
      na.action = na.pass, ...)
}
\arguments{
  \item{series}{The data (must be more than 2 observations).  Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag. Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}. If the series is seasonal, this will be at least 4 seasons by default. 
}
   \item{plot}{If TRUE (default), a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script.
}
  \item{main}{Title of graphic; defaults to name of series.
}
  \item{ylim}{Specify limits for the y-axis.
}
 \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{\link{tsplot}}
}
}
\value{\item{ACF}{The sample ACF}
\item{PACF}{The sample PACF}
}
\details{Will print and/or plot the sample ACF and PACF on the same scale. The zero lag of the ACF (which is always 1) has been removed. If \code{plot=TRUE}, a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script. The error bounds are approximate white noise bounds, \eqn{-1/n  \pm 2/\sqrt{n}}; no other option is given.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{
D.S. Stoffer
}
\examples{
acf2(rnorm(100))

acf2(rnorm(100), 25, main='')  # no title

acf2(rnorm(100), plot=FALSE)[,'ACF']  # print only ACF

acf2(soi, col=2:7, lwd=4, gg=TRUE)  # mother's day present
}
\seealso{\code{\link{acf1}}, \code{\link{acfm}}, \code{\link{ccf2}} }
\keyword{ts}
