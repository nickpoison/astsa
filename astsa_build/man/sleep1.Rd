\name{sleep1}
\alias{sleep1}
\docType{data}
\title{
Sleep State and Movement Data - Group 1
}
\description{
Sleep-state and number of movements of infants taken from a study on the effects of
prenatal exposure to alcohol. This is Group 1 where the mothers did not drink alcohol
during pregnancy.
}
\format{
  The format is: List of 12 (by subjects)
 $ :'data.frame':	120 obs. of  3 variables:
  ..$ min  : int [1:120] minute (1 to 120)
  ..$ state: int [1:120] sleep state 1 to 6 with NA missing
  ..$ mvmnt: int [1:120] number of movements
}
\details{
Per minute sleep state, for approximately 120 minutes, is categorized into one of
six possible states, non-REM: NR1 [1] to NR4 [4], and REM [5], or AWAKE [6].
NA means no state is recorded for that minute (if there, it occurs at end of the session).
Group 1 (this group) is from mothers who abstained from drinking during
pregnancy. In addition, the number of movements per minute are listed.
}
\source{
Stoffer, D. S., Scher, M. S., Richardson, G. A., Day, N. L., & Coble, P. A. (1988). A Walsh—Fourier Analysis of the Effects of Moderate Maternal Alcohol Consumption on Neonatal Sleep-State Cycling. Journal of the American Statistical Association, 83(404), 954-963. \url{https://doi.org/10.2307/2290119}

Stoffer, D. S. (1990). Multivariate Walsh-Fourier Analysis. Journal of Time Series Analysis, 11(1), 57-73.
\url{ https://doi.org/10.1111/j.1467-9892.1990.tb00042.x}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\examples{
par(xpd = NA, oma=c(0,0,0,8) )
tsplot(sleep1[[1]][2:3], type='s', col=2:3, spag=TRUE, gg=TRUE)
legend('topright', inset=c(-0.25,0), bty='n', lty=1, col=2:3, legend=c('sleep state', 'number of \nmovements'))

x = dna2vector(sleep1[[1]]$state[1:115], alphabet=c('1','2','3','4','5'))  # never awake
specenv(x, spans=c(3,3))
abline(v=1/60, lty=2, col=8)
}
\seealso{\code{\link{sleep2}}}
\keyword{datasets}
