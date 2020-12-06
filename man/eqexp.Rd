\name{eqexp}
\alias{eqexp}
\docType{data}
\title{Earthquake and Explosion Seismic Series
}
\description{This is a data frame of the earthquake and explosion seismic series used throughout the text. 
}
\format{
  A data frame with 2048 observations (rows) on  17 variables (columns).  Each column is a numeric vector.
}
\details{The matrix has 17 columns, the first eight are earthquakes, the second eight are explosions, and the last column is the Novaya Zemlya event of unknown origin.  

The column names are: \code{EQ1, EQ2,...,EQ8; EX1, EX2,...,EX8; NZ}.  The first 1024 observations correspond to the P wave, the second 1024 observations correspond to the S wave.
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/}
}
\keyword{datasets}