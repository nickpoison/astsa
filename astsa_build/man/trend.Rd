\name{trend}
\alias{trend}
\title{Estimate Trend
} 
\description{
Estimates the trend (polynomial or lowess) of a time series and returns a graphic of the series with the trend and error bounds (returned invisibly) superimposed.
}
\usage{
trend(series, order = 1, lowess = FALSE, lowspan = .75, robust = TRUE,
         col = c(4, 6), ylab = NULL, ci = TRUE, results = FALSE, ...)
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
Vector of two colors for the graphic, first the color of the data (default is blue [4]) and second the color of the trend (default is magenta [6]). Both the data and trend line will be the same color if only one value is given.
}
  \item{ylab}{
Label for the vertical axis (default is the name of the series).
}
  \item{ci}{
If TRUE (default), pointwise 95\% confidence intervals are drawn.
}
  \item{results}{
For polynomial regression, if TRUE, will print a summary (using \code{\link{ttable}}) of the regression results.
}
  \item{\dots}{
Other graphical parameters.
}
}
\details{
Produces a graphic of the time series with the trend and a .95 pointwise confidence interval superimposed. The trend estimate and the error bounds are returned invisibly.
}
\value{
Produces a graphic and returns the trend estimate \code{fit} and error bounds  \code{lwr} and \code{upr} invisibly  (see details) and with the same time series attributes as the input \code{series}.
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
\dontrun{

par(mfrow=2:1)
trend(soi)
trend(soi, lowess=TRUE)
}
}
\seealso{\code{\link{detrend}}}
\keyword{ts}
