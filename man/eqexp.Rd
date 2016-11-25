\name{eqexp}
\alias{eqexp}
\docType{data}
\title{Earthquake and Explosion Seismic Series
%%   ~~ data name/kind ... ~~
}
\description{This is a data frame of the earthquake and explosion seismic series used throughout the text. 
%%  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\format{
  A data frame with 2048 observations (rows) on  17 variables (columns).  Each column is a numeric vector.
}
\details{The matrix has 17 columns, the first eight are earthquakes, the second eight are explosions, and the last column is the Novaya Zemlya event of unknown origin.  

The column names are: \code{EQ1, EQ2,...,EQ8; EX1, EX2,...,EX8; NZ}.  The first 1024 observations correspond to the P wave, the second 1024 observations correspond to the S wave.
%%%%  ~~ If necessary, more details than the __description__ above ~~
}
%%\source{http://www.gwu.edu/~nsarchiv/NSAEBB/NSAEBB200/index.htm
%%  ~~ reference to a publication or URL from which the data were obtained ~~
%%}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%%  ~~ possibly secondary sources and usages ~~
}
\keyword{datasets}