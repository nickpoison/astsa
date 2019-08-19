\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of univariate or multiple time series in one easy line.
}
\usage{
tsplot(x, y=NULL, main=NULL, ylab=NULL, xlab='Time', type='l', margins=.25,
        ncolm=1, minor=TRUE, nxm=2, nym=2, ... )
}
\arguments{
  \item{x, y}{
time series to be plotted; if both present, x will be the time index.
}
  \item{main}{
add a plot title - the default is no title.
}
  \item{ylab}{
y-axis label - the default is the name of the ts object.
}
  \item{xlab}{
x-axis label - the default is 'Time'.
}
  \item{type}{
type of plot - the default is line.
}
  \item{margins}{
inches to add (or subtract) to the margins. 
}
 \item{ncolm}{
for multiple time series, the number of columns to plot.
}
  \item{minor, nxm, nym}{
if minor=TRUE, the number of minor tick marks on x-axis, y-axis.  minor=FALSE removes both or set either to 0 or 1 to remove.
}
  \item{\dots}{
other graphical parameteres; see \link[graphics]{par}.
}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{
D.S. Stoffer
}
\note{ This script is meant to be used for demonstrations so that
a nice time series plot can be produced in one quick and easy statement.
You can use it to do tricks, but you might get warnings because I had to
use 2 levels of graphics to avoid having the grid on top of the line.  For 
example, \code{axes = FALSE} will work, but you will get a warning because
it applies to one level and not the other.  For multiple time series some
options are limited, but there is no limit to the number of time series
you can plot... you just need to use \code{ncolm} wisely.
}
\examples{
tsplot(soi, col=4, main="Southern Oscillation Index")
#
tsplot(1:453, soi, ylab='SOI', xlab='Month')
#
tsplot(eqexp[,1:8], col=rainbow(8), ncolm=2, lwd=2, main='EQs')
}
\keyword{ ts }%  

