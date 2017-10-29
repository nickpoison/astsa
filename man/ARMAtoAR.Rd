\name{ARMAtoAR}
\alias{ARMAtoAR}
\title{Convert ARMA Process to Infinite AR Process}
\description{
  Gives the \eqn{\pi}-weights in the invertible representation of an ARMA model.
}
\usage{
ARMAtoAR(ar = numeric(), ma = numeric(), lag.max)
}
\arguments{
  \item{ar}{numeric vector of AR coefficients}
  \item{ma}{numeric vector of MA coefficients}
  \item{lag.max}{number of pi-weights desired}
}
\value{
  A vector of coefficients.
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}}
\examples{
# From Section 3.1
ARMAtoAR(ar=.9, ma=.5, 10)
}
\keyword{ts}
