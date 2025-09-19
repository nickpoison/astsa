\name{ar.boot}
\alias{ar.boot}
\title{Bootstrap Distribution of AR Model Parameters
}
\description{
Performs a nonparametric bootstrap to obtain the distribution of the AR model parameters.
}
\usage{
ar.boot(series, order.ar, nboot = 500, seed = NULL, plot = TRUE, ...)
}
\arguments{
  \item{series}{
time series data (univariate only)
}
  \item{order.ar}{
autoregression order - must be specified
}
  \item{nboot}{
number of bootstrap iterations (default is 500)
}
  \item{seed}{
seed for the bootstrap sampling (defalut is NULL)
}
  \item{plot}{
if TRUE (default) and \code{order.ar > 1}, returns a scatterplot matrix of the bootstrapped parameters, - the diagonals show a histogram. 
}
  \item{...}{
if \code{plot=TRUE} and order.ar > 1, graphical parameters sent to \code{tspairs}
}
}
\details{
For a specified \code{series}, finds the bootstrap distribution of the
Yule-Walker estimates of \eqn{\phi_1,\dots,\phi_p} in the AR model specified by \code{order.ar},
\deqn{x_t = \mu + \phi_1 (x_{t-1}-\mu) + \dots + \phi_p (x_{t-p}-\mu) + w_t ,}
where \eqn{w_t} is white noise. The data are centered by the sample mean prior to the bootstrap simulations.

The script displays a number of quantiles of the bootstrapped estimates, the means, the biases, and the root mean squared errors.
}
\value{
Returned invisibly as a list:
 \item{phi.star }{[[1]] bootstrapped AR parameters}
 \item{x.sim }{[[2]] bootstrapped data}
 \item{mean.star }{[[3]] bootstrapped mean }
 \item{var.star }{[[4]] bootstrapped noise variance}
 \item{yw.fit }{[[5]] results of Yule-Walker fit to the data}
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
\dontrun{

u = ar.boot(rec, 2)
dev.new()
tspairs(u[[1]], hist=FALSE)   # another view of results
head(u[[1]])       # some booted AR parameters
head(u[[2]][,1:5]) # some booted data
}
}
\keyword{ ts }
