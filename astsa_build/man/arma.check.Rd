\name{arma.check}
\alias{arma.check}
\title{
Check an ARMA Model for Causality, Invertibility, and Parameter Redundancy
}
\description{
For a give ARMA model (including seasonal models), reports whether the model is causal,
invertible, or (approximately) over-parameterized.
}
\usage{
arma.check(ar = 0, ma = 0, sar = NULL, sma = NULL, S = NULL, redundancy.tol = 0.1)
}
\arguments{
  \item{ar}{
vector of AR parameters
}
  \item{ma}{
vector of MA parameters
}
  \item{sar}{
vector of seasonal AR parameters (only specify for seasonal models)
}
  \item{sma}{
vector of seasonal MA parameters  (only specify for seasonal models)
}
  \item{S}{
seasonal period  (only specify for seasonal models)
}
  \item{redundancy.tol}{
tolerance for reporting parameter redundancy
}
}
\details{
If the model is not causal or invertible, these are reported and checking is stopped if either condition is reported. 

If the model is causal and invertible, a warning is given if there are (approximate) common zeros.

To evaluate parameter redundancy, the inverse roots of the AR and MA polynomials are examined for closeness with \code{redundancy.tol} determining closeness. For example, \code{arma.spec(ar= .9, ma= -.88)} will produce an over-parameterization warning using the default tolerance. The Fisher Information matrix for ARMA is singular for exact redundancy, and its closeness to singularity can be measured by the closeness of the inverse of those roots [e.g., Klein and Spreij (1997). On Fisher’s information matrix of an ARMA process. In \emph{Stochastic Differential and Difference Equations}, 273-284. Boston: Birkhauser.] 
}
\value{
See the details. If the model is causal and invertible and not over-parameterized, a nice message of validation is given.  Otherwise, problems are reported but the specific culprits may not be specified.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{D.S. Stoffer
}
\seealso{\code{\link{arma.spec}}, \code{\link{sarima.sim}}, \code{\link{ARMAtoAR}}, \code{\link{ARMAtoMA}} }
\examples{
arma.check(ar=.9, ma=-.88)

arma.check(ar=c(1,-.9), sar=-.6, sma=-.4, S=4)

arma.check(sar=1, S=12)

arma.check(ar=.9, ma=c(-1,.9,.8))
# check its pi weights
ARMAtoAR(ar=.9, ma=c(-1,.9,.8)) 
}
\keyword{ts}