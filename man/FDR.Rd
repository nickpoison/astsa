\name{FDR}
\alias{FDR}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Basic False Discovery Rate
%%  ~~function to do ... ~~
}
\description{Computes the basic false discovery rate given a vector of p-values.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
FDR(pvals, qlevel = 0.05)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pvals }{ a vector of pvals on which to conduct the multiple testing
%%     ~~Describe \code{pvals} here~~
}
  \item{qlevel }{ the proportion of false positives desired
%%     ~~Describe \code{qlevel} here~~
}
}
%%\details{
%%  ~~ If necessary, more details than the description above ~~
%%}
\value{\item{fdr.id }{ NULL if no significant tests, or the index of the maximal p-value satisfying the FDR condition. }
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{fdr.id }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.berkeley.edu/~paciorek/code/fdr/fdr.R} 
%% ~put references to the literature/web site here ~
}
%\author{
%%  ~~who you are~~
%}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
%% \examples{
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(pvals,qlevel=0.05){
%% #
%% # Description:
%% #
%% #    This is an internal function that performs the basic FDR of Benjamini & Hochberg (1995).
%% #
%% # Arguments:
%% #
%% #   pvals (required):  a vector of pvals on which to conduct the multiple testing
%% #
%% #   qlevel: the proportion of false positives desired
%% #
%% # Value:
%% #
%% #   NULL if no significant tests, or a vector of the indices of the significant tests
%% #
%%   n <- length(pvals)
%%   sorted.pvals <- sort(pvals)
%%   sort.index <- order(pvals)
%%   indices <- (1:n)*(sorted.pvals<=qlevel*(1:n)/n)
%%   num.reject <- max(indices)
%%   if(num.reject){
%%     indices <- 1:num.reject
%%     #return(sort(sort.index[indices]))
%%     u <- sort(sort.index[indices])
%%     fdr.id <- u[which.max(pvals[u])]
%%     return(fdr.id)
%%   } else{
%%     return(NULL)
%%   }
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
%% %\keyword{ ~kwd1 }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 