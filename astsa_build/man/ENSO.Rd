\name{ENSO}
\alias{ENSO}
\docType{data}
\title{El Nino - Southern Oscillation
}
\description{
Southern Oscillation Index (SOI), 1/1951 to 10/2022; anomalies are departures from the 1981-2010 base period.
}
\format{
  The format is:
 Time-Series [1:862] from 1951 to 2022: 1.5 0.9 -0.1 -0.3 -0.7 0.2 -1 -0.2 -1.1 -1 ...
}
\details{
The \eqn{\textrm{El Ni\~no - Southern Oscillation (ENSO)}} is a recurring climate pattern involving changes in the temperature of waters in the central and eastern tropical Pacific Ocean.  

The data have been detrended and seasonally adjusted.  For raw SOI data (from a different time period), see \code{\link{soi}}.
}
\source{
\kbd{https://www.ncei.noaa.gov/access/monitoring/enso/soi}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\seealso{\code{\link{soi}}}
\keyword{datasets}
