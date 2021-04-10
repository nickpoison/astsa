\name{specenv}
\alias{specenv}
\title{
Spectral Envelope
}
\description{
Computes the spectral envelope of a categorical sequence.
}
\usage{
specenv(xdata, section = NULL, spans = NULL, significance = 1e-04, 
         plot = TRUE, ylim = NULL, ...)
}
\arguments{
  \item{xdata}{
a matrix with rows that are indicators of the categories represented by the columns,
possibly a sequence converted using \code{\link{dna2vector}} 
}
  \item{section}{
of the form \code{start:end} where \code{start} < \code{end} are non-negative integers;  
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
  \item{\dots}{
other graphical parameters.
}
}
\details{
Calculates the spectral envelope defined in \kbd{https://www.stat.pitt.edu/stoffer/dss_files/spenv.pdf} and summarized in \kbd{https://projecteuclid.org/journals/statistical-science/volume-15/issue-3/The-spectral-envelope-and-its-applications/10.1214/ss/1009212816.full}.  The concept is also discussed in Chapter 7 of Time Series Analysis and Its Applications: With R Examples: \kbd{https://www.stat.pitt.edu/stoffer/tsa4/}.

The input \code{xdata} must be a matrix of indicators. Otherwise, the data should be preprocessed using \code{\link{dna2vector}}.
}
\value{
By default, will produce a graph of the spectral envelope and an approximate significance threshold.
A matrix containing: frequency, spectral envelope ordinates, and scaling of the categories in the order of the categories in the alphabet is returned invisibly.
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
data  = bnrf1ebv
xdata = dna2vector(data)
u = specenv(xdata, section=1:1000, spans=c(7,7))
head(u)  # scalings are for A, C, G, and last one T=0 always
}
\keyword{ ts }

