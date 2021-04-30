\name{specenv}
\alias{specenv}
\title{
Spectral Envelope
}
\description{
Computes the spectral envelope of categorical-valued or real-valued time series.
}
\usage{
specenv(xdata, section = NULL, spans = NULL, significance = 1e-04, 
         plot = TRUE, ylim = NULL, real = FALSE, ...)
}
\arguments{
  \item{xdata}{For categorical-valued sequences, a matrix with rows that are indicators 
of the categories represented by the columns, possibly a sequence converted using 
\code{\link{dna2vector}}.  For real-valued sequences, a matrix with at least two 
rows that are various transformations of the data. 
}
  \item{section}{
of the form \code{start:end} where \code{start < end} are non-negative integers;  
specifies the section used in the analysis - default is the entire sequence.
}
  \item{spans}{
specify smoothing used in \code{mvspec} 
}
  \item{significance}{
significance threshold exhibited in plot - default is .0001; set to NA to cancel
}
  \item{plot}{
if TRUE (default) a graphic of the spectral envelope is produced
}
  \item{ylim}{
limits of the spectral envelope axis; if NULL (default), a suitable range is calculated.
}
  \item{real}{ FALSE (default) for categorical-valued sequences and TRUE for
real-valued sequences.  
}
  \item{\dots}{
other graphical parameters.
}
}
\details{
Calculates the spectral envelope for categorical-valued series as discussed in \kbd{https://www.stat.pitt.edu/stoffer/dss_files/spenv.pdf} and summarized in \kbd{https://doi.org/10.1214/ss/1009212816}.   Alternately, calculates the spectral envelope for real-valued series as discussed in \kbd{https://doi.org/10.1016/S0378-3758(96)00044-4}.

These concepts are also presented (with examples) in Section 7.9 (Chapter 7) of  Time Series Analysis and Its Applications: With R Examples: \kbd{https://www.stat.pitt.edu/stoffer/tsa4/}.

For categorical-valued series, the input  \code{xdata} must be a matrix of indicators which is perhaps a sequence preprocessed using \code{\link{dna2vector}}.

For real-valued series, the input \code{xdata} should be a matrix whose columns are various transformations of the univariate series.
}
\value{
By default, will produce a graph of the spectral envelope and an approximate significance threshold.
A matrix containing: frequency, spectral envelope ordinates, and (1) the scalings of the categories in the order of the categories in the alphabet or (2) the coefficients of the transformations, is returned invisibly.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{
D.S. Stoffer
}
\seealso{
\code{\link{dna2vector}}
}
\examples{
# a DNA sequence
data  = bnrf1ebv
xdata = dna2vector(data)
u = specenv(xdata, section=1:1000, spans=c(7,7))
head(u)  # scalings are for A, C, G, and last one T=0 always

# a real-valued series (nyse returns)
x = astsa::nyse    
xdata = cbind(x, abs(x), x^2)
u = specenv(xdata, real=TRUE,  spans=c(3,3))
# plot optimal transform at freq = .001
beta = u[2, 3:5]
b = beta/beta[2]  # makes abs(x) coef=1
gopt = function(x) { b[1]*x+b[2]*abs(x)+b[3]*x^2 }
curve(gopt, -.2, .2, col=4, lwd=2, panel.first=Grid())
g2 = function(x) { b[2]*abs(x) } # corresponding to |x|
curve(g2, -.2,.2, add=TRUE, col=6)
}
\keyword{ ts }

