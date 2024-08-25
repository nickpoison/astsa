\name{pre.white}
\alias{pre.white}
\title{Cross-Correlation Analysis With Automatic Prewhitening
}
\description{Does a cross-correlation analysis on two series after prewhitening the first series and filtering the second series accordingly.
}
\usage{
pre.white(series1, series2, diff = FALSE, max.lag = NULL, main = NULL, 
           order.max = NULL, plot = TRUE, ...)
}
\arguments{
 \item{series1, series2}{ univariate time series
}
  \item{diff}{ (logical or integer) should the series be differenced prior to the analysis and if more than first order, by how much 
}
  \item{max.lag}{ maximum lag for which to plot the CCF - if NULL, a suitable number is chosen (see details)
}
  \item{main}{ plot title - if NULL, uses series1 name appended by .w for whitened and series2 name appended by .f for filtered
}
  \item{order.max}{ maximum order of model to fit (see details)
}
  \item{plot}{ should the sample CCF be plotted
}
  \item{\dots}{ additional graphic arguments
}
}
\details{The first series is prewhitened by fitting a long AR based on AIC and the second series is filtered appropriately. Then a cross-correlation analysis is performed via \code{\link{ccf2}}. If differencing is specified, both series are differenced the same way prior to the prewhitening. The resulting series are returned invisibly.

The default is no differencing (FALSE). Differences of order 1 can be set be entering \code{diff = TRUE} or \code{diff = 1}. If it is necessary to use higher orders, then enter a positive integer (this is rare). 

The maximum lag (\code{max.lag}) in the CCF graphic defaults (if NULL) to the smaller of 50 and 20\% of the sample size. 

The maximum order (\code{order.max}) for fitting the AR via AIC defaults (if NULL) to the minimum of 30 and 15\% of the number of observations. 
}
\value{
Returns the sample CCF graphic using the prewhitened series unless \code{plot = FALSE}.  The prewhitened series are returned invisibly.
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
pre.white(cmort, part, diff=TRUE, col=4)
}
\keyword{ ts }
