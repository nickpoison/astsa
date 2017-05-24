\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of a univariate time series in one easy line.
}
\usage{
tsplot(series, main = NULL, ylab = deparse(substitute(series)), type='l', margins=0, ...)
}
\arguments{
  \item{series}{
the time series to be plotted.
}
  \item{main}{
add a plot title - the default is no title.
}
  \item{ylab}{
y-axis label - the default is the name of the ts object.
}
  \item{type}{
type of plot - the default is line.
}
  \item{margins}{
inches to add (or subtract) to the margins; start small. 
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
\examples{
tsplot(soi, col=4)
#
tsplot(soi, main="Southern Oscillation Index")
#
par(mfrow=2:1)
tsplot(soi, main="Title for Both")
tsplot(rec)
}
\keyword{ ts }%  

