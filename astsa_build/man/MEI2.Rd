\name{MEI2}
\alias{MEI2}
\docType{data}
\title{
Multivariate El Nino/Southern Oscillation Index (version 2)
}
\description{
Bimonthly MEI values (version 2), starting with Dec1978/Jan1979 through Apr/May2025.  
These data are similar to \code{MEI} and larger values correspond to warmer
temperatures (unlike \code{soi} and \code{ENSO}). 
}
\format{
  The format is:
 Time-Series [1:557] from 1979 to 2025: 0.47 0.29 -0.05 0.21 0.27 -0.11 -0.11 0.47 0.38 0.23 ...
}
\details{
For details, see \kbd{https://www.psl.noaa.gov/enso/mei} and \code{\link{MEI}}, which is version 1. 

The key differences between MEI version 2 and version 1 are the input variables used, the source of the data, and the dates of the historical record.  MEI version 2 relies on reanalysis data using modern numerical weather models to process and combine historical weather observations into a comprehensive, globally complete, and consistent dataset of past weather and climate and satellite data. This eliminates inconsistencies caused by relying on potentially less reliable ship observations, especially in earlier decades. The switch from cloud cover fraction to Outgoing Longwave Radiation (OLR) provides a more direct and accurate measurement of atmospheric convection, a critical component of ENSO.  Despite the differences, MEI version 2 and the original MEI version 1 are very highly correlated for the overlapping period. 

Weak El Nino: MEI is between +0.5 and +1.0.\cr
Moderate El Nino: MEI is between +1.0 and +1.5.\cr
Strong El Nino: MEI is between +1.5 and +2.0.\cr
Very Strong El Nino: MEI is at or above +2.0.\cr
Values below the negative of these indicate La Nina conditions. 
}
\source{
\kbd{https://www.psl.noaa.gov/enso/mei}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\seealso{\code{\link{soi}, \link{ENSO}, \link{MEI}}
}
\examples{
tsplot(cbind(MEI, MEI2), spag=TRUE, col=2*2:1, addLegend=TRUE, nym=2, gg=TRUE)

tspairs(ts.intersect(MEI, MEI2), location='top')

}
\keyword{datasets}
