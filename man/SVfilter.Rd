\name{SVfilter}
\alias{SVfilter}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Switching Filter (for Stochastic Volatility Models)
%%  ~~function to do ... ~~
}
\description{Performs a special case switching filter when the observational noise is a certain mixture of normals. Used to fit a stochastic volatility model. 
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SVfilter(num, y, phi0, phi1, sQ, alpha, sR0, mu1, sR1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{time series of returns
%%     ~~Describe \code{y} here~~
}
  \item{phi0}{state constant
%%     ~~Describe \code{phi0} here~~
}
  \item{phi1}{state transition parameter
%%     ~~Describe \code{phi1} here~~
}
  \item{sQ}{state standard deviation
%%     ~~Describe \code{sQ} here~~
}
  \item{alpha}{observation constant
%%     ~~Describe \code{alpha} here~~
}
  \item{sR0}{observation error standard deviation for mixture component zero
%%     ~~Describe \code{sR0} here~~
}
  \item{mu1}{observation error mean for mixture component one
%%     ~~Describe \code{mu1} here~~
}
  \item{sR1}{observation error standard deviation for mixture component one
%%     ~~Describe \code{sR1} here~~
}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
\item{xp }{one-step-ahead prediction of the volatility}
\item{Pp }{mean square prediction error of the volatility}
\item{like }{the negative of the log likelihood at the given parameter values}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
\keyword{ ts }
