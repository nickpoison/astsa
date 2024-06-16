\name{astsa-package}
\alias{astsa-package}
\alias{astsa}
\docType{package}
\title{Applied Statistical Time Series Analysis (more than just data)
} 
\description{
Contains data sets and scripts for analyzing time series in both the frequency and time domains including state space modeling as well as supporting the texts \href{https://link.springer.com/book/xxx}{Time Series Analysis and Its Applications: With R Examples (5th ed, 2024)}  and \href{https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9780367221096}{Time Series: A Data Analysis Approach Using R, (1st ed, 2019)}.

}
\details{
\tabular{ll}{
Package: \tab astsa\cr
Type: \tab Package\cr
Version: \tab 2.2\cr
Date: \tab 2024-09-01\cr
License: \tab GPL-3\cr
LazyLoad: \tab yes\cr
LazyData: \tab yes\cr
}
}
\author{
David Stoffer <stoffer@pitt.edu>
}
\note{If loaded, the \code{dplyr} package corrupts the base scripts \code{filter} and \code{lag} among other things. In this case, whenever you analyze time series data, we suggest you either:

(1) Detach it:\cr 
\code{detach:package:dplyr} 

(2) If you want to use \code{dplyr}, fix it: 
\verb{
library(dplyr, exclude = c("filter", "lag"))   # load it but remove the culprits 
Lag <- dplyr::lag            # and do what the dplyr ... 
Filter <- dplyr::filter      # ... maintainers refuse to do 
}

(3) Or just take back the commands:\cr
\code{filter = stats::filter} \cr  
\code{lag = stats::lag}

You can put (3) in your .First file and then you don't have to think about this mess any longer.
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
