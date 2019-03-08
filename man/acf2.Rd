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
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
%% ~put references to the literature/web site here ~
}
\author{
D.S. Stoffer 
}
\examples{
acf2(rnorm(100))
acf2(rnorm(100), 25, main='')  # no title
acf2(rnorm(100), plot=FALSE)[,'ACF']  # print only ACF
}
\keyword{ts}
