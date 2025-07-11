\name{USpop}
\alias{USpop}
\docType{data}
\title{
U.S. Population - 1900 to 2010
}
\description{
U.S. Population by official census, every ten years from 1900 to 2010.
}
\format{
  The format is:
 Time-Series [1:12] from 1900 to 2010: 76 92 106 123 132 ...
}
\details{
The census from 2020 is not included in this data set because, by many accounts, it was a nightmare (\kbd{https://www.npr.org/2022/01/15/1073338121/2020-census-interference-trump}) due to the COVID-19 pandemic coupled with the fact that the Census Bureau is in the Department of Commerce, and its head is appointed by and reports directly to the POTUS, who at the time was DJ tRump: "Historians rank Trump among worst presidents in US history ... " (\kbd{https://www.businessinsider.com/historians-rank-trump-among-worst-presidents-us-history-c-span-2021-6}).

The data with the 2020 census is in \code{\link{USpop20}}.  Note that the two data files differ a bit, presumably because they are revised ad infinitum.  Both data sets were obtained from the Census Bureau's website. 
}
\source{
\kbd{https://www.census.gov/}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\seealso{\code{\link{USpop20}} }
\keyword{datasets}
