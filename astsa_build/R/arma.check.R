arma.check <- function(ar=0, ma=0, sar=NULL, sma=NULL, S=NULL, redundancy.tol=.1)
{
   check.c <- 0
   check.i <-0 
 # check causality
   ar.poly <- c(1, -ar)
   z.ar <- polyroot(ar.poly)
   if(any(abs(z.ar) <= 1)) {cat("WARNING: Model Not Causal", "\n"); check.c <- check.c + 1} 
  # check invertibility
   ma.poly <- c(1, ma)
   z.ma <- polyroot(ma.poly)
   if(any(abs(z.ma) <= 1)) {cat("WARNING: Model Not Invertible", "\n"); check.i <- check.i + 1} 

  # seasonal
   if (length(sar)==1 && sar==0) sar=NULL   # reset if user enters 0 for these
   if (length(sma)==1 && sma==0) sma=NULL 

   Po = length(sar)
   Qo = length(sma)
  # check if S is specified, if not set it to 12
   if ( (Po + Qo > 0) & is.null(S)) { 
    S = 12
    cat("No seasonal period was entered so it has been set to S = 12\n") 
   }
   
  if (!is.null(S)){
   if (S <= length(ar)) stop("AR order should be less than seasonal order 'S'") 
   if (S <= length(ma)) stop("MA order should be less than seasonal order 'S'")  
  }


   if (Po > 0){
    SAR = c(1, rep(0, Po*S))
    SAR[seq(S+1, Po*S+1, by=S)] = -sar
    minroots <- min(Mod(polyroot(SAR)))
    if (minroots <= 1)  {cat("WARNING: Seasonal Part Not Causal", "\n"); check.c <- check.c + 1}
   } 
   if (Qo > 0){
    SMA = c(1, rep(0, Qo*S))
    SMA[seq(S+1, Qo*S+1, by=S)] = sma
    minroots <- min(Mod(polyroot(SMA)))
    if (minroots <= 1) {cat("\nWARNING: Seasonal Part Not Invertible", "\n"); check.i <- check.i + 1}
   }


#### now check redundancy [i.e. are any inverse roots (approximately) equal]
   ar.order <- length(ar)
   ma.order <- length(ma)
    if (redundancy.tol < 0) { 
      redundancy.tol=.1
      cat("\n'redundancy.tol' should not be negative and has been reset to its default value\n")
    }

   red.count = 0
   for (i in 1:ar.order) {
    if ( (ar[1] == 0 && ar.order == 1) || (ma[1] == 0 && ma.order == 1) )  break
    if(any(abs(1/z.ar[i]-1/z.ma) <= redundancy.tol)) 
        {cat("\nWARNING: (Possible) Parameter Redundancy", "\n"); red.count=1; break}
   }
   for (i in 1:Po) {
    if ( is.null(sar) || is.null(sma) )  break
    if(any(abs(1/polyroot(SAR)[i]-1/polyroot(SMA)) < redundancy.tol)) 
        {cat("\nWARNING: (Possible) Seasonal Parameter Redundancy", "\n"); red.count=1; break}
   }

## if no redundance, report causal & invertible
    if (red.count < 1) {
    if (check.c < 1)  cat("The model is causal.\n") 
    if (check.i < 1)  cat("The model is invertible.\n")
    }

#  responses for causal and invertible
   stopit = ifelse( (check.c + check.i > 0), TRUE, FALSE)
   if (red.count > 0){ 
      cat("\nIt looks like that ARMA model has (approximate) common factors.\nThis means that the model is (possibly) over-parameterized.\nYou might want to try again.\n")
      } else  
      if (!stopit & redundancy.tol >= .1)  { cat("That's a very nice ARMA model!\n")
      } else  
      if (!stopit & redundancy.tol < .1)  { cat("Since you lowered the redundancy tolerance, the model may be very nice,\nbut over-parameterization is still a possibility!\n")
    }
}
