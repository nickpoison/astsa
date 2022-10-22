\name{ESS}
\alias{ESS}
\title{
Effective Sample Size (ESS)
} 
\description{
Estimates the ESS of a given vector of samples.
}
\usage{
ESS(trace, tol = 1e-08)
}
\arguments{
  \item{trace}{
vector of sampled values from an MCMC run (univariate only)
}
  \item{tol}{
ESS is returned as zero if the estimated spectrum at frequency zero is less than this value
}
}
\details{
Uses \code{\link{spec.ic}} to estimate the spectrum of the input at frequency zero (\code{spec0}). Then, ESS is estimated as
\code{ESS = length(trace)*var(trace)/spec0}.  
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
# Fit an AR(2) to the Recruitment series
u = ar.mcmc(rec, porder=2, n.iter=1000, plot=FALSE)  # it's efficient
# then calculate the ESSs 
apply(u, 2, ESS)
}
\keyword{ ts }

