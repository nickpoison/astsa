\name{lap.xts}
\alias{lap.xts}
\docType{data}
\title{LA Pollution-Mortality Study: Sampled Daily
}
\description{
Original data from a study of the effects of pollution and weather on mortality, LA, 
1970-1979. These are 3652 daily observations for the 10 year period. The data set is
an xts object indexed by Date.
}
\format{
  The format is:
An xts object on 1970-01-01 / 1979-12-31 containing: \cr
  Data:    double [3652, 11] \cr
  Columns: Tmort, Rmort, Cmort, Temp, Rhumid, CO, SO2, NO2, HC, Ozone, Part \cr
  Index:   Date [3652] (TZ: "UTC") 
}
\details{
\tabular{ll}{
columns are time series       \tab   with names \cr
 (1) Total Mortality          \tab   \code{Tmort}\cr
 (2) Respiratory Mortality    \tab   \code{Rmort}\cr
 (3) Cardiovascular Mortality \tab   \code{Cmort}\cr
 (4) Temperature              \tab   \code{Temp} \cr
 (5) Relative Humidity        \tab   \code{Rhumid}\cr
 (6) Carbon Monoxide          \tab   \code{CO}\cr
 (7) Sulfur Dioxide           \tab   \code{SO2}\cr
 (8) Nitrogen Dioxide         \tab   \code{NO2}\cr
 (9) Hydrocarbons             \tab   \code{HC}\cr
(10) Ozone                    \tab   \code{Ozone}\cr
(11) Particulates             \tab   \code{Part} \cr
}
}

\note{
These are the original data from \kbd{https://github.com/DSStoffer/dsstoffer.github.io/blob/main/files/LAP.pdf}.

The weekly data in \code{\link{lap}} were taken from this data set last century.  The details, however, 
were never entirely made clear and it's too late to get them now.  It is easy to pull out the 
weekly averages from this data set, and how to do so is given in the Examples section below; 
the resulting data set will be slightly different than \code{lap}. The names for this data set 
are different from \code{lap},  the main difference is these names have capitals.
}

\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\seealso{\code{\link{lap}}
}
\examples{
\dontrun{

library(xts)   # assumes package has been installed

plot(lap.xts$Cmort, col=4)   

lapw = apply.weekly(lap.xts, FUN=colMeans)  # get weekly averages

plot(lapw[,c('Cmort', 'Temp', 'Part')], col=astsa.col(2:4, .7), main=NA) 
addLegend(col=2:4, lty=1, lwd=2, ncol=3, bty="white")

sarima(lapw$Cmort, 0,1,1, no.constant=TRUE)  # fit ARIMA(0,1,1) to weekly Cmort
}
}
\keyword{datasets}
