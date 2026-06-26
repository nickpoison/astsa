\name{UnempRate2}
\alias{UnempRate2}
\docType{data}
\title{U.S. Unemployment Rate (update)
}
\description{
Monthly U.S. unemployment rate in percent unemployed (Jan, 2016 - Feb, 2026)
}

\format{
  The format is:
 Time-Series [1:123] from 2016 to 2026: 5.3 5.2 5.1 4.7 4.5 5.1 5.1 5 4.8 4.7 ...
}
\details{
This is an update to \code{\link{UnempRate}}. There is some overlap in 2016, and the values are identical in the overlap.  There is one NA in October, 2025 due to a government shut down.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.    
}
\examples{
tsplot(x <- cbind(UnempRate, UnempRate2), spaghetti=TRUE, col=2*2:1)

# an easy way to make it one series using `x` above
#  and without using the `xts` or `zoo` packages, 
#   and noting the series are the same in the overlap
#    and both series can be NA at the same time
U = pmax(x[,1], x[,2], na.rm=TRUE)
tsplot(U)

}
\seealso{\code{\link{UnempRate}}}
\keyword{datasets}