\name{arf}
\alias{arf}
\docType{data}
\title{Simulated ARFIMA
} 
\description{1000 simulated observations from an ARFIMA(1, 1, 0) model with \eqn{\phi = .75} and \eqn{d = .4}.
}
\format{
  The format is:
 Time-Series [1:1000] from 1 to 1000: -0.0294 0.7487 -0.3386 -1.0332 -0.2627 ...
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\examples{

par(mfrow=2:1)
tsplot(arf, col=4, main='ARFIMA')
acf1(arf, col=4, main=NA)

}
\keyword{datasets}
