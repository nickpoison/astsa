arma.check <- function(ar=0, ma=0, sar=NULL, sma=NULL, S=NULL, redundancy.tol=.1, 
              plot.it=FALSE, ...)
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
    if (minroots <= 1) {cat("WARNING: Seasonal Part Not Invertible", "\n"); check.i <- check.i + 1}
   }

### end if not causal or invertible
   if (check.c + check.i > 0) return(cat('NOTE: Redundancy checked only for causal and invertible models\n'))
###

#### now check redundancy  
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
    if(any(abs(1/polyroot(SAR)[i]-1/polyroot(SMA)) <= redundancy.tol)) 
        {cat("\nWARNING: (Possible) Seasonal Parameter Redundancy", "\n"); red.count=1; break}
   }


## if ok, report causal & invertible
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

if (plot.it & (check.c + check.i < 1)) {
 .plotit(z.ar, z.ma, redundancy.tol, ...)
}
}

.plotit <-
function(z.ar=z.ar, z.ma=z.ma, red.tol=redundancy.tol, ...)
{
  if (length(z.ar) < 1) z.ar=NULL
  if (length(z.ma) < 1) z.ma=NULL

# setup blank graph
  tsplot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), cex.lab=1.25, cex.axis=1, 
     xlab = expression(italic("Re")), ylab = expression(italic("Im")), asp = 1, 
     family = "serif", ...)
  clip(-1,1,-1,1)
  abline(h=0,v=0, col=gray(.7), lty=2)

# add circle
  symbols(x = 0, y = 0, circles = 1, add = TRUE, inches = FALSE)
  title('Inverse Roots')

# 1/roots
  culer = astsa.col(c(4,2), .5)
  NULL -> leg1 -> leg2
  if (!is.null(z.ar)) {
   arrows(x0 = 0, y0 = 0, x1 = Re(1/z.ar), y1 = Im(1/z.ar), col = culer[1], lwd=3, length=.12)
   leg1 = 'AR'}
  if (!is.null(z.ma)) {
   arrows(x0 = 0, y0 = 0, x1 = Re(1/z.ma), y1 = Im(1/z.ma), col = culer[2], lwd=3, length=.1) 
   leg2 = 'MA'}
  if (is.null(leg1)) culer = rep(culer[2], 2)
  if (is.null(leg2)) culer = rep(culer[1], 2) 
legend('topright', pch=15, legend=c(leg1,leg2), col=culer, pt.cex=1.5, bty='n')

# plot redundancy tolerance
  for (i in 1:length(z.ar)){
   if (is.null(z.ar)) break
   symbols(Re(1/z.ar[i]), Im(1/z.ar[i]), circles=red.tol, add=TRUE, inches=FALSE, fg=culer[1])
  }
  for (i in 1:length(z.ma)) {
   if (is.null(z.ma)) break
   symbols(Re(1/z.ma[i]), Im(1/z.ma[i]), circles=red.tol, add=TRUE, inches=FALSE, fg=culer[2])
  }

}  # end


