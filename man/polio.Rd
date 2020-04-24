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
The data were originally modelled by Zeger (1988).
}
\source{Data taken from the gamlss.data package; see \url{https://www.gamlss.com/}.  
}
\references{
Zeger, S. L. (1988), ``A Regression Model for Time Series of
Counts,'' \emph{Biometrika}, 75, 822-835.
}
\examples{
tsplot(polio, type='s')
}
\keyword{datasets}
