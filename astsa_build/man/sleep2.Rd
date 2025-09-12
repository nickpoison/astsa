\name{sleep2}
\alias{sleep2}
\docType{data}
\title{
Sleep State and Movement Data - Group 2
} 
\description{
Sleep-state and number of movements of infants taken from a study on the effects of
prenatal exposure to alcohol. This is Group 2 where the mothers drank alcohol in
moderation during pregnancy.
}
\format{
   List of 12 (by subjects)
   :'data.frame':	120 obs. of  3 variables:
  .. min  : int [1:120] minute (1 to 120)
  .. state: int [1:120] sleep state 1 to 6 with NA missing (see details)
  .. mvmnt: int [1:120] number of movements
}
\details{
Per minute sleep state, for approximately 120 minutes, is categorized into one of
six possible states, non-REM: NR1 [1] to NR4 [4], and REM [5], or AWAKE [6].
NA means no state is recorded for that minute (if there, it occurs at end of the session).
Group 2 (this group) is from mothers who drank alcohol in moderation during
pregnancy. In addition, the number of movements per minute are listed.
}
\source{
Stoffer, D. S., Scher, M. S., Richardson, G. A., Day, N. L., Coble, P. A. (1988). A Walsh-Fourier Analysis of the Effects of Moderate Maternal Alcohol Consumption on Neonatal Sleep-State Cycling. Journal of the American Statistical Association, 83(404), 954-963. \kbd{https://doi.org/10.2307/2290119}

Stoffer, D. S. (1990). Multivariate Walsh-Fourier Analysis. Journal of Time Series Analysis, 11(1), 57-73.
\kbd{ https://doi.org/10.1111/j.1467-9892.1990.tb00042.x}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
tsplot(sleep2[[1]][,1], sleep2[[1]][,2:3], type='s', col=2*2:3, xlab='minute')
title('Baby Goo from Group 2', outer=TRUE, line=-1, cex.main=1)

}
\seealso{\code{\link{sleep1}}}
\keyword{datasets}
