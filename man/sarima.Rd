\name{sarima}
\alias{sarima}
%- Also NEED an '\alias' for EACH other topic documented here.
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
  \item{p}{AR order
%%     ~~Describe \code{p} here~~
}
  \item{d}{difference order
%%     ~~Describe \code{d} here~~
}
  \item{q}{MA order
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
%%     ~~Describe \code{no.constant} here~~
}
}
\details{If your time series is in x and you want to fit an ARIMA(p,d,q) model to the data, the basic call is \code{sarima(x,p,d,q)}. The results are the parameter estimates, standard errors, AIC, AICc, BIC (as defined in Chapter 2) and diagnostics. To fit a seasonal ARIMA model, the basic call is \code{sarima(x,p,d,q,P,D,Q,S)}. For example, \code{sarima(x,2,1,0)} will fit an ARIMA(2,1,0) model to the series in x, and \code{sarima(x,2,1,0,0,1,1,12)} will fit a seasonal ARIMA\eqn{(2,1,0)*(0,1,1)_{12}} model to the series in x.  
%%  ~~ If necessary, more details than the description above ~~
}
\value{\item{fit }{the \code{arima} object}
\item{degrees_of_freedom}{Error degrees of freedom}
\item{ttable }{a little t-table with two-sided p-values}
\item{AIC }{value of the AIC}
\item{AICc }{value of the AICc}
\item{BIC }{value of the BIC}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
%\author{
%%  ~~who you are~~
%}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
sarima(log(AirPassengers),0,1,1,0,1,1,12)
(dog <- sarima(log(AirPassengers),0,1,1,0,1,1,12))
summary(dog$fit)  # fit has all the returned arima() values
plot(resid(dog$fit))  # plot the innovations (residuals) 
}
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(xdata,p,d,q,P=0,D=0,Q=0,S=-1,details=TRUE,tol=sqrt(.Machine$double.eps),no.constant=FALSE)
%% { 
%%   n = length(xdata)
%%   constant = 1:n   
%%   xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL 
%%   trc = ifelse(details==TRUE, 1, 0)
%%   if (d==0 & D==0) {	  
%%     fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
%%               xreg=xmean,include.mean=FALSE, optim.control=list(trace=trc,REPORT=1,reltol=tol))
%%   } else if (xor(d==1, D==1) & no.constant==FALSE) {
%%     fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
%%               xreg=constant,optim.control=list(trace=trc,REPORT=1,reltol=tol))
%%   } else fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
%%                      include.mean=!no.constant, optim.control=list(trace=trc,REPORT=1,reltol=tol))
%% #
%% #  replace tsdiag with a better version
%%     old.par <- par(no.readonly = TRUE)
%%     layout(matrix(c(1,2,4, 1,3,4), nc=2))
%%     rs <- fitit$residuals
%%     stdres <- rs/sqrt(fitit$sigma2)
%%     num <- sum(!is.na(rs))
%%      plot.ts(stdres,  main = "Standardized Residuals", ylab = "")
%%     alag <- 10+sqrt(num)
%%     ACF = acf(rs, alag, plot=FALSE, na.action = na.pass)$acf[-1] 
%%     LAG = 1:alag/frequency(xdata)
%%     L=2/sqrt(num)
%%      plot(LAG, ACF, type="h", ylim=c(min(ACF)-.1,min(1,max(ACF+.4))), main = "ACF of Residuals")
%%      abline(h=c(0,-L,L), lty=c(1,2,2), col=c(1,4,4))  
%%     qqnorm(stdres, main="Normal Q-Q Plot of Std Residuals"); qqline(stdres, col=4) 
%%     nlag <- ifelse(S<4, 20, 3*S)
%%     ppq <- p+q+P+Q
%%     pval <- numeric(nlag)
%%     for (i in (ppq+1):nlag) {u <- Box.test(rs, i, type = "Ljung-Box")$statistic
%%                              pval[i] <- pchisq(u, i-ppq, lower=FALSE)}            
%%      plot( (ppq+1):nlag, pval[(ppq+1):nlag], xlab = "lag", ylab = "p value", ylim = c(0, 
%%         1), main = "p values for Ljung-Box statistic")
%%      abline(h = 0.05, lty = 2, col = "blue")  
%%     on.exit(par(old.par))    
%% #  end new tsdiag
%% #
%%   k = length(fitit$coef)
%%   BIC = log(fitit$sigma2)+(k*log(n)/n)
%%   AICc = log(fitit$sigma2)+((n+k)/(n-k-2))
%%   AIC = log(fitit$sigma2)+((n+2*k)/n)
%%   innov<<-fitit$resid
%%   list(fit=fitit, AIC=AIC, AICc=AICc, BIC=BIC)
%%   }
%%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\seealso{\code{\link{sarima.for}}}
\keyword{ ts }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
