\name{djia}
\alias{djia}
\docType{data}
\title{Dow Jones Industrial Average
} 
\description{Daily DJIA values from April 2006 - April 2016
}
\format{
  The format is:
 xts [1:2518, 1:5] 11279 11343 11347 11337 11283 ...\cr
 - attr(*, "class")= chr [1:2] "xts" "zoo"\cr
  ..$ : chr [1:5] "Open" "High" "Low" "Close" "Volume"
}
\source{The data were obtained via the TTR package and Yahoo financial data.
Unfortunately, this does not work now. It seems like the R package
\code{quantmod} is a good bet and Yahoo still has financial data.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\keyword{datasets}
