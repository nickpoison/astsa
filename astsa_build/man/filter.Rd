% taken from the stats package almost 'as is'

\name{filter}
\alias{filter}
\title{Linear Filtering for Time Series}
\usage{
filter(x, filter, method = c("convolution", "recursive"),
       sides = 2, circular = FALSE, init)
}
\arguments{
  \item{x}{a univariate or multivariate time series.}

  \item{filter}{a vector of filter coefficients in reverse time order
    (as for AR or MA coefficients).}

  \item{method}{Either \code{"convolution"} or \code{"recursive"} (and
    can be abbreviated). If \code{"convolution"} a moving average is
    used: if \code{"recursive"} an autoregression is used.}

  \item{sides}{for convolution filters only. If \code{sides = 1} the
    filter coefficients are for past values only; if \code{sides = 2}
    they are centered around lag 0.  In this case the length of the
    filter should be odd, but if it is even, more of the filter
    is forward in time than backward.}

  \item{circular}{for convolution filters only.  If \code{TRUE}, wrap
    the filter around the ends of the series, otherwise assume
    external values are missing (\code{NA}).}

  \item{init}{for recursive filters only. Specifies the initial values
    of the time series just prior to the start value, in reverse
    time order. The default is a set of zeros.}
}
\description{
  Applies linear filtering to a univariate time series or to each series
  separately of a multivariate time series.
}
\value{
  A time series object.
}
\details{
  Missing values are allowed in \code{x} but not in \code{filter}
  (where they would lead to missing values everywhere in the output).

  Note that the recursive filter gives
  \deqn{x_t =  \phi_1 x_{t-1} + \cdots + \phi_p x_{t-p} + w_t}{x[t] =
     phi[1]*x[t-1] + \dots + phi[p]*x[t-p] +  w[t] }

  The convolution filter is
  \deqn{x_t = \theta_0 w_{t+o} + \cdots + \theta_{q-1} w_{t+o-(q-1)}}{x[t] = theta[0]*w[t+o] + \dots + theta[q]*x[i+o-(q-1)]}

  where \code{o} is the offset: see \code{sides} for how it is determined.
}
\note{
This is \code{stats::filter}. Because of the mess created by \code{dplyr}, now if \code{astsa} is loaded after \code{dplyr}, this will take back the script as originally intended.
}

\examples{
# convolution (default)
wgts = c(.5, rep(1,11), .5)/12
soif = filter(soi, sides=2, filter=wgts)
tsplot(cbind(soi, soif), col=2*2:1, lwd=1:2, spaghetti=TRUE)

# recursive
w = rnorm(300) # 50 extra to avoid startup problems
x = filter(w, filter=c(1.5, -.75), method="recursive")[-(1:50)]
tsplot(x, main="autoregression", col=4, gg=TRUE)
}
\keyword{ts}
