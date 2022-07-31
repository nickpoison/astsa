\name{blood}
\alias{blood}
\docType{data}
\title{Daily Blood Work
}
\description{Multiple time series of measurements made for 91 days on the three variables, log(white blood count) [WBC], log(platelet) [PLT] and hematocrit [HCT].  Missing data code is NA.
}
\format{
   The format is:
  mts [1:91, 1:3] }
\details{This is the data set used in Chapter 6 with NA as the missing data code.
}
\source{Jones, R.H. (1984). Fitting multivariate models to unequally spaced data. In \emph{Time Series Analysis of Irregularly Observed Data}, pp. 158-188. E. Parzen, ed. Lecture Notes in Statistics, 25, New York: Springer-Verlag.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\seealso{\code{\link{HCT}}, \code{\link{PLT}}, \code{\link{WBC}}}
\examples{
tsplot(blood, type="o", pch=19)
}
\keyword{datasets}
