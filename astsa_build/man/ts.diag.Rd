\name{ts.diag}
\alias{ts.diag}
\title{
Diagnostic Plots for Time Series
}
\description{
Diagnostic plots of the residuals from a time series fit.
}
\usage{
ts.diag(resids, col = 1, fitdf = 0, nlag = 20, ...)
}
\arguments{
  \item{resids}{
residuals from a time series fit
}
  \item{col}{
color used in the plots (default is black)
}
  \item{fitdf}{
number of degrees of freedom to be subtracted for the portmanteau 
goodness-of-fit test
}
  \item{nlag}{
the maximum number of lags for a portmanteau goodness-of-fit test
}
  \item{\dots}{
additional graphical arguments
}
}
\details{
This is essentially the diagnostic plot from \link{\code{sarima}} that can be used for other types of model fitting aside from ARMA.  This is not needed for ARMA models because \link{\code{sarima}} includes this diagnostic of the residulas from the fit (unless it has been shut off).

The script may be used for a generic residual analysis or to check if a series is white noise. In this case, it may be necessary to specify \code{fitdf} to get the correct degrees of freedom such as in fitting a state space model.  
}
\value{
A graphic is produced showing a plot of the residuals, the sample ACF, a normal QQ plot, and and the p-values of a portmanteau test for all lags up to \code{nlag}.
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
\examples{

# fit state space model to global temps
u = ssm(gtemp_both, A=1, alpha=0, phi=1, sigw=.05, sigv=.15)

# get resids (obs - pred)
resids = gtemp_both - u$Xp

# check fit [the model is essentially an explosive ARMA(1,1)]
ts.diag(resids, fitdf=2, col=4, gg=TRUE)

}
\seealso{\code{\link{sarima}}
}
\keyword{ts}