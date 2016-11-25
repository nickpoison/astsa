\name{globtempl}
\alias{globtempl}
\docType{data}
\title{Global mean land (only) temperature deviations - updated
%%   ~~ data name/kind ... ~~
}
\description{Global mean [land only] temperature deviations (from 1951-1980 average), measured in degrees centigrade, for the years 1880-2015. This is an update of \code{gtemp2}.  Note the data file is \code{globtemp-el} not 
    \code{globtemp-one}; the el stands for land.
}
\usage{data("globtempl")}
\format{
  The format is:
 Time-Series [1:136] from 1880 to 2015: -0.53 -0.51 -0.41 -0.43 -0.72 -0.56 -0.7 -0.74 -0.53 -0.25 ...
}
\details{
The data were changed after 2011, so there are discrepancies between this data set and \code{gtemp2}.  
The differences are explained here: \url{http://www1.ncdc.noaa.gov/pub/data/ghcn/v3/GHCNM-v3.2.0-FAQ.pdf}.
}
\source{\url{http://data.giss.nasa.gov/gistemp/graphs/}
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%%  ~~ possibly secondary sources and usages ~~
}
\seealso{\code{\link{globtemp}}, \code{\link{gtemp2}},  \code{\link{gtemp}}}
\keyword{datasets}