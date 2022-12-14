\name{autoParm}
\alias{autoParm}
\title{
autoParm - Structural Break Estimation Using AR Models
}
\description{
Uses minimum description length (MDL) to fit piecewise AR processes with the goal of detecting changepoints in time series. Optimization is accomplished via a genetic algorithm (GA).
}
\usage{
autoParm(xdata, Pi.B = NULL, Pi.C = NULL, PopSize = 70, generation = 70, P0 = 20, 
         Pi.P = 0.3, Pi.N = 0.3, NI = 7)
}

\arguments{
  \item{xdata}{
time series (of length n at least 100) to be analyzed; the \code{ts} attributes are stripped 
prior to the analysis
}
  \item{Pi.B}{
probability of being a breakpoint in initial stage; default is 10/n. 
Does not need to be specified.
}
  \item{Pi.C}{
probability of conducting crossover; default is (n-10)/n.
Does not need to be specified.
}
  \item{PopSize}{
population size (default is 70); the number of chromosomes in each generation.
Does not need to be specified.
}
  \item{generation}{
number of iterations; default is 70.
Does not need to be specified.
}
  \item{P0}{
maximum AR order; default is 20. 
Does not need to be specified.
}
  \item{Pi.P}{
probability of taking parent's gene in mutation; default is 0.3.
Does not need to be specified.
}
  \item{Pi.N}{
probability of taking -1 in mutation; default is 0.3
Does not need to be specified.
}
  \item{NI}{
number if islands; default is 7.
Does not need to be specified.
}
}
\details{
Details my be found in Davis, Lee, & Rodriguez-Yam (2006). Structural break estimation for nonstationary time series models. JASA, 101, 223-239. \doi{10.1198/016214505000000745}
}
\value{
Returns three values, (1) the breakpoints including the endpoints, (2) the number of
segments, and (3) the segment AR orders.  See the examples.
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
\source{
The code is adapted from R code provided to us by Rex Cheung (\kbd{https://www.linkedin.com/in/rexcheung}).
}
\seealso{
\code{\link{autoSpec}}
}
\note{The GA is a stochastic optimization procedure and consequently will give different results at
each run.  It is a good idea to run the algorithm a few times before coming to a final decision.
}
\examples{
\dontrun{

##-- simulation
x1 = sarima.sim(ar=c(1.69, -.81), n=500)
x2 = sarima.sim(ar=c(1.32, -.81), n=500) 
x = c(x1, x2)

##-- look at the data
tsplot(x)

##-- run procedure
autoParm(x)

##-- output (yours will be slightly different - 
##--         the nature of GA) 
# returned breakpoints include the endpoints 
# $breakpoints
# [1]    1  514 1000
# 
# $number_of_segments
# [1] 2
# 
# $segment_AR_orders
# [1] 2 2
}
}
 \keyword{ ts}
