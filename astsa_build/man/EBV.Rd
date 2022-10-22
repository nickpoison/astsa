\name{EBV}
\alias{EBV}
\docType{data}
\title{Entire Epstein-Barr Virus (EBV) Nucleotide Sequence
} 
\description{EBV nucleotide sequence - 172281 bp as a single string
}
\format{
  The format is:
  chr "AGAATTCGTCTT  ..."
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\note{EBV is not useful on its own, but using  `dna2vector`, different regions can be explored. For example, \code{ebv = dna2vector(EBV)} 
}
\source{\url{https://www.ncbi.nlm.nih.gov/nuccore/V01555.2}
}
\seealso{\code{\link{dna2vector}}
}
\keyword{datasets}
