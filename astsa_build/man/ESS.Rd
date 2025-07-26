\name{ESS}
\alias{ESS}
\title{
Effective Sample Size (ESS)
} 
\description{
Estimates the ESS of a given vector of samples.
}
\usage{
ESS(trace, tol = 1e-08, BIC = TRUE, digits=2)
}
\arguments{
  \item{trace}{
vector of sampled values from an MCMC run (univariate only)
}
  \item{tol}{
ESS is returned as zero if the estimated spectrum at frequency zero is less than this value
}
  \item{BIC}{
if TRUE (default), \code{spec0} is obtained using BIC;
otherwise, AIC is used.  See the details.
}
  \item{digits}{
integer indicating the approximate number of decimal places to be used
}
}
\details{
Uses \code{\link{spec.ic}} to estimate the spectrum of the input at frequency zero (\code{spec0}). Then, ESS is estimated as \code{ESS = length(trace)*var(trace)/spec0}.  See Examples for multivariate case. 

ESS is discussed in detail in Example 6.31 of \href{https://link.springer.com/book/10.1007/978-3-031-70584-7}{Time Series Analysis and Its Applications: With R Examples (5th ed, 2025)}. 
}
\value{
Returns the estimated ESS of the input.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\author{
D.S. Stoffer
}
\examples{
# How autocorrelation affects ESS
x   = matrix(NA, 500, 3)  # sample size is 500
phi = c(0,.3,.9)          # no, low, high
for (i in 1:3) x[,i] = sarima.sim(ar=phi[i])
apply(x, 2, ESS, digits=-1)

}
\keyword{ ts }

