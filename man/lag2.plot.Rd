\name{lag2.plot}
\alias{lag2.plot}
\title{Lag Plot - two time series
}
\description{Produces a grid of scatterplots of one series versus another. The first named series is the one that gets lagged. 
}
\usage{
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE, col = gray(.1), 
           bgl ='white', lwl=1, ...)
} 
\arguments{
  \item{series1}{first series (the one that gets lagged)
}
  \item{series2}{second series
}
  \item{max.lag}{maximum number of lags
}
  \item{corr}{if TRUE, shows the cross-correlation value in a legend
}
  \item{smooth}{if TRUE, adds a lowess fit to each scatterplot
}
  \item{col}{color of points; default is \code{gray(.1)}
}
  \item{bgl}{background of the CCF legend; default is \code{'white'}
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
lag2.plot(soi, rec, max.lag=3)
lag2.plot(soi, rec, 8, cex=1.1, pch=19, col=5, bgl='transparent', lwl=2)
}
\seealso{\code{\link{lag1.plot}}}
\keyword{ ts }
