\name{lag1.plot}
\alias{lag1.plot}
\title{Lag Plot - one time series
} 
\description{Produces a grid of scatterplots of a series versus lagged values of the series.
}
\usage{
lag1.plot(series, max.lag = 1, corr = TRUE, smooth = TRUE, col = gray(.1), bg = NA, 
           lwl = 1, lwc = 2, bgl = NULL, ltcol = 1, box.col = NULL, cex = .9, 
           gg = FALSE, location="topright", xname = NULL, main = NULL, ...)
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
the location of the ACF legend with options \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"} (the default), \code{"right"} and \code{"center"}.  
}
  \item{xname}{a string; name of the series to be used for axis labels. If NULL, the name of the series as input is used.
}
  \item{main}{a string for the title if desired, otherwise there is no title.
}
  \item{...}{additional graphical arguments
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
lag1.plot(log(varve), max.lag=9, lwl=3, lwc=6, col=5, location='topleft')

lag1.plot(soi, 12, pch=19, col=astsa.col(4, .3), gg=TRUE)

lag1.plot(diff(log(varve)), 4, xname='V', col=6, cex=1.1, lwc=5, pch=5,
           main=bquote(V(t)==nabla*log(varve[t]))) 
}
\seealso{\code{\link{lag2.plot}}, \code{\link{tspairs}}
}
\keyword{ ts }

