\name{arma.spec}
\alias{arma.spec}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Spectral Density of an ARMA Model 
%%  ~~function to do ... ~~
}
\description{Gives the ARMA spectrum, tests for causality, invertibility, and
common zeros.  
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
arma.spec(ar = 0, ma = 0, var.noise = 1, n.freq = 500, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ar}{vector of AR parameters
%%     ~~Describe \code{ar} here~~
}
  \item{ma}{vector of MA parameters
%%     ~~Describe \code{ma} here~~
}
  \item{var.noise}{variance of the noise
%%     ~~Describe \code{var.noise} here~~
}
  \item{n.freq}{number of frequencies
%%     ~~Describe \code{n.freq} here~~
}
  \item{\dots}{additional arguments 
%%     ~~Describe \code{\dots} here~~
}
}
\details{The basic call is \code{arma.spec(ar, ma)} where \code{ar} and \code{ma} are vectors
containing the model parameters. Use \code{log="yes"} if you want the plot on
a log scale. If the model is not causal or invertible an error message is given. If
there are common zeros, a spectrum will be displayed and a warning will be given;
e.g., \code{arma.spec(ar= .9, ma= -.9)} will yield a warning and the plot will be the
spectrum of white noise. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{ \item{freq }{frequencies - returned invisibly}
 \item{spec }{ spectral ordinates - returned invisibly }
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%\note{In \code{tsa3}, this is called \code{spec.arma}.
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
\examples{
arma.spec(ar = c(1, -.9), ma = .8)
}
\keyword{ts}

