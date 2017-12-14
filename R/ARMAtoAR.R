ARMAtoAR <- function(ar = 0, ma = 0, lag.max=20){
             ARMAtoMA <- stats::ARMAtoMA
             arinv <- -ma
             mainv <- -ar
             return(round(ARMAtoMA(arinv, mainv, lag.max), 3))
}