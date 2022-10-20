\name{SV.mcmc}
\alias{SV.mcmc}
\title{Fit Bayesian Stochastic Volatility Model
}
\description{
Fits a stochastic volatility model to a univariate time series of returns.
}
\usage{
SV.mcmc(y, nmcmc = 1000, burnin = 100, init = NULL, hyper = NULL, tuning = NULL, 
         sigma_MH = NULL, npart = NULL, mcmseed = NULL)
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
initial values of (phi, sigma, beta) -  default is \code{c(0.9, 0.5, .1)}
}
  \item{hyper}{
hyperparameters for bivariate normal distribution of (phi, sigma); user inputs (mu_phi, mu_q, sigma_phi, sigma_q, rho) - 
default is \code{c(0.9, 0.5, 0.075, 0.3, -0.25)}
}
  \item{tuning}{
tuning parameter -  default is \code{.03}
}
  \item{sigma_MH}{
covariance matrix used for random walk Metropolis; it will be scaled by \code{tuning} in the script - default is 
\code{matrix(c(1,-.25,-.25,1), nrow=2, ncol=2)}
}
  \item{npart}{
number of particles used in particle filter - default is \code{10}
}
  \item{mcmseed}{
seed for mcmc - default is \code{90210}
}
}
\details{
The log-volatility process is \eqn{x_t} and the returns are \eqn{y_t}. The SV model is
\deqn{x_t = \phi x_{t-1} + \sigma w_t \qquad y_t = \beta \exp\{\frac{1}{2} x_t\}\epsilon_t}
where \eqn{w_t} and \eqn{\epsilon_t} are independent standard normal white noise.

The model is fit using a technique described in the paper listed below (in the Source section) where the state
parameters \eqn{(\phi, \sigma)} are sampled simultaneously with a bivariate normal prior specified
in the arguments \code{init} and \code{hyper}.

Two graphics are returned: (1) the three parameter traces [with effective sample sizes (ESS)], their ACFs, and their histograms with the .025, .5, and .975 quantiles displayed, and (2) the log-volatility posterior mean along with corresponding .95 credible intervals.
}
\value{
Returned invisibly:
 \item{phi }{vector of sampled state AR parameter}
 \item{sigma }{vector of sampled state error stnd deviation}
 \item{beta }{vector of sampled observation error scale}
 \item{log.vol }{matrix of sampled log-volatility} 
 \item{options }{values of the input arguments}   
}
\source{Gong & Stoffer (2021). A note on efficient fitting of stochastic volatility models. \emph{Journal of Time Series Analysis}, 42(2), 186-200.  \url{https://github.com/nickpoison/Stochastic-Volatility-Models}

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
Except for the data, all the other inputs have defaults.  The time to run and the acceptance rate are returned at the end of the analysis.  The acceptance rate should be around 28\% and this can be adjusted using the tuning parameter.  
}


\examples{
\dontrun{
#--   A minimal example  --##
myrun <- SV.mcmc(sp500w)   # results in object myrun - don't forget it 

str(myrun)                 # an easy way to see the default input options
}
}
\keyword{ ts }