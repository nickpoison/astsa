FDR <-
function(pvals,qlevel=0.05){
#
# Description:
#
#    This is an internal function that performs the basic FDR of Benjamini & Hochberg (1995).
#
# Arguments:
#
#   pvals (required):  a vector of pvals on which to conduct the multiple testing
#
#   qlevel: the proportion of false positives desired
#
  n <- length(pvals)
  sorted.pvals <- sort(pvals)
  sort.index <- order(pvals)
  indices <- (1:n)*(sorted.pvals<=qlevel*(1:n)/n)
  num.reject <- max(indices)
  if(num.reject){
    indices <- 1:num.reject
    #return(sort(sort.index[indices]))
    u <- sort(sort.index[indices])
    fdr.id <- u[which.max(pvals[u])]
    return(fdr.id)
  } else{
    return(NULL)
  }
}

