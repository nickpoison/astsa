\name{test.linear}
\alias{test.linear}
\title{Test Linearity of a Time Series via Normalized Bispectrum 
}
\description{Produces a plot of the normalized bispectra of a series.  Smaller tail probabilities indicate departure from linearity.
}
\usage{
test.linear(x.data, color = TRUE)
}
\arguments{
  \item{x.data}{ The time series.
}
  \item{color}{ If FALSE, the graphic is produced in gray scale.
}
}
\value{\item{prob }{Matrix of tail probabilities - returned invisibly}
}
\references{Hinich, M. and Wolinsky, M. (2005). Normalizing bispectra. \emph{Journal of Statistical Planning and Inference}, 130, 405--411.
}
\author{D.S. Stoffer
}
\note{The null hypothesis is that the data are from a linear process with i.i.d. innovations. Under the null hypothesis, the bispectrum is constant over all frequencies.  Chi-squared test statistics are formed to measure departures from the null hypothesis and the corresponding p-values are displayed in a graphic and returned invisibly.
}
\examples{
test.linear(sunspotz)  # :(
test.linear(soi)       # :)
}
\keyword{ ts }   
