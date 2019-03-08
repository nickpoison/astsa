\name{fmri1}
\alias{fmri1}
\docType{data}
\title{fMRI Data Used in Chapter 1
%%   ~~ data name/kind ... ~~
}
\description{A data frame that consists of average fMRI BOLD signals at eight locations.
%%  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\usage{data(fmri1)}
 \format{
   The format is:
  mts [1:128, 1:9] }
%%  - attr(*, "dimnames")=List of 2
%%   ..$ : NULL
%%     ..$ : chr [1:9] "time" "cort1" "cort2" "cort3" ...
%%  - attr(*, "tsp")= num [1:3] 1 128 1
%%  - attr(*, "class")= chr [1:2] "mts" "ts"
%% }
\details{Multiple time series consisting of fMRI BOLD signals at eight locations (in columns 2-9, column 1 is time period), when a stimulus was applied for 32 seconds and then stopped for 32 seconds. The signal period is 64 seconds and the sampling rate was one observation every 2 seconds for 256 seconds (\eqn{n = 128}).  The columns are labeled: "time" "cort1" "cort2" "cort3"  "cort4"   "thal1"   "thal2"  "cere1"  "cere2".
%%  ~~ If necessary, more details than the __description__ above ~~
}
%\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
%}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/} and \url{http://www.stat.pitt.edu/stoffer/tsda/} 
%%  ~~ possibly secondary sources and usages ~~
}
\seealso{\code{\link{fmri}}}
\keyword{datasets}