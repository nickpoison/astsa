\name{lag2.plot}
\alias{lag2.plot}
\title{Lag Plot - two time series
} 
\description{Produces a grid of scatterplots of one series versus another lagged. The first named series is the one that gets lagged.
}
\usage{
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE, col = gray(.1), 
          bg = NA, lwl = 1, lwc = 2, bgl = NULL, ltcol = 1, box.col = NULL, cex = .9, 
          gg = FALSE, location="topright", xname=NULL, yname=NULL, main=NULL, ...)
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
  \item{bg}{background color for filled plot characters
}
  \item{lwl}{width of lowess line; default is 1
}
  \item{lwc}{color of lowess line; default is 2 (red)
}
  \item{bgl}{background of the ACF legend; default is semitransparent 
}
  \item{ltcol}{legend text color; default is black
}
  \item{box.col}{color of the border of the ACF legend; default matches type of plot
}
  \item{cex}{size of points; default is .9
}
  \item{gg}{if TRUE, will produce a gris-gris plot (gray graphic interior with white grid lines); the default is FALSE. The grammar of astsa is voodoo
}
 \item{location}{ 
the location of the CCF legend with options \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"} (the default), \code{"right"} and \code{"center"}.  
}
  \item{xname, yname}{strings for the names of the series to be used for axis labels. If NULL, the name of the series as input is used.
}
  \item{main}{a string for the title if desired, otherwise there is no title.
}
  \item{\dots}{additional graphical parameters
}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{D.S. Stoffer
}
\examples{
lag2.plot(Hare, Lynx, max.lag=5, lwl=2, lwc=3, cex=1.5, pch=24, bg='orange')

lag2.plot(soi, rec, 8, cex=1.1, pch=19, col=5, lwl=2, location="bottomleft")

lag2.plot(diff(lead), diff(sales), 5, corr=FALSE, gg=TRUE, pch=8, col=6, lwc=4,
          xname='dL', yname='dS', main='BJ Sales')
}
\seealso{\code{\link{lag1.plot}}}
\keyword{ ts }
