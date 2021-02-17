\name{lag1.plot}
\alias{lag1.plot}
\title{Lag Plot - one time series
}
\description{Produces a grid of scatterplots of a series versus lagged values of the series.
}
\usage{
lag1.plot(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1), 
          bgl ='white', lwl=1, ...)
}
\arguments{
  \item{series}{the data
}
  \item{max.lag}{maximum lag
}
  \item{corr}{if TRUE, shows the autocorrelation value in a legend
}
  \item{smooth}{if TRUE, adds a lowess fit to each scatterplot
}
  \item{col}{color of points; default is \code{gray(.1)}
}
  \item{bgl}{background of the ACF legend; default is \code{'white'}
}
  \item{lwl}{width of lowess line; default is 1
}
  \item{...}{additional graphical arguments
}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{D.S. Stoffer
}
\examples{
lag1.plot(log(varve), max.lag=9)
lag1.plot(soi, 12, cex=1, pch=19, col=astsa.col(.3)[4], gg=TRUE, corr=FALSE)
}
\seealso{\code{\link{lag2.plot}}}
\keyword{ ts }

