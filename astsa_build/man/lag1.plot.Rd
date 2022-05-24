\name{lag1.plot}
\alias{lag1.plot}
\title{Lag Plot - one time series
}
\description{Produces a grid of scatterplots of a series versus lagged values of the series.
}
\usage{
lag1.plot(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1),
          lwl=1, bgl ='white', ltcol=1, box.col=8, ...)
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
  \item{lwl}{width of lowess line; default is 1
}
  \item{bgl}{background of the ACF legend; default is \code{'white'}
}
  \item{ltcol}{legend text color; default is black
}
  \item{box.col}{color of the border of the ACF legend; default is \code{'gray(62)'}
}
  \item{...}{additional graphical arguments
}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\author{D.S. Stoffer
}
\examples{
lag1.plot(log(varve), max.lag=9)
lag1.plot(soi, 12, cex=1, pch=19, col=astsa.col(4, .3), gg=TRUE, corr=FALSE)
}
\seealso{\code{\link{lag2.plot}}}
\keyword{ ts }

