\name{SV.mcmc}
\alias{SV.mcmc}
\title{Fit Bayesian Stochastic Volatility Model
}
\description{
Fits a stochastic volatility model to a univariate time series of returns.
}
\usage{
SV.mcmc(y, nmcmc = 1000, burnin = 100, init = NULL, hyper = NULL, tuning = NULL, sigma_MH = NULL, npart = NULL, mcmseed = NULL)
}
\arguments{
  \item{y}{
single time series of returns
}
  \item{nmcmc}{
number of iterations for the MCMC procedure
}
  \item{burnin}{
number of iterations to discard for the MCMC procedure
}
  \item{init}{
initial values of (phi, sigma, beta)
}
  \item{hyper}{
hyperparameters for bivariate normal (phi, sigma), user inputs (mu_phi, mu_q, sigma_phi, sigma_q, rho)
}
  \item{tuning}{
tuning parameter
}
  \item{sigma_MH}{
covariance matrix for random walk Metropolis
}
  \item{npart}{
number of particles used in particle filter
}
  \item{mcmseed}{
seed for mcmc
}
}
\details{
The log-volatility process is \eqn{x_t} and the returns are \eqn{y_t}. The SV model is
\deqn{x_t = \phi x_{t-1} + \sigma w_t; \quad y_t = \beta \exp\bigl\{\tfrac{1}{2} x_t\bigr\}\epsilon_t}
where \eqn{w_t} and \eqn{\epsilon_t} are independent standard normal white noise.
The model is fit using a technique described in the paper listed in the source.
Two graphics are returned, the three parameter traces, their ACFs, and their histograms with
the .025, .5, and .975 quantiles displayed.
}
\value{
 \item{phi }{sampled state AR parameter}
 \item{sigma }{sample state error stnd deviation}
 \item{beta }{sampled observation error scale}
 \item{X }{sampled log-volatility} 
 \item{inputs }{values of the arguments}   
}
\source{Gong \& Stoffer . (2021). A note on efficient fitting of stochastic volatility models. \emph{Journal of Time Series Analysis}, 42(2), 186-200.  \url{https://github.com/nickpoison/Stochastic-Volatility-Models}
and  \url{https://doi.org/10.1111/jtsa.12561}
}
\references{
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\author{
D.S. Stoffer
}
\note{
Except for the data, all the other inputs have defaults.  The time to run and the acceptance rate are returned at the end of the analysis.  The acceptance rate should be around 28% and this can be adjusted using the tuning parameter.  
}

\section{Warning }{There is a large amount of output and it is highly recommended that the output be sent to an object.} 


\examples{
\dontrun{
#--   A minimal example  --##
myrun <- SV.mcmc(sp500.gr)   # results in object myrun - don't forget it 
}
}
\keyword{ ts }