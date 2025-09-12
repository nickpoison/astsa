\name{tspairs}
\alias{tspairs}
\title{
Scatterplot Matrix for Time Series
}
\description{
Produces a matrix of scatterplots with the time series (or a histogram) plotted on the diagonal.
}
\usage{
tspairs(x, main = NA, pt.col = astsa.col(4, 0.6), pt.size = 1.1, lab.size = 1.25, 
        title.size = 1.5, scale = 1, corr = TRUE, smooth = TRUE, lwl = 1, lwc = 2, 
        gg = FALSE, hist.diag = TRUE, col.diag = 4, location='topright', ...)
}
\arguments{
  \item{x}{
multiple time series; use \code{ts.intersect} to include lagged values.
}
  \item{main}{
title (default is no title).
}
  \item{pt.col}{
point color.
}
  \item{pt.size}{
point size.
}
  \item{lab.size}{
label size.
}
  \item{title.size}{
title size.
}
  \item{scale}{
multiplier for the overall character expansion (\code{cex}).
}
  \item{corr}{
if TRUE (default), the correlations are shown in the scatterplots.
}
  \item{smooth}{
if TRUE (default), a lowess fit is displayed in the scatterplots.
}
  \item{lwl}{
width of the lowess line.
}
  \item{lwc}{
color of the lowess line.
}
  \item{gg}{
if TRUE, will produce a gris-gris plot (gray graphic interior with white grid lines); the default is FALSE. The grammar of astsa is voodoo.
}
  \item{hist.diag}{
if TRUE (default), will plot histograms on the diagonal; if FALSE, time plots of the series are displayed instead.
}
  \item{col.diag}{
color for the diagonal plots.
}
 \item{location}{ 
the location of the ACF legend with options \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"} (the default), \code{"right"} and \code{"center"}.  
}
  \item{\dots}{
additional graphic parameters.
}
}
\note{
Use \code{ts.intersect} if lagged variables are included, otherwise \code{cbind} will work.
}
\value{
Returns a matrix of scatterplots with time plots or histograms on the diagonal.
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

\seealso{
 \code{\link{lag1.plot}}, \code{\link{lag2.plot}} 
}
\examples{

tspairs(diff(log(econ5))[,1:3], col.diag=6, hist=FALSE, pt.size=1.5, lwl=2, gg=TRUE)

tspairs(cbind(cmort,tempr,part), pch=9, scale=1.1)
}
\keyword{ ts }

