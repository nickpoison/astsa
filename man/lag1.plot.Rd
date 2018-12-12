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
lag1.plot(series, max.lag = 1, corr = TRUE, smooth = TRUE, col = gray(.1))
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
  \item{col}{color of points; default is \code{gray(.1)}
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
lag1.plot(soi, 9, col=4)
}
\keyword{ ts }

