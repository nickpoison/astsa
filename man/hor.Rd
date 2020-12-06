\name{hor}
\alias{hor}
\docType{data}
\title{Hawaiian occupancy rates}
\description{Quarterly Hawaiian hotel occupancy rate (percent of rooms occupied) from 
1982-I to 2015-IV
}
\format{
  The format is:
 Time-Series [1:136] from 1982 to 2015: 79  65.9  70.9  66.7  ...
}
\source{\url{https://dbedt.hawaii.gov/economic/qser/tourism/}
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/} 
}
\examples{
plot(hor, type='c')                            # plot data and
text(hor, labels=1:4, col=c(1,4,2,6), cex=.9)  # add quarter labels
#
plot(stl(hor, s.window=15))  # fit structural model
}
\keyword{datasets}

