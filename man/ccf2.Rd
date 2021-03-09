\name{ccf2}
\alias{ccf2}
\title{Cross Correlation
}
\description{
Produces a nice graphic of the sample CCF of two time series.  The actual CCF values are returned invisibly.
}
\usage{
ccf2(x, y, max.lag = NULL, main=NULL, ylab="CCF", na.action = na.pass, ... )
}
\arguments{
  \item{x, y}{univariate time series.
}
  \item{max.lag}{
maximum lag for which to calculate the CCF.
}
  \item{main}{
plot title - if NULL, uses x and y names.
}
\item{ylab}{
vertical axis label; default is 'CCF'.
}
  \item{na.action}{ how to handle missing values; default is \code{na.pass}
}
\item{...}{ additional arguments passed to \code{\link{tsplot}}
}
}
\details{
This will produce a graphic of the sample \code{corr[x(t+lag), y(t)]} from \code{-max.lag} to \code{max.lag}. Also, the (rounded to 3 digits) values of the CCF are returned invisibly.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{D.S. Stoffer
}
\examples{
( ccf2(soi, rec) )   # now you see it
ccf2(soi, rec)       # now you don't

# happy birthday mom
ccf2(soi, rec, col=rainbow(36, v=.8), lwd=4)
}
\keyword{ ts } 
