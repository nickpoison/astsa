\name{FDR}
\alias{FDR}
\title{Basic False Discovery Rate
}
\description{Computes the basic false discovery rate given a vector of p-values.
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
\references{\url{https://www.stat.berkeley.edu/~paciorek/code/fdr/fdr.R} 
}


