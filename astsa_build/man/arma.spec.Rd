\name{arma.spec}
\alias{arma.spec}
\title{Spectral Density of an ARMA Model
} 
\description{Gives the ARMA model spectrum, but first tests for causality and invertibility, and then for parameter redundancy.
}
\usage{
arma.spec(ar = 0, ma = 0, var.noise = 1, n.freq = 500, main = NULL, redundancy.tol=.1,
            frequency = 1, ylim = NULL, plot = TRUE, ...)
}
\arguments{
  \item{ar}{vector of AR parameters
}
  \item{ma}{vector of MA parameters
}
  \item{var.noise}{variance of the noise
}
  \item{n.freq}{number of frequencies
}
  \item{main}{title of graphic; default is "ARMA" with orders "(p, q)"
}
  \item{redundancy.tol}{tolerance for reporting parameter redundancy
}
  \item{frequency}{for plotting, adjusts the frequency axis units
}
  \item{ylim}{optional; specify limits for the y-axis
}
  \item{plot}{if TRUE (default), produces a graphic
}
  \item{\dots}{additional arguments for the graphic
}
}
\details{The basic call is \code{arma.spec(ar, ma)} where \code{ar} and \code{ma} are vectors
containing the model parameters. Use \code{log='y'} if you want the plot on a log scale. 

If the model is not causal or invertible, a stop error with a message is given; e.g., \code{arma.spec(ar=1, ma=1)} will just produce warnings.

If there are (approximate) common zeros, a spectrum will be displayed and a warning will be given;
e.g., \code{arma.spec(ar= .9, ma= -.9)} will yield a warning and the plot will be the
spectrum of white noise. See \code{\link{arma.check}} for details on the evaluation of parameter redundancy.
}
\value{ 
 \item{freq }{frequencies - returned invisibly}
 \item{spec }{ spectral ordinates - returned invisibly }
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
\seealso{
\code{\link{arma.check}}
}
\examples{
arma.spec(ar = c(1, -.9), ma = .8)

arma.spec(ar = c(1, -.9), log='y')

arma.spec(ar = -.9, ma=.89, gg=TRUE)  # almost white noise

# if you want a seasonal model, you have to be a little clever
arma.spec(ar=c(rep(0,11),.4), ma=.5, col=5, lwd=3, frequency=12)
}
\keyword{ts}