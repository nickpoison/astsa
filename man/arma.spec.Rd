\name{arma.spec}
\alias{arma.spec}
\title{Spectral Density of an ARMA Model 
}
\description{Gives the ARMA spectrum, tests for causality, invertibility, and
 common zeros.  
}
\usage{
arma.spec(ar = 0, ma = 0, var.noise = 1, n.freq = 500, log="n", 
          main='from specified model', frequency=1, ...)
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
  \item{log}{plot spectra on a log-scale; default is 'no'
}
  \item{main}{title of graphic
}
  \item{frequency}{for seasonal models, adjusts the frequency scale
}
  \item{\dots}{additional arguments 
}
}
\details{The basic call is \code{arma.spec(ar, ma)} where \code{ar} and \code{ma} are vectors
containing the model parameters. Use \code{log="yes"} if you want the plot on
a log scale. If the model is not causal or invertible an error message is given. If
there are approximate common zeros, a spectrum will be displayed and a warning will be given;
e.g., \code{arma.spec(ar= .9, ma= -.9)} will yield a warning and the plot will be the
spectrum of white noise. 
}
\value{ \item{freq }{frequencies - returned invisibly}
 \item{spec }{ spectral ordinates - returned invisibly }
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{D.S. Stoffer
}
\examples{
arma.spec(ar = c(1, -.9), ma = .8)

arma.spec(ar = c(1, -.9), main='AR(2)', gg=TRUE, col=5, lwd=2)

arma.spec(ar=c(rep(0,11),.4), ma=.5, col=5, lwd=3, frequency=12)
}
\keyword{ts}