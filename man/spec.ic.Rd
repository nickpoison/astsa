\name{spec.ic}
\alias{spec.ic}
\title{
Estimate Spectral Density of a Time Series from AR Fit
}
\description{
Fits an AR model to data and computes (and by default plots) the spectral 
     density of the fitted model based on AIC (default) or BIC.
}
\usage{
spec.ic(data, BIC = FALSE, order.max = 30, main = NULL, plot = TRUE, 
         detrend = FALSE, ...)
}
\arguments{
  \item{data}{
a univariate time series.
}
  \item{BIC}{
if TRUE, fit is based on BIC. If FALSE (default), fit is based on AIC.
}
  \item{order.max}{
maximum order of models to fit. Defaults to 30.
}
  \item{main}{
title. Defaults to name of series, method and chosen order.
}
  \item{plot}{
if TRUE (default) produces a graphic of the estimated AR spectrum.
}
  \item{detrend}{
if TRUE, detrends the data first. Default is FALSE.
}
  \item{\dots}{
additional arguments.
}
}
\details{Uses \code{ar.yw} and \code{spec.ar} to fit the best AR model based on 
pseudo AIC or BIC (no likelihood is calculated); see \seealso{\code{\link{stats::ar}}}
for details. The selected model is fit using MLE and the resulting AR spectrum
is displayed.  The minimum centered AIC and BIC values and the spectral and 
frequency ordinates are return silently.
}
\value{
\item{[[1]] }{Matrix with columns: ORDER, AIC, BIC}
\item{[[2]] }{Matrix with columns: spec, freq}
}
\references{
\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
}
\author{
D.S. Stoffer 
}
\seealso{
\seealso{\code{\link{stats::ar}}}, \seealso{\code{\link{stats::spec.ar}}}
}
\examples{
# AIC
spec.ic(soi)  
spec.ic(sunspotz, gg=TRUE, col=4, lwd=2)   
# BIC after detrending on log scale
spec.ic(soi, BIC=TRUE, detrend=TRUE, log='y')  
# plot AIC and BIC without spectral estimate
tsplot(0:30, spec.ic(soi, plot=FALSE)[[1]][,2:3], type='o', xlab='order', nxm=5)  
}