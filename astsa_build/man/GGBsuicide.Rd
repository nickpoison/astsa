\name{GGBsuicide}
\alias{GGBsuicide}
\docType{data}
\title{
Golden Gate Bridge Suicides, 1999-2009
}
\description{
Number of days between suicides on the Golden Gate Bridge from 1999 to 2009
}
\format{
  The format is:
 num [1:223] 30.6 37.48 2.67 9.08 4 ...
}
\details{
For the period 1999-2009, the time  (in units of days) between suicides from the Golden Gate Bridge in California as documented by the medical examiner's office in Marin County. There were 224 suicides during this 11 year period.  The number of suicides per year are: 17,11,13,19,19,19,21,28,36,21,20, in chronological order.
}
\source{
Mackenzie, D. W., Lester, D., Manson, R.,  Yeh, C. (2016). Do suicides from the golden gate bridge cluster? Psychological Reports, 118(1), 70-73.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\examples{
plot(ecdf(GGBsuicide))
curve(pexp(x, rate = 1/mean(GGBsuicide)), add = TRUE, col = 2, lwd = 2)
}
\keyword{datasets}
