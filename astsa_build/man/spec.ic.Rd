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
spec.ic(xdata, BIC=FALSE, order.max=NULL, main=NULL, plot=TRUE, detrend=TRUE, 
         lowess=FALSE, method=NULL, cex.main=NULL, xlab=NULL, ...)
}
\arguments{
  \item{xdata}{
a univariate time series.
}
  \item{BIC}{
if TRUE, fit is based on BIC. If FALSE (default), fit is based on AIC.
}
  \item{order.max}{ 
maximum order of model to fit. Defaults (if NULL) to the minimum of 100 
and 10\% of the number of observations. 
}
  \item{main}{
plot title. Defaults to name of series, method and chosen order.
}
  \item{plot}{
if TRUE (default) produces a graphic of the estimated AR spectrum.
}
  \item{detrend}{
if TRUE (default), detrends the data first. If FALSE, the series is demeaned.
}
  \item{lowess}{
if TRUE, detrends using lowess. Default is FALSE.
}

  \item{method}{method of estimation - a character string specifying the 
        method to fit the model chosen from the following:
       "yule-walker", "burg", "ols", "mle", "yw". Defaults to "yule-walker".
}
  \item{cex.main}{
magnification for main title; default is 1.
}
  \item{xlab}{label for frequency axis; if NULL (default), a totally awesome label is generated for your viewing pleasure.
}
  \item{\dots}{
additional graphical arguments.
}
}
\details{Uses \code{ar} to fit the best AR model based on pseudo AIC or BIC. 
Using \code{method='mle'} will be slow. The minimum centered AIC and BIC values and the 
spectral and frequency ordinates are returned silently.
}
\value{
\item{[[1]] }{Matrix with columns: ORDER, AIC, BIC}
\item{[[2]] }{Matrix with columns: freq, spec}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{
D.S. Stoffer 
}
\seealso{ \code{\link{ar}}, \code{\link{spec.ar}}}
\examples{
\dontrun{
# AIC
spec.ic(soi)  
spec.ic(sunspotz, method='burg', col=4)   

# BIC after detrending on log scale
dog <- spec.ic(soi, BIC=TRUE, detrend=TRUE, log='y')  

# plot AIC and BIC  (dog from previous example)
tsplot(dog[[1]][,1], dog[[1]][,2:3], col=2*1:2, type='o', pch=1:2, xlab='order',
        spag=TRUE, addLegend=TRUE)  
}
}
\keyword{ ts }