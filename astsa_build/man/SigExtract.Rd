\name{SigExtract}
\alias{SigExtract}
\title{Signal Extraction And Optimal Filtering
} 
\description{Performs signal extraction and optimal filtering as discussed in Chapter 4.

}
\usage{
SigExtract(series, L = c(3, 3), M = 50, max.freq = 0.05, col = 4)
}
\arguments{
  \item{series}{univariate time series to be filtered
}
  \item{L}{degree of smoothing (may be a vector); see \code{spans} in \code{spec.pgram}
  for more details 
}
  \item{M}{number of terms used in the lagged regression approximation
}
  \item{max.freq}{truncation frequency, which must be larger than 1/M 
}
  \item{col}{color of the main graphs
}
}
\details{The basic function of the script, and the default setting, is to remove frequencies above 1/20 (and, in particular, the seasonal frequency of 1 cycle every 12 time points). The  sampling frequency of the time series is set to unity prior to the analysis. 
}
\value{Returns plots of (1) the original and filtered series, (2) the estiamted spectra of each series, (3)  the filter coefficients and the desired and attained frequency response function.  The filtered series is returned invisibly.
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
\note{The script is based on code that was contributed by Professor Doug Wiens,
Department of Mathematical and Statistical Sciences, University of Alberta.
}
\keyword{ ts }
