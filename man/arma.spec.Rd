\name{arma.spec}
\alias{arma.spec}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Spectral Density of an ARMA Model 
%%  ~~function to do ... ~~
}
\description{Gives the ARMA spectrum (on a log scale), tests for causality, invertibility, and
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
containing the model parameters. Use \code{log="no"} if you do not want the plot on
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
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
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
arma.spec(ar = c(1, -.9), ma = .8, log="no")
}
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(ar=0,ma=0,var.noise=1,n.freq=500,  ...)
%% { 
%%     # check causality
%%      ar.poly <- c(1, -ar)
%%      z.ar <- polyroot(ar.poly)
%%      if(any(abs(z.ar) <= 1)) cat("WARNING: Model Not Causal", "\n")  
%%     # check invertibility
%%      ma.poly <- c(1, ma)
%%      z.ma <- polyroot(ma.poly)
%%      if(any(abs(z.ma) <= 1)) cat("WARNING: Model Not Invertible", "\n")
%%      if(any(abs(z.ma) <= 1) || any(abs(z.ar) <= 1) ) stop("Try Again")
%%     #
%%     ar.order <- length(ar)
%%     ma.order <- length(ma) 
%%     # check (near) parameter redundancy [i.e. are any roots (approximately) equal]  
%%        for (i in 1:ar.order) {
%%        if ( (ar == 0 & ar.order == 1) || (ma == 0 & ma.order ==1) ) break
%%        if(any(abs(z.ar[i]-z.ma[1:ma.order]) < 1e-03)) {cat("WARNING: Parameter Redundancy", "\n"); break}
%%        }
%%     #
%%     freq <- seq.int(0, 0.5, length.out = n.freq)
%%             cs.ar <- outer(freq, 1:ar.order, function(x, y) cos(2 * 
%%                 pi * x * y)) \%*\% ar
%%             sn.ar <- outer(freq, 1:ar.order, function(x, y) sin(2 * 
%%                 pi * x * y)) \%*\% ar
%%             cs.ma <- outer(freq, 1:ma.order, function(x, y) cos(2 * 
%%                 pi * x * y)) \%*\% -ma
%%             sn.ma <- outer(freq, 1:ma.order, function(x, y) sin(2 * 
%%                 pi * x * y)) \%*\% -ma                      
%%     spec <- var.noise*((1 - cs.ma)^2 + sn.ma^2)/((1 - cs.ar)^2 + sn.ar^2)
%%     spg.out <- list(freq=freq, spec=spec)
%%     class(spg.out) <- "spec"
%%     plot(spg.out, ci=0, ...)
%%     return(invisible(spg.out))
%%   }
%%}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ts}
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
