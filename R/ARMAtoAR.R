ARMAtoAR <- function(ar = 0, ma = 0, lag.max=20){
             ARMAtoMA <- stats::ARMAtoMA
             arinv <- -ma
             mainv <- -ar
             return(ARMAtoMA(arinv, mainv, lag.max))
}