\name{sarima}
\alias{sarima}
\title{Fit ARIMA Models
%%  ~~function to do ... ~~
}
\description{Fits ARIMA models (including improved diagnostics) in a short command.  It can also be used to perform regression with autocorrelated errors. This is a front end to \code{arima()} with a different back door.
}
\usage{
sarima(xdata, p, d, q, P = 0, D = 0, Q = 0, S = -1, 
       details = TRUE, xreg=NULL, Model=TRUE,
       tol = sqrt(.Machine$double.eps), 
       no.constant = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xdata}{univariate time series
%%     ~~Describe \code{xdata} here~~
}
  \item{p}{AR order (must be specified)
%%     ~~Describe \code{p} here~~
}
  \item{d}{difference order (must be specified)
%%     ~~Describe \code{d} here~~
}
  \item{q}{MA order (must be specified)
%%     ~~Describe \code{q} here~~
}
  \item{P}{SAR order; use only for seasonal models 
%%     ~~Describe \code{P} here~~
}
  \item{D}{seasonal difference; use only for seasonal models 
%%     ~~Describe \code{D} here~~
}
  \item{Q}{SMA order; use only for seasonal models 
%%     ~~Describe \code{Q} here~~
}
  \item{S}{seasonal period; use only for seasonal models 
%%     ~~Describe \code{S} here~~
}
  \item{xreg}{Optionally, a vector or matrix of external regressors, which must have the same number of rows as xdata.
}
  \item{Model}{if TRUE (default), the model orders are printed on the diagnostic plot.
}
  \item{details}{if FALSE, turns off the diagnostic plot and the output from the nonlinear optimization routine, which is \code{optim}. The default is TRUE. 
%%     ~~Describe \code{details} here~~
}
  \item{tol}{controls the relative tolerance (reltol in \code{optim}) used to assess convergence. The default is \code{sqrt(.Machine$double.eps)}, the R default. 
%%     ~~Describe \code{tol} here~~
}
  \item{no.constant}{controls whether or not sarima includes a constant in the model. In particular, if there is no differencing (d = 0 and D = 0) you get the mean estimate. If there is differencing of order one (either d = 1 or D = 1, but not both), a constant term is included in the model. These two conditions may be overridden (i.e., no constant will be included in the model) by setting this to TRUE; e.g., \code{sarima(x,1,1,0,no.constant=TRUE)}. Otherwise, no constant or mean term is included in the model.  If regressors are included (via \code{xreg}), this is ignored.
}
}
\details{If your time series is in x and you want to fit an ARIMA(p,d,q) model to the data, the basic call is \code{sarima(x,p,d,q)}. The values p,d,q, must be specified as there is no default. The results are the parameter estimates, standard errors, AIC, AICc, BIC (as defined in Chapter 2) and diagnostics. To fit a seasonal ARIMA model, the basic call is \code{sarima(x,p,d,q,P,D,Q,S)}. For example, \code{sarima(x,2,1,0)} will fit an ARIMA(2,1,0) model to the series in x, and \code{sarima(x,2,1,0,0,1,1,12)} will fit a seasonal ARIMA\eqn{(2,1,0)*(0,1,1)_{12}} model to the series in x. 
         The difference between the information criteria given by \code{sarima()} and  \code{arima()} is that they essentially differ by a factor of the sample size. Precise details are explained in Chapter 2, footnote 2. 
}
\value{\item{fit }{the \code{arima} object}
\item{degrees_of_freedom}{Error degrees of freedom}
\item{ttable }{a little t-table with two-sided p-values}
\item{AIC }{value of the AIC}
\item{AICc }{value of the AICc}
\item{BIC }{value of the BIC}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
}
\examples{
sarima(log(AirPassengers),0,1,1,0,1,1,12)
(dog <- sarima(log(AirPassengers),0,1,1,0,1,1,12))
summary(dog$fit)  # fit has all the returned arima() values
plot(resid(dog$fit))  # plot the innovations (residuals) 
sarima(log(AirPassengers),0,1,1,0,1,1,12,details=FALSE)$BIC  # print model BIC only
}
\seealso{\code{\link{sarima.for}}}
\keyword{ ts }
