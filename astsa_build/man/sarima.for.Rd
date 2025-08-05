\name{sarima.for}
\alias{sarima.for}
\title{ARIMA Forecasting
} 
\description{ARIMA forecasting.
}
\usage{
sarima.for(xdata, n.ahead, p, d, q, P=0, D=0, Q=0, S=-1, tol = sqrt(.Machine$double.eps),
         no.constant = FALSE, plot = TRUE, plot.all = FALSE,  ylab = NULL,
         xreg = NULL, newxreg = NULL, fixed = NULL, pcol = 2, ...)
}
\arguments{
  \item{xdata}{univariate time series
}
  \item{n.ahead}{forecast horizon (number of periods)
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
  \item{tol}{controls the relative tolerance (reltol) used to assess convergence. The default is \code{sqrt(.Machine$double.eps)}, the R default.
}
  \item{no.constant}{controls whether or not a constant is included in the model. If \code{no.constant=TRUE}, no constant is included in the model.
   See  \code{\link{sarima}} for more details.
}
  \item{plot}{if TRUE (default) the data (or some of it) and the forecasts and bounds are plotted
}  
  \item{plot.all}{if TRUE, all the data are plotted in the graphic; otherwise, only the last 100 observations are plotted in the graphic.
}
  \item{ylab}{if NULL (default), the y-axis label is the name of the series.
}
  \item{xreg}{Optionally, a vector or matrix of external regressors, which must have the same number of rows as the series. If this is used, \code{newxreg} MUST be specified.
}
  \item{newxreg}{New values of \code{xreg} to be used for prediction. Must have at least \code{n.ahead} rows.
}
  \item{fixed}{optional numeric vector of the same length as the total number of parameters. If supplied, only parameters corresponding to NA entries will be estimated. 
}
  \item{pcol}{color of the predictions in the graphic.
}
  \item{...}{additional graphical arguments
}
}
\details{For example, \code{sarima.for(x, 5, 1,0,1)} or \code{sarima.for(x, 5, p=1, q=1)}
will forecast five time points ahead for an ARMA(1,1) fit to x. The output prints the forecasts and the standard errors of the forecasts, and supplies a graphic of the forecast with +/- 1 and 2 prediction error bounds.
}
\value{\item{pred }{the forecasts}
      \item{se }{the prediction (standard) errors}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}

\note{Missing Data: Yes it's ok if input as \code{NA} and the observations are vector or \code{ts} objects (meaning equally spaced).
}

\seealso{\code{\link{sarima}}}
\examples{

sarima.for(gtemp_both, 6, d=1, q=1, col=6, pcol=4, gg=TRUE)

# with regressors 
nummy   = length(soi)
n.ahead = 24 
nureg   = time(soi)[nummy] + seq(1,n.ahead)/12
sarima.for(soi,n.ahead,2,0,0,2,0,0,12, xreg=time(soi), newxreg=nureg) 

# missing data
sarima.for(ar1miss, n.ahead=5, p=1)
}
\keyword{ ts }
