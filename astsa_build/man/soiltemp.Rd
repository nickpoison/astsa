\name{soiltemp}
\alias{soiltemp}
\docType{data}
\title{Spatial Grid of Surface Soil Temperatures
} 
\description{A 64 by 36 matrix of surface soil temperatures (\eqn{{}^\circ \text{C}}).
}
\format{
  The format is:
 num [1:64, 1:36] 6.7 8.9 5 6.6 6.1 7 6.5 8.2 6.7 6.6 ...
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\source{
Bazza, M., Shumway, R. H., & Nielsen, D. R. (1988). Two-dimensional spectral analysis of soil surface temperature. \emph{Hilgardia: A Journal of Agricultural Science}, 56, 1-28.
}
\examples{
par(mar = rep(1,4))
persp(1:64, 1:36, soiltemp, phi=25, theta=25, scale=FALSE, expand=4, 
       col='lightblue', border=4, ticktype="detailed", xlab="rows", 
       ylab="columns", zlab="temperature")
}
\keyword{datasets}
