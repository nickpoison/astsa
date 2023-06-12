\name{MEI}
\alias{MEI}
\docType{data}
\title{
Multivariate El Nino/Southern Oscillation Index (version 1)
}
\description{
Bimonthly MEI values, starting with Dec1949/Jan1950 through Oct/Nov2019.  
All values are normalized for each bimonthly season so that the 44 values from 1950 to 1993 
have an average of zero and a standard deviation of 1.  Larger values correspond to warmer
temperatures (unlike \code{soi} and \code{ENSO}).
}
\format{
  The format is:
 Time-Series [1:827] from 1950 to 2019: -1.03 -1.13 -1.28 -1.07 -1.43 ...
}
\details{For full details, see \kbd{https://psl.noaa.gov/enso/mei.old/mei.html}.
Multivariate ENSO Index (MEI) is a combined score on the six main observed variables over the tropical Pacific. These six variables are: sea-level pressure (P), zonal (U) and meridional (V) components of the surface wind, sea surface temperature (S), surface air temperature (A), and total cloudiness fraction of the sky (C). These observations have been collected and published in ICOADS for many years. The MEI is computed separately for each of twelve sliding bi-monthly seasons (Dec/Jan, Jan/Feb,..., Nov/Dec). After spatially filtering the individual fields into clusters, the MEI is calculated as the first unrotated Principal Component (PC) of all six observed fields combined. This is accomplished by normalizing the total variance of each field first, and then performing the extraction of the first PC on the co-variance matrix of the combined fields. In order to keep the MEI comparable, all seasonal values are standardized with respect to each season and to the 1950-93 reference period.
}
\source{
\kbd{https://psl.noaa.gov/enso/mei.old/table.html}
}
\references{
See \kbd{https://psl.noaa.gov/enso/mei.old/mei.html}
}
\seealso{\code{\link{soi}, \link{ENSO}}
}
\keyword{datasets}
