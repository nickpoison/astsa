\name{matrixpwr}
\alias{matrixpwr}

\title{
Powers of a Square Matrix
}
\description{
Computes powers of a square matrix.
}
\usage{
matrixpwr(A, power)
}
\arguments{
  \item{A}{
square matrix
}
  \item{power}{
numeric
}
}
\details{
Raises matrix to the specified power. The matrix must be square
and if \code{power < 0}, the matrix must be nonsingular.
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
matrixpwr(P, 50)    

# Inverse square root
Q = var(econ5)
matrixpwr(Q, -.5) 
}
\keyword{ math }