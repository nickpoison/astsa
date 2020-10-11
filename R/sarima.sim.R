sarima.sim <-
function(ar=NULL, d=0, ma=NULL, sar=NULL, D=0, sma=NULL, S=NULL,
          n=500, rand.gen=rnorm, ...){ 
  if (length(ar)==1 && ar==0) ar=NULL
  if (length(ma)==1 && ma==0) ma=NULL  
  po = length(ar)
  qo = length(ma)
  if (po>0) {
       minroots <- min(Mod(polyroot(c(1, -ar))))
       if (minroots <= 1) { stop("AR side is not causal") }
    }
  if (qo>0){	
       minroots <- min(Mod(polyroot(c(1, ma))))
       if (minroots <= 1) { stop("MA side is not invertible") }	
  }
 if (is.null(S)) {
  if (length(sar)>0 || length(sma)>0) 
      { stop("the seasonal period 'S' is not specified") }
  x = .zarimasim(list(order=c(po,d,qo), ar=ar, ma=ma), n=n, rand.gen=rand.gen, ...)
 } else {  
  if (length(sar)==1 && sar==0) sar=NULL
  if (length(sma)==1 && sma==0) sma=NULL 
  if (D != round(D) || D < 0) 
      { stop("seasonal difference order 'D' must be a positive integer") }
  Po = length(sar)
  Qo = length(sma)
  if (Po > 0){
   SAR = rep(0, Po*S)
   SAR[1] = 1
   SAR[seq(S, Po*S,by=S)] = -sar
    minroots <- min(Mod(polyroot(SAR)))
    if (minroots <= 1) { stop("AR side is not causal") }
   if (po>1) {
    AR = c(1,-ar) 
   } else {
    AR = 1
   }
   arnew = polyMul(AR, SAR)
   arnew = c(0, -arnew[-1])   # replace constant with a 0 
   } else {
   arnew = ar
   }
  if (Qo > 0){
   SMA = rep(0, Qo*S)
   SMA[1] = 1
   SMA[seq(S, Qo*S,by=S)] = sma
    minroots <- min(Mod(polyroot(SMA)))
     if (minroots <= 1) { stop("MA side is not invertible") }
   if (qo>1) {
    MA = c(1,ma) 
   } else {
    MA = 1
   }
   manew = polyMul(MA, SMA)
   manew = c(0, manew[-1])
   } else {
   manew = ma
   }  
   arorder = length(arnew)
   maorder = length(manew)
   burnin = (D+5)*S
   num = n + burnin
   x = .zarimasim(list(order=c(arorder,d,maorder), ar=arnew, ma=manew), n=num, rand.gen=rand.gen, ...)
  if (D > 0){
   x = stats::diffinv(x, lag=S, differences=D)
   }
  x = x[-(1:burnin)]
  } 
###
frq = ifelse(is.null(S),1,S)
x = ts(x, start=0, frequency=frq)
return(x)
}
