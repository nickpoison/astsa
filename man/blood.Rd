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
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/}
}
\seealso{\code{\link{HCT}}, \code{\link{PLT}}, \code{\link{WBC}}}
\examples{
plot(blood, type="o", pch=19)
}
\keyword{datasets}
