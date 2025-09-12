\name{test.linear}
\alias{test.linear}
\title{Test Linearity of a Time Series via Normalized Bispectrum 
} 
\description{Produces a plot of the tail probabilities of a normalized bispectrum of a series under the assumption the model is a linear process with iid innovations. 
}
\usage{
test.linear(series, color = TRUE, detrend = FALSE, main = NULL)
}
\arguments{
  \item{series }{ the time series (univariate only)
}
  \item{color }{ if FALSE, the graphic is produced in gray scale
}
  \item{detrend }{ if TRUE, the series is detrended first
}
\item{main }{ if NULL (default), a very nice title is chosen for the plot
}
}
\value{\item{prob }{ matrix of tail probabilities - returned invisibly}
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
\note{The null hypothesis is that the data are from a linear process with i.i.d. innovations. Under the null hypothesis, the bispectrum is constant over all frequencies.  Chi-squared test statistics are formed in blocks to measure departures from the null hypothesis and the corresponding p-values are displayed in a graphic and returned invisibly. Details are in 
    Hinich, M. and Wolinsky, M. (2005). Normalizing bispectra. \emph{Journal of Statistical Planning and Inference}, 130, 405--411.
}
\examples{
test.linear(nyse)  # :(
test.linear(soi)   # :)
}
\keyword{ ts }   
