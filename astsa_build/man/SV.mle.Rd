\name{SV.mle}
\alias{SV.mle}
\title{
Fit Stochastic Volatility Model via MLE
}
\description{
Fits a stochastic volatility model to a univariate time series of returns via quasi-MLE.
}
\usage{
SV.mle(returns, phi = 0.95, sQ = 0.1, alpha = NULL, sR0 = 1, mu1 = -3, sR1 = 2)
}
\arguments{
  \item{returns}{
single time series of returns
}
  \item{phi}{
initial value of the log-volatility AR parameter (does not have to be specified)
}
  \item{sQ}{
initial value of the standard deviation of log-volatility noise (does not have to be specified)
}
  \item{alpha}{
initial value of the log-returns^2 constant parameter (does not have to be specified)
}
  \item{sR0}{
initial value of the log-returns^2 normal mixture standard deviation parameter (component 0 - does not have to be specified)
}
  \item{mu1}{
initial value of the log-returns^2 normal mixture mean parameter (component 1 - does not have to be specified)
}
  \item{sR1}{
initial value of the log-returns^2 normal mixture standard deviation parameter (component 1 - does not have to be specified)
}
}
\details{The returns are \eqn{r_t} (input this).
The log-volatility process is \eqn{x_t}   and 
 \eqn{y_t = \log r_t^2}. The SV model is
\deqn{x_t = \phi x_{t-1} + \sigma w_t \qquad y_t = \alpha + x_t + v_t}
where \eqn{w_t}  standard normal noise.  The observation error is a mixture of
two normals, \eqn{N(0, \sigma_0^2)} and \eqn{N(\mu_1, \sigma_1^2)}; thus 3 parameters are estimated for the observation noise.
}
\value{
The one step ahead predicted log-volatility and corresponding root MSPE are returned invisibly. The estimates and SEs are printed and a graph of the data and log-volatility, and the normal mixture as displayed in one graphic.
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
\seealso{
\code{\link{SV.mcmc}}
}
\examples{
\dontrun{

SV.mle(nyse)
}
}

\keyword{ ts }
