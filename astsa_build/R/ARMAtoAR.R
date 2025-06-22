ARMAtoAR <- function(ar = 0, ma = 0, lag.max=20){
  return(ARMAtoMA(ar=-ma, ma=-ar, lag.max))
}