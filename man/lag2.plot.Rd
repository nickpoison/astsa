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
lag2.plot(series1, series2, max.lag = 0, corr = TRUE, smooth = TRUE, col = gray(.1))
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
  \item{col}{color of points; default is \code{gray(.1)}
}
  \item{...}{additional graphical arguments}   
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
\examples{
lag2.plot(soi, rec, 8)
}
\keyword{ ts }
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line