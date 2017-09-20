\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of a univariate time series in one easy line.
}
\usage{
tsplot(x, y=NULL, main=NULL, ylab=NULL, xlab='Time', type='l', margins=.25, ... )
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
  \item{\dots}{
other graphical parameteres; see \link[graphics]{par}.
}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
}
\author{
D.S. Stoffer
}
\note{ This script is meant to be used for demonstrations so that
a nice time series plot can be produced in one quick and easy statement.
You can use it to do tricks, but you might get warnings because I had to
use 2 levels of graphics to avoid having the grid on top of the line.  For 
example, \code{axes = FALSE} will work, but you will get a warning because
it applies to one level and not the other. 
}
\examples{
tsplot(soi, col=4)
#
tsplot(soi, main="Southern Oscillation Index")
#
par(mfrow=2:1)
tsplot(soi, main="Title for Both")
tsplot(rec)
#
tsplot(1:453, soi, ylab='SOI', xlab='Month')
}
\keyword{ ts }%  

