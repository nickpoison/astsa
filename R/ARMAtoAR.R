ARMAtoAR <- function(ar = numeric(), ma = numeric(), lag.max){
             arinv <- -ma
             mainv <- -ar
             return(round(ARMAtoMA(arinv, mainv, lag.max), 3))
}