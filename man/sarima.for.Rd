\name{sarima.for}
\alias{sarima.for}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ARIMA Forecasting
%%  ~~function to do ... ~~
}
\description{ARIMA forecasting - this is a wrapper for R's \code{predict.Arima}.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sarima.for(xdata, n.ahead, p, d, q, P = 0, D = 0, Q = 0, S = -1, 
            tol = sqrt(.Machine$double.eps), no.constant = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xdata}{univariate time series
%%     ~~Describe \code{xdata} here~~
}
  \item{n.ahead}{forecast horizon (number of periods)
%%     ~~Describe \code{n.ahead} here~~
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
  \item{tol}{controls the relative tolerance (reltol) used to assess convergence. The default is \code{sqrt(.Machine$double.eps)}, the R default.
%%     ~~Describe \code{tol} here~~
}
  \item{no.constant}{controls whether or not a constant is included in the model. If \code{no.constant=TRUE}, no constant is included in the model.
   See  \code{\link{sarima}} for more details.
%%     ~~Describe \code{no.constant} here~~
}
}
\details{For example, \code{sarima.for(x,5,1,0,1)} will forecast five time points ahead for an ARMA(1,1) fit to x. The output prints the forecasts and the standard errors of the forecasts, and supplies a graphic of the forecast with +/- 2 prediction error bounds.
%%  ~~ If necessary, more details than the description above ~~
}
\value{\item{pred }{the forecasts}
      \item{se }{the prediction (standard) errors}
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
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
\seealso{\code{\link{sarima}}}
%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
sarima.for(log(AirPassengers),12,0,1,1,0,1,1,12)  
}
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(xdata,n.ahead,p,d,q,P=0,D=0,Q=0,S=-1,tol=sqrt(.Machine$double.eps),no.constant=FALSE){ 
%%   xname=deparse(substitute(xdata))
%%   xdata=as.ts(xdata) 
%%   n=length(xdata)
%%   constant=1:n
%%   xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL
%%   if (d==0 & D==0) {
%%     fitit=arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
%%             xreg=xmean,include.mean=FALSE, optim.control=list(reltol=tol));
%%     nureg=matrix(1,n.ahead,1)        
%%   } else if (xor(d==1, D==1) & no.constant==FALSE) {
%%     fitit=arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
%%             xreg=constant,optim.control=list(reltol=tol));
%%     nureg=(n+1):(n+n.ahead)       
%%   } else { fitit=arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
%%             optim.control=list(reltol=tol));
%%           nureg=NULL   
%%   }     
%% #--
%%  fore=predict(fitit, n.ahead, newxreg=nureg)  
%% #-- graph:
%%   U = fore$pred + 2*fore$se
%%   L = fore$pred - 2*fore$se
%%    a=max(1,n-100)
%%   minx=min(xdata[a:n],L)
%%   maxx=max(xdata[a:n],U)
%%    t1=xy.coords(xdata, y = NULL)$x 
%%    if(length(t1)<101) strt=t1[1] else strt=t1[length(t1)-100]
%%    t2=xy.coords(fore$pred, y = NULL)$x 
%%    endd=t2[length(t2)]
%%    xllim=c(strt,endd)
%%   ts.plot(xdata,fore$pred,col=1:2, type="o", xlim=xllim, ylim=c(minx,maxx), ylab=xname) 
%%   lines(fore$pred, col="red", type="p")
%%   lines(U, col="blue", lty="dashed")
%%   lines(L, col="blue", lty="dashed") 
%% #
%%   return(fore)
%%   }
%%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ts }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
