\name{polyMul}
\alias{polyMul}
\title{Multiplication of Two Polynomials} 
\description{Multiplication of two polynomials.}
\usage{polyMul(p, q)}
\arguments{
  \item{p}{coefficients of first polynomial}
  \item{q}{coefficients of second polynomial}
}
\details{inputs are vectors of coefficients a, b, c, ..., in order of power
         \eqn{ax^0 + bx^1 + cx^2 + ...}  }
\value{coefficients of the product in order of power}
\author{D.S. Stoffer}
\source{based on code from the polynom package 
\url{https://CRAN.R-project.org/package=polynom}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\keyword{math}
\examples{
a = 1:3  # 1 + 2x + 3x^2
b = 1:2  # 1 + 2x
polyMul(a, b)
# [1] 1 4 7 6
# 1 + 4x + 7x^2 + 6x^3
}