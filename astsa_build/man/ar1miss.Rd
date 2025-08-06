\name{ar1miss}
\alias{ar1miss}
\docType{data}
\title{AR with Missing Values
} 
\description{Data used in Chapter 6 Problems
}
\format{
  The format is:  Time-Series [1:100]  with NA for missing values.
}

\details{Simulated AR(1) with \eqn{\phi=.9} and \eqn{\sigma_w=1} and ~10\% of the values missing at random (in this case, there happen to be 15 missing values). A similar data set can be generated as follows:
\preformatted{
x   = sarima.sim(ar=.9, n=100)
u   = sample(c(NA,0), replace=TRUE, size=100, prob=c(.1,.9))
arm = x + u 
}
Another approach if you want exactly 10 missing values is this:
\preformatted{
arms = sarima.sim(ar=.9, n=100)
arms[sample(1:100, size=10)] = NA
}
}

\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\keyword{datasets}
