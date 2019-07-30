\name{LagReg}
\alias{LagReg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Lagged Regression
%%  ~~function to do ... ~~
}
\description{Performs lagged regression as discussed in Chapter 4.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
LagReg(input, output, L = c(3, 3), M = 40, threshold = 0, 
        inverse = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{input}{input series
%%     ~~Describe \code{input} here~~
}
  \item{output}{output series
%%     ~~Describe \code{output} here~~
}
  \item{L}{degree of smoothing;  see \code{spans} in the help file for \code{spec.pgram}.
%%     ~~Describe \code{L} here~~
}
  \item{M}{must be even; number of terms used in the lagged regression
%%     ~~Describe \code{M} here~~
}
  \item{threshold}{the cut-off used to set small (in absolute value) regression coeffcients equal to zero
%%     ~~Describe \code{threshold} here~~
}
  \item{inverse}{if TRUE, will fit a forward-lagged regression
%%     ~~Describe \code{inverse} here~~
}
}
\details{For a bivariate series, \code{input} is the input series and \code{output} is the output series. The degree of smoothing for the spectral estimate is given by L; see \code{spans} in the help file for \code{spec.pgram}. The number of terms used in the lagged regression approximation is given by M, which must be even. The threshold value is the cut-off used to set small (in absolute value) regression coeffcients equal to zero (it is easiest to run LagReg twice, once with the default threshold of zero, and then again after inspecting the resulting coeffcients and the corresponding values of the CCF). Setting inverse=TRUE will fit a forward-lagged regression; the default is to run a backward-lagged regression. The script is based on code that was contributed by Professor Doug Wiens, Department of Mathematical and Statistical Sciences, University of Alberta. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{Graphs of the estimated impulse response function, the CCF, and the output with the predicted values superimposed.
%%  ~Describe the value returned
%%  If it is a LIST, use
  \item{beta}{Estimated coefficients}
  \item{fit}{The output series, the fitted values, and the residuals}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%%\note{
%%%%  ~~further notes~~
%%}
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 