\name{mvspec}
\alias{mvspec}
\title{Univariate and Multivariate Spectral Estimation
}
\description{This is \code{spec.pgram} with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}.  The bandwidth calculation has been changed to the more practical definition given in the text and this can be used to replace \code{spec.pgram}.
} 
\usage{
mvspec(x, spans = NULL, kernel = NULL, taper = 0, pad = 0, fast = TRUE, 
        demean = FALSE, detrend = TRUE, lowess = FALSE, log = 'n', plot = TRUE, 
        gg = FALSE, type = NULL, na.action = na.fail, nxm = 2, nym = 1, 
        main = NULL, xlab=NULL, cex.main=NULL, ci.col=4,  plot.type, ...) 
}
\arguments{
  \item{x }{univariate or multivariate time series (i.e., the p columns of x are time series)
}
  \item{spans }{vector of odd integers giving the widths of modified Daniell smoothers to be used to smooth the periodogram
}
  \item{kernel }{alternatively, a kernel smoother of class \code{tskernel} 
}
  \item{taper }{specifies the proportion of data to taper using a split cosine bell taper (.5 specifies a full taper)
}
  \item{pad }{proportion of data to pad (zeros are added to the end of the series to increase its length by the proportion pad)
}
  \item{fast }{logical; if TRUE, pad the series to a highly composite length
}
  \item{demean }{if TRUE, series is demeaned first 
}
  \item{detrend }{if TRUE, series is detrended first (unless demean is TRUE)
}
  \item{lowess }{if TRUE and detrend TRUE (and demean FALSE), series is detrended using lowess first 
}
  \item{log }{if \code{log='y'}, spectra plotted on a log scale; otherwise a log scale is not used
}
  \item{plot }{plot the estimated spectra 
}
  \item{gg }{if TRUE, will produce a gris-gris plot (gray graphic interior with white grid lines); the default is FALSE. The grammar of astsa is voodoo
}
  \item{type }{type of plot to be drawn, defaults to lines (see \code{par})
}
  \item{na.action }{how to handle missing values
}
  \item{nxm, nym }{
the number of minor tick mark divisions on x-axis, y-axis; the default is one minor tick on the x-axis and none on the y-axis
}
 \item{main }{title of the graphics; if NULL (default), a totally awesome title is generated dude, but if NA there will be no gnarly title and the top margin will be used for the plot
}
 \item{xlab }{label for frequency axis; if NULL (default), a totally awesome label is generated for your viewing pleasure
}
 \item{cex.main }{
magnification for main title; default is 1.
}
 \item{ci.col }{
color of the confidence interval if one is drawn.
}
 \item{plot.type }{ plot type for multivariate time series; leave blank or specify 'marginal' if a marginal plot of the spectra is desired, or set \code{plot.type='coh'} for coherency plot(s), or \code{plot.type='phase'} for phase plot(s).
.  
}
 \item{\dots }{additional graphical arguments.
}
}
\details{This is built off of \code{spec.pgram} from the stats package with a few changes in the defaults and written so you can easily extract the estimate of the multivariate spectral matrix as \code{fxx}. 

The default for the plot is NOT to plot on a log scale and the graphic will have a grid. 

The bandwidth calculation has been changed to the more practical definition given in the text, \eqn{(L_h/n.used)*frequency(x)}.  Also, the bandwidth is not displayed in the graphic, but is returned. 

Although initially meant to be used to easily obtain multivariate (mv) spectral (spec) estimates, this script can be used for univariate time series as a replacement for \code{spec.pgram}.

Note that the script does not taper by default (\code{taper=0}); this forces the user to do "conscious tapering".  

In the multivariate case (more than 2 series), if "coherency" or "phase" plots are desired, the result is a grid of plots. There is a "scale" factor that can be set to prevent the labels from getting too small if there are many series.  The default is \code{scale=1}, and to expand the labels by 10\% for example, set \code{scale=1.1}. 


}
\value{All results are returned invisibly.  

If \code{plot} is TRUE and smoothing is used, the bandwidth, degrees of freedom, and taper amount are printed. 

An object of class "spec", which is a list containing at least the following components:

\item{fxx }{spectral matrix estimates; an array of dimensions \code{dim = c(p,p,nfreq)}.}
\item{freq }{vector of frequencies at which the spectral density is estimated.}
\item{spec }{vector (for univariate series) or matrix (for multivariate series) of estimates of the spectral density at frequencies corresponding to freq.}
\item{details }{matrix with columns: frequency, period, spectral ordinate(s)}
\item{coh }{NULL for univariate series. For multivariate time series, a matrix containing the squared coherency between different series. Column i + (j - 1) * (j - 2)/2 of coh contains the squared coherency between columns i and j of x, where i < j.}
\item{phase }{NULL for univariate series. For multivariate time series a matrix containing the cross-spectrum phase between different series. The format is the same as coh.}
\item{Lh }{Number of frequencies (approximate) used in the band.}
\item{n.used }{Sample length used for the FFT}
\item{df }{Degrees of freedom (may be approximate) associated with the spectral estimate.}
\item{bandwidth }{Bandwidth (may be approximate) associated with the spectral estimate.}
\item{method }{The method used to calculate the spectrum.}


}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\examples{
# real raw periodogram
mvspec(soi)
mvspec(soi, log='y')  # on a log scale

# smooth and some details printed
mvspec(soi, spans=c(7,7), taper=.5)$details[1:45,]

# bivariate example
deth = cbind(mdeaths, fdeaths)    # two R data sets, male/female monthly deaths ...
tsplot(deth, type='b', col=c(4,6), spaghetti=TRUE, pch=c('M','F'))
dog = mvspec(deth, spans=c(3,3), taper=.1)
dog$fxx[,,1:5]  # look at a few spectral matrix estimates
dog$bandwidth   # bandwidth with time unit = year
dog$df          # degrees of freedom
mvspec(deth, spans=c(3,3), taper=.1, plot.type='coh')  # coherence

# multivariate example
mvspec(diff(log(econ5)), spans=c(5,5), col=5, lwd=2, ci=NA, gg=TRUE, plot.type='coh')   
}
\keyword{ ts }
