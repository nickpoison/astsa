\name{SigExtract}
\alias{SigExtract}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Signal Extraction And Optimal Filtering
%%  ~~function to do ... ~~
}
\description{Performs signal extraction and optimal filtering as discussed in Chapter 4.

%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SigExtract(series, L = c(3, 3), M = 50, max.freq = 0.05)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{series}{univariate time series to be filtered
%%     ~~Describe \code{series} here~~
}
  \item{L}{degree of smoothing (may be a vector); see \code{spans} in \code{spec.pgram}
  for more details 
%%     ~~Describe \code{L} here~~
}
  \item{M}{number of terms used in the lagged regression approximation
%%     ~~Describe \code{M} here~~
}
  \item{max.freq}{truncation frequency, which must be larger than 1/M.
%%     ~~Describe \code{max.freq} here~~
}
}
\details{The basic function of the script, and the default setting, is to remove frequencies above 1/20 (and, in particular, the seasonal frequency of 1 cycle every 12 time points). The  sampling frequency of the time series is set to unity prior to the analysis. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{Returns plots of (1) the original and filtered series, (2) the estiamted spectra of each series, (3)  the filter coefficients and the desired and attained frequency response function.  The filtered series is returned invisibly.
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
\note{The script is based on code that was contributed by Professor Doug Wiens,
Department of Mathematical and Statistical Sciences, University of Alberta.
%%  ~~further notes~~
}
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 