\name{ar.mcmc}
\alias{ar.mcmc}
\title{Fit Bayesian AR Model 
} 
\description{
Uses Gibbs sampling to fit an AR model to time series data.
}
\usage{
ar.mcmc(xdata, porder, n.iter = 1000, n.warmup = 100, plot = TRUE,  
        prior_var_phi = 50, prior_sig_a = 1, prior_sig_b = 2, ...)
}
\arguments{
  \item{xdata}{
time series data (univariate only)
}
  \item{porder}{
autoregression order
}
  \item{n.iter}{
number of iterations for the sampler
}
  \item{n.warmup}{
number of startup iterations for the sampler (these are removed)
}
  \item{plot}{
if TRUE (default) returns the draws after warmup (diagonal) and a
scatterplot matrix of the draws (off-diagonal)
}
  \item{prior_var_phi}{
prior variance of the vector of AR coefficients; see details
}
  \item{prior_sig_a}{
first prior for the variance component; see details
}
  \item{prior_sig_b}{
second prior for the variance component; see details
}
  \item{...}{
additional graphic parameters passed to \code{tspairs}
}
}
\details{
Assumes a normal-inverse gamma model,
\deqn{x_t = \phi_0 + \phi_1 x_{t-1} + \dots + \phi_p x_{t-p} + \sigma z_t ,}
where \eqn{z_t} is standard Gaussian noise.
With \eqn{\Phi} being the (p+1)-dimensional vector of the \eqn{\phi}s,
the priors are 
\eqn{\Phi \mid \sigma \sim N(0, \sigma^2 V_0)} and
\eqn{\sigma^2 \sim IG(a,b)}, where \eqn{V_0 = \gamma^2 I}.
Defaults are given for the hyperparameters, but the user
may choose \eqn{(a,b)} as \code{(prior_sig_a, prior_sig_b)}
and \eqn{\gamma^2} as \code{prior_var_phi}.

The algorithm is efficient and converges quickly.
Further details can be found in Chapter 6 of the 5th edition of the 
Springer text.
}
\value{In addition to the graphics (if plot is TRUE), 
the  draws of each parameter (\code{phi0, phi1, ..., sigma})
are returned invisibly and means, standard deviations, and
various quantiles are displayed.  
}
\author{
D.S. Stoffer
}
\source{Based on the script \code{arp.mcmc} used in Douc,  Moulines, & Stoffer, D. (2014).
\emph{ Nonlinear Time Series: Theory, Methods and Applications with R Examples}. CRC press. 
ISBN 9781466502253.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
\dontrun{

u = ar.mcmc(rec, 2)

dev.new()
tspairs(u, hist=FALSE, col.diag=6)  # another view 

dev.new()
tsplot(u, ncol=2, col=4, xlab='Index')  # traces only

apply(u, 2, ESS)    # effective sample sizes
}
}
\keyword{ts}