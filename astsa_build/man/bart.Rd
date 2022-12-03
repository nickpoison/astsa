\name{bart}
\alias{bart}
\title{
Bartlett Kernel
}
\description{
Smoothing (triangular) kernel that decreases one unit from the center.
}
\usage{
bart(m)
}
\arguments{
  \item{m}{non-negative integer specifying the kernel width, which is \code{2m + 1}.  If \code{m} has length larger than one, the convolution of the kernel is returned.
}
}
\details{
Uses \code{kernel} from the \code{stats} package to construct a Bartlett (triangular) kernel of width \code{2m + 1}; see \code{help(kernel)} for further details.
}
\value{
Returns an object of class \code{tskernel} with the coefficients, the kernel dimension, and attribute  "Bartlett".
}
\author{
D.S. Stoffer
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
plot(bart(4), ylim=c(0,.2))
}
\keyword{ts}
