\name{acfm}
\alias{acfm}
\title{ACF and CCF for Multiple Time Series
}
\description{
Produces a grid of plots of the sample ACF (diagonal) and CCF (off-diagonal).
}
\usage{
acfm(series, max.lag = NULL,  na.action = na.pass, ylim = NULL,
      acf.highlight = TRUE, ...)
}
\arguments{
  \item{series}{Multiple time series (at least 2 columns of time series)
}
  \item{max.lag}{
Maximum lag.  Can be omitted. Defaults to \eqn{\sqrt{n} + 10} unless \eqn{n < 60}.  If the series is seasonal, this will be at least 4 seasons by default.
}
  \item{na.action}{How to handle missing data; default is \code{na.pass}
}
  \item{ylim}{Specify limits for the all correlation axes. If NULL (default) the values
  are a little wider than the min and max of all values.
}
  \item{acf.highlight}{If TRUE (default), the diagonals (ACFs) are highlighted.
}
  \item{...}{Additional arguments passed to \code{\link{tsplot}}
}
}

\details{Produces a grid of plots of the sample ACF (diagonal) and CCF (off-diagonal).
The plots in the grid are estimates of  \kbd{corr{x(t+LAG), y(t)}}.  Thus
\kbd{x} leads \kbd{y} if \kbd{LAG} is positive and \kbd{x} lags \kbd{y} if \kbd{LAG} is negative.
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
\examples{
acfm(diff(log(econ5)))

acfm(diff(log(econ5)), gg=TRUE, acf=FALSE)
}
\keyword{ts}
