\name{polio}
\alias{polio}
\docType{data}
\title{
Poliomyelitis cases in US 
}
\description{
Monthly time series of poliomyelitis cases reported to the U.S. Centers for Disease Control for the years 1970 to 1983, 168 observations. }
\format{
  The format is:
 Time-Series [1:168] from 1970 to 1984: 0 1 0 0 1 3 9 2 3 5 ...
}
\details{
The data were originally modelled by Zeger (1988) ``A Regression Model for Time Series of
Counts,'' \emph{Biometrika}, 75, 822-835.
}
\source{Data taken from the gamlss.data package; see \url{https://www.gamlss.com/}.  
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\examples{
tsplot(polio, type='s')
}
\keyword{datasets}
