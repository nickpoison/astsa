\name{lag1.plot}
\alias{lag1.plot}
\title{Lag Plot - one time series
}
\description{Produces a grid of scatterplots of a series versus lagged values of the series.
}
\usage{
lag1.plot(series, max.lag = 1, corr = TRUE, smooth = TRUE, col = gray(.1), ...)
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
  \item{...}{additional graphical arguments}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{D.S. Stoffer
}
\examples{
lag1.plot(soi, 9, col=4)
lag1.plot(soi, max.lag=4, pch=20, cex=1.5, col=rgb(0,.5,1,.5))
}
\seealso{\code{\link{lag2.plot}}}
\keyword{ ts }

