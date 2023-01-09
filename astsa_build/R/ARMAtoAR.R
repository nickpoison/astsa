ARMAtoAR <- function(ar = 0, ma = 0, lag.max=20){
  return(stats::ARMAtoMA(ar=-ma, ma=-ar, lag.max))
}