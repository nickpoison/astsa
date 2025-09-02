\name{sp500w}
\alias{sp500w}
\docType{data}
\title{Weekly Growth Rate of the Standard and Poor's 500
} 
\description{Weekly closing returns of the SP 500 from 2003 to September,  2012.
}
\format{An 'xts' object on 2003-01-03 to 2012-09-28; 
  Indexed by objects of class: [Date] TZ: UTC
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\examples{

# if 'xts' is not loaded, you can do this
tsplot(sp500w, col=4, lwd=2)                 # no dates
tsplot(timex(sp500w), sp500w, col=4, lwd=2)  # dates

}
\keyword{datasets}
