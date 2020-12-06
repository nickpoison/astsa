\name{ccf2}
\alias{ccf2}
\title{Cross Correlation
}
\description{
Produces a nice graphic of the sample CCF of two time series.  The actual CCF values are returned invisibly.
}
\usage{
ccf2(x, y, max.lag = NULL, main=NULL, ylab="CCF", na.action = na.pass, ... )
}
\arguments{
  \item{x, y}{univariate time series.
}
  \item{max.lag}{
maximum lag for which to calculate the CCF.
}
  \item{main}{
plot title - if NULL, uses x and y names.
}
\item{ylab}{
vertical axis label; default is 'CCF'.
}
  \item{na.action}{ how to handle missing values; default is \code{na.pass}
}
\item{...}{ additional arguments passed to \code{acf} }
}
\details{
This will produce a graphic of the sample \code{corr[x(t+lag), y(t)]} from \code{-max.lag} to \code{max.lag}. Also, the (rounded to 3 digits) values of the CCF are returned invisibly.
}
\references{
\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{D.S. Stoffer
}
\examples{
( ccf2(soi, rec) )   # now you see it
ccf2(soi, rec)       # now you don't
}
\keyword{ ts } 
