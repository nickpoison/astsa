\name{lag2.plot}
\alias{lag2.plot}
\title{Lag Plot - two time series
}
\description{Produces a grid of scatterplots of one series versus another. The first named series is the one that gets lagged. 
}
\usage{
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE, col = gray(.1), ...)
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
  \item{...}{additional graphical arguments}   
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{D.S. Stoffer
}
\examples{
lag2.plot(soi, rec, 3)
lag2.plot(soi, rec, max.lag=8, pch=20, cex=1.5, col=rgb(0,.5,1,.5))
}
\seealso{\code{\link{lag1.plot}}}
\keyword{ ts }
