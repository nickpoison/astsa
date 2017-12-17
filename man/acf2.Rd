\name{acf2}
\alias{acf2}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Plot and print ACF and PACF of a time series
}
\description{
Produces a simultaneous plot (and a printout) of the sample ACF and PACF on the same scale. The zero lag value of the ACF is removed.
}
\usage{
acf2(series, max.lag=NULL, plot=TRUE, main=NULL, na.action = na.pass, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{series}{The data.  Does not have to be a time series object.
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}. If the series is seasonal, this will be at least 4 seasons by default.  
}
  \item{plot}{If FALSE, no graph is produced but the values are still printed.
}
  \item{main}{Title of graphic; defaults to name of series.
}
 \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{...}{ Additional arguments passed to \code{acf} }
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{\item{ACF}{The sample ACF}
\item{PACF}{The sample PACF}
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\details{This is basically a wrapper for \code{acf()} provided in \code{tseries}.  The error bounds are approximate white noise bounds, \eqn{0 \pm 2/\sqrt{n}}; no other option is given.    
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{
D.S. Stoffer 
}
%\note{
%This is bacisally a front end for \code{acf()} and \code{pacf()} provided in \code{tseries}.
%}
%% ~Make other sections like Warning with \section{Warning }{....} ~
%%\seealso{\code{\link{acf1}}
%% ~~objects to See Also as \code{\link{help}}, ~~~}
\examples{
acf2(rnorm(100))
acf2(rnorm(100), 25, main='')  # no title
acf2(rnorm(100), plot=FALSE)[,'ACF']  # print only ACF
}
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(series,max.lag=NULL){
%%   num=length(series)
%%   if (num > 49 & is.null(max.lag)) max.lag=ceiling(10+sqrt(num))
%%   if (num < 50 & is.null(max.lag))  max.lag=floor(5*log10(num))
%%   if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
%%   ACF=acf(series, max.lag, plot=FALSE)$acf[-1]
%%   PACF=pacf(series, max.lag, plot=FALSE)$acf
%%   LAG=1:max.lag/frequency(series)
%%   minA=min(ACF)
%%   minP=min(PACF)
%%   U=2/sqrt(num)
%%   L=-U
%%   minu=min(minA,minP,L)-.01
%%   old.par <- par(no.readonly = TRUE)
%%   par(mfrow=c(2,1), mar = c(3,3,2,0.8),
%%     oma = c(1,1.2,1,1), mgp = c(1.5,0.6,0))
%%   plot(LAG, ACF, type="h",ylim=c(minu,1), 
%%     main=paste("Series: ",deparse(substitute(series))))
%%     abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
%%   plot(LAG, PACF, type="h",ylim=c(minu,1))
%%     abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
%%   on.exit(par(old.par))  
%%   ACF<-round(ACF,2); PACF<-round(PACF,2)    
%%   return(cbind(ACF, PACF)) 
%%   }
%}
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ts}
