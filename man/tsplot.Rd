\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of univariate or multiple time series in one easy line.
}
\usage{
tsplot(x, y=NULL, main=NULL, ylab=NULL, xlab='Time', type=NULL, 
        margins=.25, ncolm=1, byrow=TRUE, minor=TRUE, nxm=2, nym=2,   
        col=1, ...)
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
 \item{byrow}{
for multiple time series - if TRUE (default), plot series row wise; if FALSE, plot series column wise.
}
  \item{minor, nxm, nym}{
if minor=TRUE, the number of minor tick marks on x-axis, y-axis.  minor=FALSE removes both or set either to 0 or 1 to remove.
}
 \item{col}{
line color(s), can be a vector for multiple time series.
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
\examples{
tsplot(soi, col=4, main="Southern Oscillation Index")
#
tsplot(1:453, soi, ylab='SOI', xlab='Month')
#
tsplot(eqexp[,1:8], col=rainbow(8,s=.9,v=.8), ncolm=2, lwd=2, main='Earthquakes')
}
\keyword{ ts }%  

