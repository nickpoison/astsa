\name{fmri1}
\alias{fmri1}
\docType{data}
\title{fMRI Data Used in Chapter 1
} 
\description{A data frame that consists of average fMRI BOLD signals at eight locations.
}
\usage{data(fmri1)}
 \format{
   The format is:
  mts [1:128, 1:9] }
\details{Multiple time series consisting of fMRI BOLD signals at eight locations (in columns 2-9, column 1 is time period), when a stimulus was applied for 32 seconds and then stopped for 32 seconds. The signal period is 64 seconds and the sampling rate was one observation every 2 seconds for 256 seconds (\eqn{n = 128}).  The columns are labeled: "time" "cort1" "cort2" "cort3"  "cort4"   "thal1"   "thal2"  "cere1"  "cere2".
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\seealso{\code{\link{fmri}}}
\examples{
tsplot(fmri1[,2:9], ncolm=4, gg=TRUE, col=c(rep(4,4),rep(3,2),rep(6,2)))
}
\keyword{datasets}