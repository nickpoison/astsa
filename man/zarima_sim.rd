\name{zarima_sim}
\alias{zarima_sim}
\title{Support Script for ARIMA Simulation}
\description{
 This is here only to be used by \code{sarima.sim}.
}
\usage{
zarima_sim(model, n, rand.gen = rnorm, innov = rand.gen(n, \dots),
          n.start = NA, start.innov = rand.gen(n.start, \dots),
          \dots)
}
\arguments{
  \item{model}{A list with component \code{ar} and/or \code{ma} giving
    the AR and MA coefficients respectively.  Optionally a component
    \code{order} can be used.}
  \item{n}{length of output series, before un-differencing.  A strictly
    positive integer.}
  \item{rand.gen}{optional: a function to generate the innovations.}
  \item{innov}{an optional times series of innovations.  If not
    provided, \code{rand.gen} is used.}
  \item{n.start}{length of \sQuote{burn-in} period.  If \code{NA}, the
    default, a reasonable value is computed.}
  \item{start.innov}{an optional times series of innovations to be used
    for the burn-in period.  If supplied there must be at least
    \code{n.start} values (and \code{n.start} is by default computed
    inside the function).}
  \item{\dots}{additional arguments for \code{rand.gen}.  Most usefully,
    the standard deviation of the innovations generated by \code{rnorm}
    can be specified by \code{sd}.}
}
\details{
  \code{sarima.sim} uses this script to generate (seasonal) ARIMA models.  
   This is here only to support the simulation.
}
\value{
  A time-series object of class \code{"ts"}.
}
\note{This is similar to \code{stats::arima.sim}, but do NOT use this in its 
place because it's not meant to be a stand alone script. Instead,  use 
\code{\link{sarima.sim}} to simulate from (seasonal) ARIMA models with 
simple syntax.
}
\seealso{
  \code{\link{sarima.sim}}
}
\keyword{internal}