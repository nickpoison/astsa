\name{FDR}
\alias{FDR}
\title{Basic False Discovery Rate
}
\description{Computes the basic false discovery rate given a vector of p-values and returns the index of the maximal p-value satisfying the FDR condition. 
}
\usage{
FDR(pvals, qlevel = 0.05)
}
\arguments{
  \item{pvals }{ a vector of pvals on which to conduct the multiple testing
}
  \item{qlevel }{ the proportion of false positives desired
}
}
\value{\item{fdr.id }{ NULL if no significant tests, or the index of the maximal p-value satisfying the FDR condition. }
}
\source{Built off of \url{https://www.stat.berkeley.edu/~paciorek/code/fdr/fdr.R}.
}
\note{This is used primarily in Chapter 7.
}
\references{
You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
