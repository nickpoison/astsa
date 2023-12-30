\name{SV.mle}
\alias{SV.mle}
\title{
Stochastic Volatility Model with Feedback via MLE
}
\description{
Fits a stochastic volatility model with feedback (optional) to a univariate time series of returns via quasi-MLE.
}
\usage{
SV.mle(returns, gamma = 0, phi = 0.95, sQ = 0.1, alpha = NULL, sR0 = 1, mu1 = -3, sR1 = 2, 
        rho = NULL, feedback = FALSE)
}
\arguments{
  \item{returns}{
single time series of returns
}
  \item{gamma}{
feedback coefficient - included if \code{feedback=TRUE} (does not have to be specified)
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
  \item{rho}{
correlation between the state noise and observation noise (so called "leverage"). If \code{feedback=TRUE}
this will be included if given a proper numerical value; if NULL (default) it is not included because 
it is often not significant when the feedback coefficient is included.   
}
  \item{feedback}{
if TRUE feedback is included in the model; default is FALSE.
}
}
\details{The returns are \eqn{r_t} (input this).
The log-volatility process is \eqn{x_t}   and 
 \eqn{y_t = \log r_t^2}. 
 
If \code{feedback=TRUE}, the model is
\deqn{x_{t+1} = \gamma r_t + \phi x_t + \sigma w_t \qquad y_t = \alpha + x_t + \eta_t}
where \eqn{w_t} is standard normal noise.  The observation error \eqn{\eta_t} is a mixture of
two normals, \eqn{N(0, \sigma_0^2)} and \eqn{N(\mu_1, \sigma_1^2)}.  The state
and observation noise can be correlated if \eqn{\rho} is given a value between -1 and 1.


If \code{feedback=FALSE}, \eqn{\gamma} and \eqn{\rho} are not included in the model.
}
\value{Returned invisibly:
\item{PredLogVol }{one-step-ahead predicted log-volatility }
\item{RMSPE }{corresponding root MSPE}
\item{Coefficients }{table of estimates and estimated standard errors}

In addition to the one step ahead predicted log-volatility, corresponding root MSPE, and table of estimates returned invisibly, the estimates and SEs are printed and a graph of (1) the data with the predicted log-volatility, and (2) the normal mixture are displayed in one graphic.
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

SV.mle(sp500.gr, feedback=TRUE)

SV.mle(nyse)
}
}

\keyword{ ts }
