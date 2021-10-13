\name{dna2vector}
\alias{dna2vector}
\title{
Convert DNA Sequence to Indicator Vectors
}
\description{
Takes a DNA sequence (string) of general form (e.g., FASTA) and converts it to a sequence of indicator vectors for use with the Spectral Envelope (\code{specenv}).
}
\usage{
dna2vector(data, alphabet = NULL)
}
\arguments{
  \item{data}{
A DNA sequence as a single string.
}
  \item{alphabet}{
The particular alphabet  being used. The default is \code{alphabet=c("A", "C", "G", "T")}.
}
}
\details{Takes a string of categories and converts it to a matrix of indicators. The data can then be used by the script \code{\link{specenv}}, which calculates the Spectral Envelope of the sequence (or subsequence). Many different type of sequences can be used, including FASTA and GenBank, as long as the data is a string of categories.

    The indicator vectors (as a matrix) are returned invisibly in case the user forgets to put the results in an object wherein the screen would scroll displaying the entire sequence.  In other words, the user should do something like \code{xdata = dna2vector(data)} where \code{data} is the original sequence.

    As an example, if the DNA sequence is in a FASTA file, say \code{sequence.fasta}, remove the first line which will look like \code{>V01555.2 ... }. Then the following code can be used to read the data into the session, create the indicator sequence and save it as a compressed R data file:

\preformatted{
  fileName <- 'sequence.fasta'      # name of FASTA file
  data     <- readChar(fileName, file.info(fileName)$size)  # input the sequence
  myseq    <- dna2vector(data)      # convert it to indicators

  ##== and if you want to compress and save the data ==##
  save(myseq, file='myseq.rda')
  ##== and then load it when needed ==##
  load('myseq.rda')
}
}
\value{matrix of indicator vectors; returned invisibly
}
\references{
You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.
}
\author{
D.S. Stoffer
}
\seealso{
 \code{\link{specenv}}
}
\examples{
# Epstein-Barr virus (entire sequence included in astsa)
xdata = dna2vector(EBV)

# part of EBV with  1, 2, 3, 4 for "A", "C", "G", "T"
xdata = dna2vector(bnrf1ebv)


# raw GenBank sequence
data <-
c("1 agaattcgtc ttgctctatt cacccttact tttcttcttg cccgttctct ttcttagtat
  61 gaatccagta tgcctgcctg taattgttgc gccctacctc ttttggctgg cggctattgc")
xdata = dna2vector(data, alphabet=c('a', 'c', 'g', 't'))

# raw FASTA sequence
data <-
 c("AGAATTCGTCTTGCTCTATTCACCCTTACTTTTCTTCTTGCCCGTTCTCTTTCTTAGTATGAATCCAGTA
    TGCCTGCCTGTAATTGTTGCGCCCTACCTCTTTTGGCTGGCGGCTATTGCCGCCTCGTGTTTCACGGCCT")
xdata = dna2vector(data)
}
\keyword{ manip }

