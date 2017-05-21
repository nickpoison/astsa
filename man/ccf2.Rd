\name{ccf2}
\alias{ccf2}
\title{Cross Correlation Plot
}
\description{
Produces a nice graphic (and only a plot) of the sample CCF of two time series.
}
\usage{
ccf2(x, y, max.lag = NULL, na.action = na.fail, ...)
}
\arguments{
  \item{x, y}{Univariate time series.
}
  \item{max.lag}{
Maximum lag for which to calculate the CCF.
}
  \item{na.action}{
Function to be called to handle missing values.
}
  \item{\dots}{
Further arguments to be passed to the plot.
}
}
\details{
This will produce a graphic of the sample \code{corr[x(t+lag), y(t)]} from \code{-max.lag} to \code{max.lag}.
}
\references{
\url{http://www.stat.pitt.edu/stoffer/tsa4/}
}
\author{D.S. Stoffer
}
\keyword{ ts } 
