\name{trend}
\alias{trend}
\title{Estimate Trend
}
\description{
Estimates the trend (polynomial or lowess) of a time series and returns a graphic of the series with the trend and error bounds superimposed.
}
\usage{
trend(series, order = 1, lowess = FALSE, lowspan = .75, robust = TRUE,
         col = c(4, 6), ylab = NULL, ...)
}
\arguments{
  \item{series}{
The time series to be analyzed (univariate only).
}
  \item{order}{
Order of the polynomial used to estimate the trend with a linear default (order=1) unless \code{lowess} is TRUE.
}
  \item{lowess}{
If TRUE,  \code{loess} from the stats package is used to fit the trend. The default is FALSE.
}
  \item{lowspan}{
The smoother span used for lowess.
}
  \item{robust}{
If TRUE (default), the lowess fit is robust.
}
  \item{col}{
For the graphic, the color of the data (default is 4) and the color of the trend (default is 6).
}
  \item{ylab}{
Label for the vertical axis (default is the name of the series).
}
  \item{\dots}{
Other graphical parameters.
}
}
\details{
Produces a graphic of the time series with the trend and a .95 pointwise confidence interval superimposed. The trend estimate and the error bounds are returned invisibly.
}
\value{
Produces a graphic and returns the trend estimate and error bounds invisibly (see details).
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
\dontrun{
trend(soi)

trend(soi, lowess=TRUE)
}
}
\seealso{\code{\link{detrend}}}
\keyword{ts}
