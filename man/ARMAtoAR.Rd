\name{ARMAtoAR}
\alias{ARMAtoAR}
\title{Convert ARMA Process to Infinite AR Process}
\description{
  Gives the \eqn{\pi}-weights in the invertible representation of an ARMA model.
}
\usage{
ARMAtoAR(ar = 0, ma = 0, lag.max=20)
}
\arguments{
  \item{ar}{vector of AR coefficients}
  \item{ma}{vector of MA coefficients}
  \item{lag.max}{number of pi-weights desired}
}
\value{
  A vector of coefficients.
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\examples{
ARMAtoAR(ar=.9, ma=.5, 10)
}
\keyword{ts}
