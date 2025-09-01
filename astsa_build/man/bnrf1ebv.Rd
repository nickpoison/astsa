\name{bnrf1ebv}
\alias{bnrf1ebv}
\docType{data}
\title{Nucleotide sequence - BNRF1 Epstein-Barr 
} 
\description{Nucleotide sequence of the BNRF1 gene of the Epstein-Barr virus
(EBV): 1=A, 2=C, 3=G, 4=T. The data are used in Chapter 7.
}
\format{
  The format is:
 Time-Series [1:3954] from 1 to 3954: 1 4 3 3 1 1 3 1 3 1 ...
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
head(bnrf1ebv)
head(dna2vector(bnrf1ebv))
}
\keyword{datasets}
