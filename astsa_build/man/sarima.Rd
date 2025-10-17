\name{sarima}
\alias{sarima}
\title{Fit ARIMA Models
} 
\description{Fits ARIMA models (with diagnostics) in a short command.  It can also be used to perform regression with autocorrelated errors. 
}
\usage{
sarima(xdata, p, d, q, P = 0, D = 0, Q = 0, S = -1, 
       details = TRUE, xreg = NULL, Model = TRUE,
       fixed = NULL, tol = sqrt(.Machine$double.eps), 
       no.constant = FALSE, col, fitdf, ...)
}
\arguments{
  \item{xdata}{univariate time series
}
  \item{p}{AR order  
}
  \item{d}{difference order  
}
  \item{q}{MA order  
}
  \item{P}{SAR order; use only for seasonal models 
}
  \item{D}{seasonal difference; use only for seasonal models 
}
  \item{Q}{SMA order; use only for seasonal models 
}
  \item{S}{seasonal period; use only for seasonal models 
}
  \item{details}{if FALSE, turns off the diagnostic plot and the output from the nonlinear optimization routine, which is \code{optim}. The default is TRUE. 
}
  \item{xreg}{Optionally, a vector or matrix of external regressors, which must have the same number of rows as xdata.
}
  \item{Model}{if TRUE (default), the model orders are printed on the diagnostic plot.
}
  \item{fixed}{optional numeric vector of the same length as the total number of parameters. If supplied, only parameters corresponding to NA entries will be estimated. 
}  
  \item{tol}{controls the relative tolerance (reltol in \code{optim}) used to assess convergence. The default is \code{sqrt(.Machine$double.eps)}, the R default. 
}
  \item{no.constant}{controls whether or not sarima includes a constant in the model. In particular, if there is no differencing (d = 0 and D = 0) you get the mean estimate. If there is differencing of order one (either d = 1 or D = 1, but not both), a constant term is included in the model. These two conditions may be overridden (i.e., no constant will be included in the model) by setting this to TRUE; e.g., \code{sarima(x,1,1,0,no.constant=TRUE)}. Otherwise, no constant or mean term is included in the model.  If regressors are included (via \code{xreg}), this is ignored.
}
  \item{col}{ color of diagnostic plots; default is 1 (black)
}
  \item{fitdf}{ number of degrees of freedom to be subtracted for the Ljung-Box test if xdata is a series of residuals and all orders are zero (see details).  Does not have to be specified if it is zero (0).
}
  \item{...}{additional graphical arguments
}
}
\details{If your time series is in x and you want to fit an ARIMA(p,d,q) model to the data, the basic call is \code{sarima(x,p,d,q)}. As of version 2.3, the orders do not have to be specified if they are zero. For example, \code{sarima(x, p=1)} is the same as \code{sarima(x,1,0,0)}.

To fit a seasonal ARIMA model, the basic call is \code{sarima(x,p,d,q,P,D,Q,S)}. For example, \code{sarima(x, 2,1,0, 0,1,1,12)} will fit a seasonal ARIMA\eqn{(2,1,0) \times (0,1,1)_{12}} model to the series in x. The orders do not have to be specified if they are zero; e.g., \code{sarima(x, d=1,q=1, D=1,Q=1,S=4)} works.

The results are the parameter estimates, standard errors, AIC, AICc, BIC and diagnostics. The difference between the information criteria given by \code{sarima()} and  \code{arima()} is that they differ by a scaling factor of the effective sample size. 

The script may be used for a residual analysis by running it without specifying any orders. In this case, it may be necessary to specify \code{fitdf} to get the correct degrees of freedom such as in fitting a state space model.
 
}
\value{A t-table, the estimated noise variance, and AIC, AICc, BIC are printed. The following are returned invisibly as a list:
\item{fit }{[[1]] an object of class \code{Arima} with more information than you need}
\item{sigma2 }{[[2]] the estimate of the noise variance}
\item{degrees_of_freedom }{[[3]] error degrees of freedom}
\item{t.table }{[[4]] a little t-table with two-sided p-values}
\item{ICs }{[[5]] AIC  -  AICc  -  BIC} 
}

\section{Missing Data}{Yes it's ok if input as \code{NA} and the observations are vector or \code{ts} objects (meaning equally spaced).
}

\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.    
}
\source{This is an enhancement of \code{arima} from the \code{stats} package.
}
\examples{

# easy to use 
sarima(rec, 2,0,0)  # data, p, d, and q

# redux - minimal output
sarima(rec, p=2, details=FALSE)

# fun for the whole family
dog = sarima(log(AirPassengers), 0,1,1, 0,1,1,12, details=FALSE)
# dog[[1]] has most of the results ...
tsplot(resid(dog[[1]]))

# fixed parameters
x = sarima.sim( ar=c(0,-.9), n=200 ) + 50 
sarima(x, p=2, fixed=c(0,NA,NA))  # phi1 fixed, phi2 and mean free

# regression with autocorrelated errors  
sarima(log(cpg), p=1, xreg=time(cpg))

# missing data (color, gris-gris, and pch, added for fun)
sarima(ar1miss, p=1, col=4, gg=TRUE, pch=19)

}
\seealso{\code{\link{sarima.for}}, \code{\link{sarima.sim}} }
\keyword{ ts }
