\name{gtemp.month}
\alias{gtemp.month}
\docType{data}
\title{
Monthly global average surface temperatures by year
}
\description{
Monthly global average surface temperatures by year. The temperature of the air measured 2 meters above the ground, encompassing land, sea, and in-land water surfaces.
}
\format{
  A data frame with 12 monthly observations (as rows) for the years 1975-2023 (as columns in reverse order).
}
\details{
Temperature of air at 2m above the surface of land, sea or in-land waters. 2m temperature is calculated by interpolating between the lowest model level and the Earth's surface, taking account of the atmospheric conditions. Technical details at \kbd{https://cds.climate.copernicus.eu/datasets/reanalysis-era5-pressure-levels-monthly-means?tab=overview}.
}
\source{
\kbd{https://ourworldindata.org/grapher/monthly-average-surface-temperatures-by-year}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
# functional data plot showing global warming
tsplot(gtemp.month, spaghetti=TRUE, col=rainbow(49, start=.2, v=.8, rev=TRUE), ylab='\u00b0C', 
        xlab='Month', xaxt='n', main='Mean Monthly Global Temperature', lwd=c(3,rep(1,47),3))
axis(1, labels=Months, at=1:12)
text(10, 13, '1975')
text(10.3, 15.5, '2023')

}

\keyword{datasets}
