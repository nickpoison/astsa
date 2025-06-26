ESS <-
function(trace, tol = 1e-8, BIC=TRUE){
  if (NCOL(trace) > 1){ 
    cat('\nUnivariate Input Only \n')
    stop('see Examples in help(ESS) for multivariate case')
  }
  v = spec.ic(trace, BIC=BIC, order.max=30, plot=FALSE)
  spec0 = as.numeric(v[[2]][1,2])
  if (spec0 <= tol){
    return(0) 
  } else {
    return(round(length(trace)*var(trace)/spec0, 4))
 }
}
