\name{polyMul}
\alias{polyMul}
\title{Multiplication of Two Polynomials}
\description{Multiplication of two polynomials.}
\usage{polyMul(p, q)}
\arguments{
  \item{p}{coefficients of first polynomial}  
  \item{q}{coefficients of second polynomial}
}
\details{inputs are vectors of coefficients in order of power
         \eqn{ax^0 + bx^1 + cx^2 + ...}  }
\value{coefficients of the product in order of power}
\author{D.S. Stoffer}
\references{based on code from the polymatrix package
\url{https://github.com/namezys/polymatrix}
}
\keyword{math}
\examples{
a = 1:3  # 1 + 2x + 3x^2
b = 1:2  # 1 + 2x
polyMul(a, b) 
# [1] 1 4 7 6
# 1 + 4x + 7x^2 + 6x^3
}