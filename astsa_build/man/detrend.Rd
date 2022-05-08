\name{detrend}
\alias{detrend}
\title{
Detrend a Time Series
}
\description{
Returns a time series with the trend removed.  The trend can be estimated using polynomial regression or using a lowess fit.
}
\usage{
detrend(series, order = 1, lowess = FALSE, lowspan = 2/3)
}
\arguments{
  \item{series}{
The time series to be detrended.
}
  \item{order}{
Order of the polynomial used to estimate the trend with a linear default (order=1) unless \code{lowess} is TRUE.
}
  \item{lowess}{
If TRUE, lowess is used to find the trend. The default is FALSE.
}
  \item{lowspan}{
The smoother span used for lowess.
}
}
\value{
The detrended series is returned.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\author{
D.S. Stoffer
}
\examples{
tsplot(detrend(soi))

tsplot(detrend(soi, lowess=TRUE)
}
\keyword{ts}
