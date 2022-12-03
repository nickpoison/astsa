\name{autoSpec}
\alias{autoSpec}
\title{
autoSpec - Changepoint Detection of Narrowband Frequency Changes
}
\description{
Uses changepoint detection to discover if there have been slight changes in frequency 
in a time series.  The autoSpec procedure uses minimum description length (MDL) 
to do nonparametric spectral estimation with the goal of detecting changepoints. 
Optimization is accomplished via a genetic algorithm (GA).
}
\usage{
autoSpec(xdata, n = length(xdata), Pi.B = 10/n, Pi.C = (n - 10)/n, PopSize = 70, 
          generation = 70, P0 = 20, Pi.P = 0.3, Pi.N = 0.3, NI = 7, taper = 0.5, 
          max.period = 2)
}
\arguments{
  \item{xdata}{
time series to be analyzed; the \code{ts} attributes are stripped 
prior to the analysis
}
  \item{n}{
the number of observations - should not be specified; it is only used for 
the defaults of \code{Pi.B} and \code{Pi.C}.
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
maximum width of the Bartlett kernel is \code{2*P0 + 1}; default is 20. 
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
  \item{taper}{
half width of taper used in spectral estimate; .5 (default) is full taper
}
  \item{max.period}{
the frequency range [0, 1/max.period] over which to calculate the Whittle likelihood;
the default is 2 (the min).
}
}
\details{
Details my be found in Stoffer, D. S. (2023). AutoSpec: Detection of narrowband frequency changes in time series. Statistics and Its Interface, 16(1), 97-108. \url{https://dx.doi.org/10.4310/21-SII703}
}
\value{
Returns three values, (1) the breakpoints including the endpoints, (2) the number of
segments, and (3) the segment kernel orders.  See the examples.
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
\note{
The code was adapted from the code used in Davis, Lee, & Rodriguez-Yam (2006). Structural break estimation for nonstationary time series models. Journal of the American Statistical Association, 101(473), 223-239.
}

\examples{
\dontrun{

##-- simulation
num = 500
t   = 1:num
w   = 2*pi/25
d   = 2*pi/150
x1  = 2*cos(w*t)*cos(d*t) + rnorm(num)
x2  = cos(w*t) + rnorm(num)
x   = c(x1,x2)

##-- periodogram - all action below 0.1
mvspec(x)

##-- run procedure
autoSpec(x, max.period=10)

##-- output (yours will be slightly different - 
##--         the nature of GA) 
# returned breakpoints include the endpoints 
# $breakpoints
# [1]    1  526 1000
# 
# $number_of_segments
# [1] 2
# 
# $segment_kernel_orders_m
# [1] 2 1


##-- plot everything
par(mfrow=c(3,1))
tsplot(x, col=4)
 abline(v=525.5, col=6, lty=2, lwd=2)
mvspec(x[1:525],    kernel=bart(2), taper=.5, main='segment 1', col=4, xlim=c(0,.25))
mvspec(x[526:1000], kernel=bart(1), taper=.5, main='segment 2', col=4, xlim=c(0,.25))   
##-- end --##

##-- for a real data example try
autoSpec(ENSO, max.period=4)
}
}
\keyword{ ts }

