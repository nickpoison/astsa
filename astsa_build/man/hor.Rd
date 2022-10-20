\name{hor}
\alias{hor}
\docType{data}
\title{Hawaiian occupancy rates}
\description{Quarterly Hawaiian hotel occupancy rate (percent of rooms occupied) from 
1982-I to 2015-IV
}
\format{
  The format is:
 Time-Series [1:136] from 1982 to 2015: 79  65.9  70.9  66.7  ...
}
\source{\url{https://dbedt.hawaii.gov/economic/qser/tourism/}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\examples{
tsplot(hor, type='c')                           # plot data and
text(hor, labels=1:4, col=c(1,4,2,6), cex=.9)   # add quarter labels
}
\keyword{datasets}

