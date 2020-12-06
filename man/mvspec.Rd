\name{mvspec}
\alias{mvspec}
\title{Univariate and Multivariate Spectral Estimation
}
\description{This is \code{spec.pgram} with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}.  The bandwidth calculation has been changed to the more practical definition given in the text. Can be used to replace \code{spec.pgram} for univariate series.
}
\usage{
mvspec(x, spans = NULL, kernel = NULL, taper = 0, pad = 0, 
         fast = TRUE, demean = FALSE, detrend = TRUE, 
         plot = TRUE, log='n', type = NULL, 
         na.action = na.fail, ...)
}
\arguments{
  \item{x }{univariate or multivariate time series (i.e., the p columns of x are time series)
}
  \item{spans }{specify smoothing; same as \code{spec.pgram}
}
  \item{kernel }{specify kernel; same as \code{spec.pgram} 
}
  \item{taper }{specify taper; same as \code{spec.pgram} with different default
}
  \item{pad }{specify padding; same as \code{spec.pgram}
}
  \item{fast }{specify use of FFT; same as \code{spec.pgram}
}
  \item{demean }{if TRUE, series is demeaned first; same as \code{spec.pgram} 
}
  \item{detrend }{if TRUE, series is detrended first; same as \code{spec.pgram} 
}
  \item{plot }{plot the estimate; same as \code{spec.pgram} 
}
  \item{log }{same as \code{spec.pgram} but default is \code{'no'}
}
  \item{type }{type of plot to be drawn, defaults to lines
}
  \item{na.action }{same as \code{spec.pgram}
}
  \item{\dots }{additional arguments; same as \code{spec.pgram}
}
}
\details{This is \code{spec.pgram} with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}. The default for the plot is NOT to plot on a log scale and the graphic will have a grid. The bandwidth calculation has been changed to the more practical definition given in the text, \eqn{(L_h/n.used)*frequency(x)}. Although meant to be used to easily obtain multivariate spectral estimates, this script can be used for univariate time series.  Note that the script does not taper by default (\code{taper=0}); this forces the user to do "conscious tapering".  
}
\value{An object of class "spec", which is a list containing at least the following components:

\item{fxx }{spectral matrix estimates; an array of dimensions \code{dim = c(p,p,nfreq)}}
\item{freq }{vector of frequencies at which the spectral density is estimated.}
\item{spec }{vector (for univariate series) or matrix (for multivariate series) of estimates of the spectral density at frequencies corresponding to freq.}
\item{details }{matrix with columns: frequency, period, spectral ordinate(s)}
\item{coh }{NULL for univariate series. For multivariate time series, a matrix containing the squared coherency between different series. Column i + (j - 1) * (j - 2)/2 of coh contains the squared coherency between columns i and j of x, where i < j.}
\item{phase }{NULL for univariate series. For multivariate time series a matrix containing the cross-spectrum phase between different series. The format is the same as coh.}
\item{Lh }{Number of frequencies (approximate) used in the band, as defined in Chapter 4.}
\item{n.used }{Sample length used for the FFT}
\item{series }{The name of the time series.}
\item{snames }{For multivariate input, the names of the component series.}
\item{method }{The method used to calculate the spectrum.}

The results are returned invisibly if plot is true.
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}

\examples{
# real raw periodogram
mvspec(soi)
mvspec(soi, log='y')  # on a log scale

# smooth and some details printed
mvspec(soi, spans=c(7,7), taper=.5)$details[1:45,]

# multivariate example
ts.plot(mdeaths, fdeaths, col=1:2)   # an R data set, male/female monthly deaths ...
dog = mvspec(cbind(mdeaths,fdeaths), spans=c(3,3), taper=.1)
dog$fxx        # look a spectral matrix estimates
dog$bandwidth  # bandwidth with time unit = year
dog$df         # degrees of freedom
plot(dog, plot.type="coherency")  # plot of squared coherency
}
\keyword{ ts }
