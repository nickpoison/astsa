\name{gas}
\alias{gas}
\docType{data}
\title{Gas Prices
} 
\description{New York Harbor conventional regular gasoline weekly spot price FOB (in cents per gallon) from 2000 to mid-2010.
}
\format{
  The format is:
 Time-Series [1:545] from 2000 to 2010: 70.6 71 68.5 65.1 67.9 ...
}
\details{Pairs with series \code{oil}
}
\source{Data were obtained from: \kbd{https://www.eia.gov/dnav/pet/pet_pri_spt_s1_w.htm}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
tsplot(cbind(gas,oil), spag=TRUE, col=2*1:2, addLegend=TRUE)

}
\seealso{\code{\link{oil}}}
\keyword{datasets}