\name{acf1}
\alias{acf1}
\title{Plot and print ACF or PACF of a time series
} 
\description{
Produces a plot (and a printout) of the sample ACF or PACF. The zero lag value of the ACF is removed.
}
\usage{
acf1(series, max.lag = NULL, plot = TRUE, main = NULL, ylim = NULL, pacf = FALSE,
      ylab = NULL, xlab = NULL, na.action = na.pass, ...)
}
\arguments{
  \item{series}{The data (must be more than 2 observations). Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Unless \eqn{n < 60}, defaults to \eqn{\sqrt{n} + 10} or at least 4 seasons if the series is seasonal.  
}
  \item{plot}{If TRUE (default), a graph is produced and the values are rounded and listed. If FALSE, no graph is produced and the values are listed but not rounded by the script.
}
  \item{main}{Title of graphic; defaults to name of series.
}
  \item{ylim}{Specify limits for the y-axis.
}
  \item{pacf}{If TRUE, the sample PACF is returned instead of ACF.
}
  \item{ylab}{Change y-axis label from default.
}
  \item{xlab}{Change x-axis label from default.
}
  \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{\link{tsplot}}
}
}
\value{\item{ACF}{The sample ACF or PACF}
}
\details{Will print and/or plot the sample ACF or PACF (if \code{pacf=TRUE}). The zero lag of the ACF (which is always 1) has been removed. If \code{plot=TRUE}, a graph is produced and the values are rounded and listed. If \code{plot=FALSE}, no graph is produced and the values are listed but not rounded by the script. The error bounds are approximate white noise bounds, \eqn{-1/n  \pm 2/\sqrt{n}}; no other option is given.
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
acf1(rnorm(100))

acf1(sarima.sim(ar=.9), pacf=TRUE)

acf1(soi, col=2:7, lwd=4, gg=TRUE)
}
\seealso{\code{\link{acf2}}, \code{\link{acfm}}, \code{\link{ccf2}} }
\keyword{ts}
