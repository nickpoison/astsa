\name{astsa-package}
\alias{astsa-package}
\alias{astsa}
\docType{package}
\title{Applied Statistical Time Series Analysis (more than just data)
} 
\description{
Contains data sets and scripts for analyzing time series in both the frequency and time domains including state space modeling as well as supporting the texts \href{https://link.springer.com/book/10.1007/978-3-319-52452-8}{Time Series Analysis and Its Applications: With R Examples (5th ed, 2024)}  and \href{https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9780367221096}{Time Series: A Data Analysis Approach Using R, (1st ed, 2019)}.

}
\details{
\tabular{ll}{
Package: \tab astsa\cr
Type: \tab Package\cr
Version: \tab 2.1\cr
Date: \tab 2024-01-03\cr
License: \tab GPL-3\cr
LazyLoad: \tab yes\cr
LazyData: \tab yes\cr
}
}
\author{
David Stoffer <stoffer@pitt.edu>
}
\note{Some older scripts and data sets have been updated, and old versions have an x in front of them, for example \code{xgtemp} is an old data file that used to be called \code{gtemp}. These scripts and data sets have not changed (they will still work with the x name change), but they will be phased out eventually. 

Also, due to the fact that, if loaded, the \code{dplyr} package corrupts \code{stats::filter} and \code{stats::lag}, 
those are put in the global (or user) environment as \code{filter} and \code{lag} when \code{astsa} is loaded so they have precedent. You can use \code{rm()} to remove those from the global environment if necessary.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\keyword{ package }
\keyword{ ts }
