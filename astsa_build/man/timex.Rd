\name{timex}
\alias{timex}
\title{
Convert eXtensible Time Series Dates to Decimal Dates
}
\description{
Takes an 'xts' data file, extracts the dates and converts them to decimal dates without having to have the 'xts' package loaded.
}
\usage{
timex(xts.object)
}
\arguments{
  \item{xts.object}{
an 'xts' data object
}
}
\details{
For a data file made using the 'xts' package, this will produce a vector of decimal dates corresponding to the date of each observation even if 'xts' is not loaded. The script is a converter from 'unix time stamp' to decimal dates. For example, the unix time stamp of 2016-04-20 at 00:00:00 UTC is 1461110400. This will be converted to 2016.301 because 2016 was a leap year and April 20 is day 111 of the year. Thus its decimal date is 2016 + (110/366) noting that the first day of the year is day 0. 

The input object must be an 'xts' object. Note that if \code{dog} is an 'xts' data file with columns of time series, \code{dog[,2]} is NOT unless 'xts' is loaded. Thus, \code{t <- timex(dog)} will work but  \code{t <- timex(dog[,2])} may not.
}
\value{
A vector of decimal dates is returned invisibly.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at  \url{https://nickpoison.github.io/}. 
}
\author{
D.S. Stoffer
}
\note{We recommend the installation of 'xts' if you are working with time series, but we wanted to have an "option out" in the off chance that it can't (or won't) be installed.
}

\examples{

tsplot(timex(lap.xts), lap.xts[,'Cmort'], col=4, ylab=NA, gg=TRUE)
title('Daily Cardiovascular Mortality')

DJIA = ts(djia[,'Close'])  
x    = cbind(DJIA, Return = diff(log(DJIA)))
tsplot(timex(djia), x, col=5, main="What, Me Worry?")

}
\keyword{ ts }

