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
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\keyword{datasets}