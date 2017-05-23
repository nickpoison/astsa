\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of a univariate time series in one easy line.
}
\usage{
tsplot(series, main = NULL, ...)
}
\arguments{
  \item{series}{
the time series to be plotted.
}
  \item{main}{
add a plot title - the default is no title.
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

