\name{globtemp}
\alias{globtemp}
\docType{data}
\title{Global mean land-ocean temperature deviations to 2015
} 
\description{Global mean land-ocean temperature deviations (from 1951-1980 average), measured in degrees centigrade, for the years 1880-2015. This was an update of \code{gtemp}, but \code{gtemp_land} and \code{gtemp_ocean} are the most recent updates.
}
\format{
  The format is:
 Time-Series [1:136] from 1880 to 2015: -0.2 -0.11 -0.1 -0.2 -0.28 -0.31 -0.3 -0.33 -0.2 -0.11 ...
}
\details{
The data were changed after 2011, so there are discrepancies between this data set and \code{gtemp}.
The differences are explained in the following document:
www1.ncdc.noaa.gov/pub/data/ghcn/v3/GHCNM-v3.2.0-FAQ.pdf.
}
\source{\kbd{https://data.giss.nasa.gov/gistemp/graphs/}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\seealso{\code{\link{gtemp_land}}, \code{\link{gtemp_ocean}}, \code{\link{globtempl}}, \code{\link{gtemp}},  \code{\link{gtemp2}}}
\keyword{datasets}