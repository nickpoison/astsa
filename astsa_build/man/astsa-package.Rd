\name{astsa-package}
\alias{astsa-package}
\alias{astsa}
\docType{package}
\title{Applied Statistical Time Series Analysis (more than just data)
} 
\description{
Contains data sets and scripts for analyzing time series in both the frequency and time domains including state space modeling as well as supporting the texts \href{https://link.springer.com/book/10.1007/978-3-031-70584-7}{Time Series Analysis and Its Applications: With R Examples (5th ed, 2025)}  and \href{https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9781041031642}{Time Series: A Data Analysis Approach Using R, (2nd ed, 2026)}. Most scripts are designed to need minimal input to produce aesthetically pleasing output for ease of use in live demonstrations and in course work.
}
\details{
\tabular{ll}{
Package: \tab astsa\cr
Type: \tab Package\cr
Version: \tab 2.4\cr
Date: \tab 2026-01-01\cr
License: \tab GPL (>= 2) \cr
LazyLoad: \tab yes\cr
LazyData: \tab yes\cr
}
}
\author{
David Stoffer <stoffer@pitt.edu>
}
\section{Warning}{If loaded after \code{astsa}, the package \code{dplyr} will mask the base scripts \code{filter} and \code{lag} among other things. In this case, whenever you analyze time series data, we suggest you either:

(1) Detach it if it's loaded but not being used: 
\preformatted{   detach(package:dplyr)
} 

(2) If you want to use it, fix it: 
\preformatted{
   library(dplyr, exclude = c("filter", "lag"))   # load it without the culprits 
   dlag    = dplyr::lag         # and fix ... 
   dfilter = dplyr::filter      # ... the blunders
}
then use \code{dlag} and \code{dfilter} for \code{dplyr} scripts \cr
and \code{lag} and \code{filter} can be use as originally intended.


(3) Or just take back the commands:
\preformatted{
   filter = stats::filter
   lag    = stats::lag 
}
and you can still use these for \code{dpylr}: 
\preformatted{
   dlag    = dplyr::lag
   dfilter = dplyr::filter
}
(4) Or avoid all of these problems and use 
\href{https://CRAN.R-project.org/package=data.table}{data.table} instead of
\code{dplyr}. If you are doing data manipulation, you should know that
\code{dplyr} is inspired by \code{data.table}, but it
is  much slower and weaker than \code{data.table}.  
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
