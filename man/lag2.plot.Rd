\name{lag2.plot}
\alias{lag2.plot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Lag Plot - two time series
%%  ~~function to do ... ~~
}
\description{Produces a grid of scatterplots of one series versus another. The first named series is the one that gets lagged. 
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{series1}{first series (the one that gets lagged)
%%     ~~Describe \code{series1} here~~
}
  \item{series2}{second series
%%     ~~Describe \code{series2} here~~
}
  \item{max.lag}{maximum number of lags
%%     ~~Describe \code{max.lag} here~~
}
  \item{corr}{if TRUE, shows the cross-correlation value in a legend
%%     ~~Describe \code{corr} here~~
}
  \item{smooth}{if TRUE, adds a lowess fit to each scatterplot
%%     ~~Describe \code{smooth} here~~
}
}
%%\details{
%%%%  ~~ If necessary, more details than the description above ~~
%%}
%\value{
%%%  ~Describe the value returned
%%%  If it is a LIST, use
%%%  \item{comp1 }{Description of 'comp1'}
%%%  \item{comp2 }{Description of 'comp2'}
%%% ...
%}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
lag2.plot(soi, rec, 8)
}
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(series1,series2,max.lag=0,corr=TRUE,smooth=TRUE){ 
%%    name1=paste(deparse(substitute(series1)),"(t-",sep="")
%%    name2=paste(deparse(substitute(series2)),"(t)",sep="")
%%    series1=as.ts(series1)
%%    series2=as.ts(series2)
%%    max.lag=as.integer(max.lag)
%%    m1=max.lag+1
%%    prow=ceiling(sqrt(m1))
%%    pcol=ceiling(m1/prow)
%%    a=ccf(series1,series2,max.lag,plot=FALSE)$acf
%%    old.par <- par(no.readonly = TRUE)
%%    par(mfrow=c(prow,pcol), mar=c(2.5, 4, 2.5, 1), cex.main=1.1, font.main=1)
%%    for(h in 0:max.lag){                   
%%    plot(lag(series1,-h), series2, xy.labels=FALSE, main=paste(name1,h,")",sep=""), ylab=name2, xlab="") 
%%     if (smooth==TRUE) 
%%     lines(lowess(ts.intersect(lag(series1,-h),series2)[,1],
%%                  ts.intersect(lag(series1,-h),series2)[,2]), col="red")
%%     if (corr==TRUE)
%%     legend("topright", legend=round(a[m1-h], digits=2), text.col ="blue", bg="white", x.intersp=0)             
%%    on.exit(par(old.par))
%%    }
%% }
%%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ts }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line