\name{djia}
\alias{djia}
\docType{data}
\title{Dow Jones Industrial Average
%%   ~~ data name/kind ... ~~
}
\description{Daily DJIA values from April 2006 - April 2016
%%  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\format{
  The format is:
 xts [1:2518, 1:5] 11279 11343 11347 11337 11283 ...\cr
 - attr(*, "class")= chr [1:2] "xts" "zoo"\cr
 - attr(*, ".indexCLASS")= chr "Date"\cr
 - attr(*, ".indexTZ")= chr "UTC"\cr
 - attr(*, "tclass")= chr "Date"\cr
 - attr(*, "tzone")= chr "UTC"\cr
 - attr(*, "index")= atomic [1:2518] 1.15e+09 1.15e+09 1.15e+09 1.15e+09 1.15e+09 ...\cr
  ..- attr(*, "tzone")= chr "UTC"\cr
  ..- attr(*, "tclass")= chr "Date"\cr
 - attr(*, "dimnames")=List of 2\cr
  ..$ : NULL\cr
  ..$ : chr [1:5] "Open" "High" "Low" "Close" ...
}
\source{The data were obtained as follows, and can be updated in a similar way.\cr
\code{library(TTR) # install.packages('TTR') if you don't have it} \cr
\code{djia  = getYahooData("^DJI", start=20060420, end=20160420, freq="daily")} 
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
}
\keyword{datasets}
