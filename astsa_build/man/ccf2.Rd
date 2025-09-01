\name{ccf2}
\alias{ccf2}
\title{Cross Correlation
} 
\description{
Calculates and plots the sample CCF of two time series.
}
\usage{
ccf2(x, y, max.lag = NULL, main = NULL, ylab = "CCF", plot = TRUE,
         na.action = na.pass, type = c("correlation", "covariance"), ...)
}
\arguments{
  \item{x, y}{univariate time series
}
  \item{max.lag}{
maximum lag for which to calculate the CCF. Can be omitted. Unless \eqn{n < 50}, defaults to \eqn{\sqrt{n} + 10} or at least 3 seasons if the series is seasonal.  
}
  \item{main}{
plot title - if NULL, uses x and y names
}
  \item{ylab}{
vertical axis label; default is 'CCF'
}
  \item{plot}{
if TRUE (default) a graphic is produced and the values are returned invisibly. Otherwise, the values are returned.
}
  \item{na.action}{ how to handle missing values; default is \code{na.pass}
}
  \item{type}{ default is cross-correlation; an option is cross-covariance
}
  \item{\dots}{ additional arguments passed to \code{\link{tsplot}}
}
}
\details{
This will produce a graphic of the sample \code{corr[x(t+lag), y(t)]} from \code{-max.lag} to \code{max.lag}. Also, the (rounded) values of the CCF are returned invisibly unless \code{plot=FALSE}.  Similar details apply to the cross-covariance.
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
\examples{
ccf2(soi, rec, plot=FALSE, max.lag=6)  # now you see it
ccf2(soi, rec)                          # now you don't

# happy birthday
ccf2(soi, rec, col=astsa.col(4, wheel=TRUE, num=6), lwd=4, gg=TRUE)
}
\seealso{\code{\link{pre.white}}, \code{\link{acf1}}, \code{\link{acf2}}, \code{\link{acfm}} }
\keyword{ ts } 
