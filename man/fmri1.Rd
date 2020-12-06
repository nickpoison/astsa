\name{fmri1}
\alias{fmri1}
\docType{data}
\title{fMRI Data Used in Chapter 1
}
\description{A data frame that consists of average fMRI BOLD signals at eight locations.
}
\usage{data(fmri1)}
 \format{
   The format is:
  mts [1:128, 1:9] }
\details{Multiple time series consisting of fMRI BOLD signals at eight locations (in columns 2-9, column 1 is time period), when a stimulus was applied for 32 seconds and then stopped for 32 seconds. The signal period is 64 seconds and the sampling rate was one observation every 2 seconds for 256 seconds (\eqn{n = 128}).  The columns are labeled: "time" "cort1" "cort2" "cort3"  "cort4"   "thal1"   "thal2"  "cere1"  "cere2".
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\seealso{\code{\link{fmri}}}
\keyword{datasets}