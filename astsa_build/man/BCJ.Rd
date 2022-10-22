\name{BCJ}
\alias{BCJ}
\docType{data}
\title{
Daily Returns of Three Banks
} 
\description{
Daily returns of three banks, 1.  Bank of America [boa], 2. Citibank [citi], and
3.  JP Morgan Chase [jpm], from 2005 to 2017.
}
\format{
  The format is:
 Time-Series [1:3243, 1:3] from 2005 to 2017: -0.01378 -0.01157 -0.00155 -0.01084 0.01252 ...
 with column names  "boa" "citi" "jpm" .
}
\source{
Gong & Stoffer (2021). A Note on Efficient Fitting of Stochastic Volatility Models. 
\emph{Journal of Time Series Analysis}, 42(2), 186-200.

\url{https://github.com/nickpoison/Stochastic-Volatility-Models}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
tsplot(BCJ, col=2:4)
}
\keyword{datasets}
