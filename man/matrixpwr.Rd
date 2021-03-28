\name{matrixpwr}
\alias{matrixpwr}
\alias{\%^\%}
\title{
Powers of a Square Matrix
}
\description{
\code{matrixpwr} computes powers of a square matrix, including negative powers for nonsingular matrices.

\code{\%^\%} is a more intuitive interface as an operator.
}
\usage{
matrixpwr(A, power)

A \%^\% power
}
\arguments{
  \item{A}{
a square matrix
}
  \item{power}{
single numeric
}
}
\details{
Raises matrix to the specified power. The matrix must be square
and if \code{power < 0}, the matrix must be nonsingular.

Note that \code{\%^\%} is defined as
\code{"\%^\%" <- function(A, power) matrixpwr(A, power) }

If \code{power = 0}, the identity matrix is returned.
}
\value{
Returns matrix raised to the given power.
}
\references{
You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}. 
}
\author{
D.S. Stoffer 
}
\examples{
# 2-state Markov transition matrix to steady state
P = matrix(c(.7,.4,.3,.6), 2)       
P \%^\% 50

# Inverse square root
Q = var(econ5)
Q \%^\% -.5
}
\keyword{ math }