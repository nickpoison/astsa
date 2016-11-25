\name{lag1.plot}
\alias{lag1.plot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Lag Plot - one time series
%%  ~~function to do ... ~~
}
\description{Produces a grid of scatterplots of a series versus lagged values of the series.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
lag1.plot(series, max.lag = 1, corr = TRUE, smooth = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{series}{the data
%%     ~~Describe \code{series} here~~
}
  \item{max.lag}{maximum lag
%%     ~~Describe \code{max.lag} here~~
}
  \item{corr}{if TRUE, shows the autocorrelation value in a legend
%%     ~~Describe \code{corr} here~~
}
  \item{smooth}{if TRUE, adds a lowess fit to each scatterplot
%%     ~~Describe \code{smooth} here~~
}
}
%\details{
%%%  ~~ If necessary, more details than the description above ~~
%}
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
lag1.plot(soi, 9)
}
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(series,max.lag=1,corr=TRUE,smooth=TRUE){ 
%%    name1=paste(deparse(substitute(series)),"(t-",sep="")
%%    name2=paste(deparse(substitute(series)),"(t)",sep="")
%%    data1=as.ts(series)
%%    max.lag=as.integer(max.lag)
%%    prow=ceiling(sqrt(max.lag))
%%    pcol=ceiling(max.lag/prow)
%%    a=acf(series,max.lag,plot=FALSE)$acf[-1]
%%    old.par <- par(no.readonly = TRUE)
%%    par(mfrow=c(prow,pcol), mar=c(2.5, 4, 2.5, 1), cex.main=1.1, font.main=1)
%%   for(h in 1:max.lag){                       
%%    plot(lag(series,-h), data1, xy.labels=FALSE, main=paste(name1,h,")",sep=""), ylab=name2, xlab="") 
%%     if (smooth==TRUE) 
%%     lines(lowess(ts.intersect(lag(series,-h),series)[,1],
%%                  ts.intersect(lag(series,-h),series)[,2]), col="red")
%%     if (corr==TRUE)
%%     legend("topright", legend=round(a[h], digits=2), text.col ="blue", bg="white", x.intersp=0)
%%    on.exit(par(old.par))
%%    }
%%   }
%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ts }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
