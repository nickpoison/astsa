\name{stoch.reg}
\alias{stoch.reg}
\title{Frequency Domain Stochastic Regression
} 
\description{Performs frequency domain stochastic regression discussed in Chapter 7.  
}
\usage{
stoch.reg(xdata, cols.full, cols.red, alpha, L, M, plot.which, ...)
}
\arguments{
  \item{xdata}{data matrix with the last column being the response variable
}
  \item{cols.full}{specify columns of data matrix that are in the full model
}
  \item{cols.red}{specify columns of data matrix that are in the reduced model (use NULL if there are no inputs in the reduced model) 
}
  \item{alpha}{test size
}
  \item{L}{number (odd) specifying degree of smoothing  
}
  \item{M}{number (odd) of points in the discretization of the integral
}
  \item{plot.which}{\code{coh} or \code{F.stat}, to plot either the squared-coherencies or the F-statistics, respectively
}
  \item{\dots}{additional graphic arguments
}
}
\details{
This function computes the spectral matrix, F statistics and coherences, and plots them.
Returned as well are the coefficients in the impulse response function.

Enter, as the argument to this function, the full data matrix, and then the labels of the 
columns of input series in the "full" and "reduced" regression models - enter NULL if there 
are no inputs under the reduced model. 

The response variable is the LAST column of the data matrix, and this need not be specified 
among the inputs.  Other inputs are alpha (test size), L (smoothing), M (number 
of points in the discretization of the integral)  and plot.which = "coh" 
or "F", to plot either the coherences or the F statistics.
}
\value{\item{power.full }{spectrum under the full model}
\item{power.red }{spectrum under the reduced model}
\item{Betahat }{regression parameter estimates}
\item{eF }{pointwise (by frequency) F-tests}
\item{coh }{coherency}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\author{D.S. Stoffer
}
\note{See Example 7.1 of the text. The script is based on code that was contributed by Professor Doug Wiens, Department of Mathematical and Statistical Sciences, University of Alberta. 
}
\keyword{ ts }
