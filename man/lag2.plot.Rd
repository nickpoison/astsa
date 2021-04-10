\name{lag2.plot}
\alias{lag2.plot}
\title{Lag Plot - two time series
}
\description{Produces a grid of scatterplots of one series versus another. The first named series is the one that gets lagged. 
}
\usage{
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE, col = gray(.1), 
           lwl=1, bgl ='white', box.col=8, ...)
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
  \item{lwl}{width of lowess line; default is 1
}
  \item{bgl}{background of the ACF legend; default is \code{'white'}
}
  \item{box.col}{color of the border of the ACF legend; default is \code{'gray(62)'}
}
  \item{\dots}{additional graphical parameters
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
lag2.plot(soi, rec, max.lag=3)
lag2.plot(soi, rec, 8, cex=1.1, pch=19, col=5, bgl='transparent', lwl=2)
}
\seealso{\code{\link{lag1.plot}}}
\keyword{ ts }
