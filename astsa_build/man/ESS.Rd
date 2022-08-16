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

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.   
}
\author{
D.S. Stoffer
}
\examples{
# Fit an AR(2) to the Recruitment series
u = ar.mcmc(rec, 2, plot=FALSE)  # it's efficient
# then calculate some ESSs (one at a time only)
ESS(u[,'phi1'])
ESS(u[,'phi2'])
}
\keyword{ ts }

