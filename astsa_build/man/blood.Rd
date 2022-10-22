\name{blood}
\alias{blood}
\docType{data}
\title{Daily Blood Work with Missing Values
} 
\description{Multiple time series of measurements made for 91 days on the three variables, log(white blood count) [WBC], log(platelet) [PLT] and hematocrit [HCT].  Missing data code is NA.
}
\format{
 Time-Series [1:91, 1:3] from 1 to 91: 2.33 1.89 2.08 1.82 1.82 ...

  ..$ : NULL
  ..$ : chr [1:3] "WBC" "PLT" "HCT"
}
\details{This data set is used in Chapter 6 for a missing data example.
}
\source{Jones, R.H. (1984). Fitting multivariate models to unequally spaced data. In \emph{Time Series Analysis of Irregularly Observed Data}, pp. 158-188. E. Parzen, ed. Lecture Notes in Statistics, 25, New York: Springer-Verlag.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\seealso{\code{\link{HCT}}, \code{\link{PLT}}, \code{\link{WBC}}}
\examples{
tsplot(blood, type='o', pch=19, cex=1.1, col=2:4, gg=TRUE, xlab='day')
}
\keyword{datasets}
