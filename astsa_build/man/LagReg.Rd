\name{LagReg}
\alias{LagReg}
\title{Lagged Regression
}
\description{Performs lagged regression as discussed in Chapter 4.
}
\usage{
LagReg(input, output, L = c(3, 3), M = 40, threshold = 0, 
        inverse = FALSE)
}
\arguments{
  \item{input}{input series
}
  \item{output}{output series
}
  \item{L}{degree of smoothing;  see \code{spans} in the help file for \code{spec.pgram}.
}
  \item{M}{must be even; number of terms used in the lagged regression
}
  \item{threshold}{the cut-off used to set small (in absolute value) regression coeffcients equal to zero
}
  \item{inverse}{if TRUE, will fit a forward-lagged regression
}
}
\details{For a bivariate series, \code{input} is the input series and \code{output} is the output series. The degree of smoothing for the spectral estimate is given by L; see \code{spans} in the help file for \code{spec.pgram}. The number of terms used in the lagged regression approximation is given by M, which must be even. The threshold value is the cut-off used to set small (in absolute value) regression coeffcients equal to zero (it is easiest to run LagReg twice, once with the default threshold of zero, and then again after inspecting the resulting coeffcients and the corresponding values of the CCF). Setting inverse=TRUE will fit a forward-lagged regression; the default is to run a backward-lagged regression. The script is based on code that was contributed by Professor Doug Wiens, Department of Mathematical and Statistical Sciences, University of Alberta. 
}
\value{Graphs of the estimated impulse response function, the CCF, and the output with the predicted values superimposed.
  \item{beta}{Estimated coefficients}
  \item{fit}{The output series, the fitted values, and the residuals}
}
\note{See Chapter 4 of the text for an example.
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
\keyword{ ts }
