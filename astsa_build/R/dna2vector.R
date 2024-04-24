dna2vector <-
function(data, alphabet=NULL){
 if ( is.ts(data) && NCOL(data) > 1 ) stop("univariate time series only")   
 if ( !.isString(data) && !is.vector(data) && !is.ts(data) ) 
     stop("Data should be a single string, a vector, or a time series: see examples") 
 if (.isString(data)) {
     if (is.null(alphabet)) alphabet=c("A", "C", "G", "T")
     data <- gsub('[[:digit:]]+', "", data)    # remove numbers   
     data <- gsub("\n", "", data, fixed=TRUE)  # remove carriage returns
     data <- gsub(" ", "", data, fixed=TRUE)   # remove spaces 
     u <- lapply(strsplit(data, ""), .cnvrt, alphabet)
     x <- 1*u[[1]]
 } else {
     if (is.null(alphabet)) alphabet=1:4
     if (!.isString(data)) alphabet = alphabet
     u = sapply(data, .cnvrt, alphabet, simplify='array')
     x = 1*drop(u)
 }
invisible(x)
}



.cnvrt <- function(x,  data) { outer(x, data, FUN = '==') }
.isString <- function(x) {is.character(x) & length(x) == 1}