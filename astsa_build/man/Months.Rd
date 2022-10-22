\name{Months}
\alias{Months}
\docType{data}
\title{
Month Labels
}
\description{
Provides labels for the (English) months of the year to be used in plotting monthly time series.
} 
\format{
  The format is:
 chr [1:12] "J" "F" "M" "A" "M" "J" "J" "A" "S" "O" "N" "D"
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\note{Hi Kids. The months of the year in English are:

January, February, March, April, May, June, July, August, September, October, November, December.
}
\examples{
sAR = sarima.sim(sar=.9, S=12, n=36)
tsplot(sAR, type='c')
points(sAR, pch=Months, cex=1.1, font=4, col=1:4)
}
\keyword{attribute}