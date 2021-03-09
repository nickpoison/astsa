\name{SVfilter}
\alias{SVfilter}
\title{Switching Filter (for Stochastic Volatility Models)
}
\description{Performs a special case switching filter when the observational noise is a certain mixture of normals. Used to fit a stochastic volatility model. 
}
\usage{
SVfilter(num, y, phi0, phi1, sQ, alpha, sR0, mu1, sR1)
}
\arguments{
  \item{num}{number of observations
}
  \item{y}{time series of returns
}
  \item{phi0}{state constant
}
  \item{phi1}{state transition parameter
}
  \item{sQ}{state standard deviation
}
  \item{alpha}{observation constant
}
  \item{sR0}{observation error standard deviation for mixture component zero
}
  \item{mu1}{observation error mean for mixture component one
}
  \item{sR1}{observation error standard deviation for mixture component one
}
}
\value{
\item{xp }{one-step-ahead prediction of the volatility}
\item{Pp }{mean square prediction error of the volatility}
\item{like }{the negative of the log likelihood at the given parameter values}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{D.S. Stoffer
}
\keyword{ ts }
