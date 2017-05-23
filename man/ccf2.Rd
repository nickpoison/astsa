\name{ccf2}
\alias{ccf2}
\title{Cross Correlation Plot
}
\description{
Produces a nice graphic (and only a plot) of the sample CCF of two time series.
}
\usage{
ccf2(x, y, max.lag = NULL, main=NULL, na.action = na.fail, ... )
}
\arguments{
  \item{x, y}{Univariate time series.
}
  \item{max.lag}{
Maximum lag for which to calculate the CCF.
}
  \item{main}{
Plot title. If NULL, uses x and y names.
}
  \item{na.action}{
Function to be called to handle missing values.
}
\item{...}{ Addtional arguements passed to \code{acf} }
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
