\name{lap.xts}
\alias{lap.xts}
\docType{data}
\title{LA Pollution-Mortality Study: Daily
}
\description{
Original data from a study of the effects of pollution and weather on mortality, LA, 
1970-1979. These are 3652 daily observations for the 10 year period. The data set is
an xts object and the columns are: Dates, Total Mortality, Respiratory Mortality, 
Cardiovascular Mortality, Temperature, Relative Humidity, Carbon Monoxide, Sulfur Dioxide, 
Nitrogen Dioxide, Hydrocarbons, Ozone, Particulate Pollution.
}
\format{
  The format is:
An xts object on 1970-01-01 / 1979-12-31 containing: \cr
  Data:    double [3652, 11] \cr
  Columns: Tmort, Rmort, Cmort, Temp, Rhumid, CO, SO2, NO2, HC, Ozone, Part \cr
  Index:   Date [3652] (TZ: "UTC")
}
\details{
These are the original data from \kbd{http://www.sungpark.net/ShumwayAzariPawitan88.pdf}.
}

\note{The data \code{lap} is taken from this file, but the details were never entirely 
clear and it's too late to get exact details now.  Hence, the weekly averages data set 
\code{lapw.xts} computed in the examples below is a slightly different data set than 
\code{lap}. The names for  this data set are different from \code{lap}, the main difference
is these names have capitals.
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

lapw.xts = apply.weekly(lap.xts, FUN=colMeans)  # get weekly averages

plot(lapw.xts[,c('Cmort', 'Temp', 'Part')], col=astsa.col(2:4, .7)) 

sarima(lapw.xts$Cmort, 0,1,1)  # fit ARIMA(0,1,1) to Cmort
}
}
\keyword{datasets}
