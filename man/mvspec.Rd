\name{mvspec}
\alias{mvspec}
%- Also NEED an '\alias' specify EACH other topic documented here.
\title{Univariate and Multivariate Spectral Estimation
%%  ~~function to do ... ~~
}
\description{This is \code{spec.pgram} with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}.  The bandwidth calculation has been changed to the more practical definition given in the text. Can be used to replace \code{spec.pgram} for univariate series.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
mvspec(x, spans = NULL, kernel = NULL, taper = 0, pad = 0, 
         fast = TRUE, demean = FALSE, detrend = TRUE, 
         plot = TRUE, na.action = na.fail, ...)
}
%- maybe also 'usage' specify other objects documented here.
\arguments{
  \item{x }{univariate or multivariate time series (i.e., the p columns of x are time series)
%%     ~~Describe \code{x} here~~
}
  \item{spans }{specify smoothing; same as \code{spec.pgram}
%%     ~~Describe \code{spans} here~~
}
  \item{kernel }{specify kernel; same as \code{spec.pgram} 
%%     ~~Describe \code{kernel} here~~
}
  \item{taper }{specify taper; same as \code{spec.pgram} with different default
%%     ~~Describe \code{taper} here~~
}
  \item{pad }{specify padding; same as \code{spec.pgram}
%%     ~~Describe \code{pad} here~~
}
  \item{fast }{specify use of FFT; same as \code{spec.pgram}
%%     ~~Describe \code{fast} here~~
}
  \item{demean }{if TRUE, series is demeaned first; same as \code{spec.pgram} 
%%     ~~Describe \code{demean} here~~
}
  \item{detrend }{if TRUE, series is detrended first; same as \code{spec.pgram} 
%%     ~~Describe \code{detrend} here~~
}
  \item{plot }{plot the estimate; same as \code{spec.pgram} 
%%     ~~Describe \code{plot} here~~
}
  \item{na.action }{same as \code{spec.pgram}
%%     ~~Describe \code{na.action} here~~
}
  \item{\dots }{additional arguments; same as \code{spec.pgram}
%%     ~~Describe \code{\dots} here~~
}
}
\details{This is \code{spec.pgram} with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}.  The bandwidth calculation has been changed to the more practical definition given in the text, \eqn{(L_h/n.used)*frequency(x)}. Although meant to be used to easily obtain multivariate spectral estimates, this script can be used for univariate time series.  Note that the script does not taper by default (\code{taper=0}); this forces the user to do "conscious tapering".  
%%  ~~ If necessary, more details than the description above ~~
}
\value{An object of class "spec", which is a list containing at least the following components:

\item{fxx }{spectral matrix estimates; an array of dimensions \code{dim = c(p,p,nfreq)}}
\item{freq }{vector of frequencies at which the spectral density is estimated.}
\item{spec }{vector (for univariate series) or matrix (for multivariate series) of estimates of the spectral density at frequencies corresponding to freq.}
\item{coh }{NULL for univariate series. For multivariate time series, a matrix containing the squared coherency between different series. Column i + (j - 1) * (j - 2)/2 of coh contains the squared coherency between columns i and j of x, where i < j.}
\item{phase }{NULL for univariate series. For multivariate time series a matrix containing the cross-spectrum phase between different series. The format is the same as coh.}
\item{Lh }{Number of frequencies (approximate) used in the band, as defined in Chapter 4.}
\item{n.used }{Sample length used for the FFT}
\item{series }{The name of the time series.}
\item{snames }{For multivariate input, the names of the component series.}
\item{method }{The method used to calculate the spectrum.}

The results are returned invisibly if plot is true.
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
%\author{
%%  ~~who you are~~
%}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~
%
%\seealso{
% \code{\link{stats::spec.pgram}}
%}
\examples{
# univariate example
plot(co2)   # co2 is an R data set
mvspec(co2, spans=c(5,5), taper=.5)

# multivariate example
ts.plot(mdeaths, fdeaths, col=1:2)   # an R data set, male/female monthly deaths ...
dog = mvspec(cbind(mdeaths,fdeaths), spans=c(3,3), taper=.1)
dog$fxx        # look a spectral matrix estimates
dog$bandwidth  # bandwidth with time unit = year
dog$bandwidth/frequency(mdeaths)  # ... with time unit = month
plot(dog, plot.type="coherency")  # plot of squared coherency
}
\keyword{ ts }
%%%  %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%%%  