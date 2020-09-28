sarima.sim <-
function(ar=NULL, d=0, ma=NULL, sar=NULL, D=0, sma=NULL, S=NULL,
          n=500, rand.gen=rnorm, ...){   
  po = length(ar)
  qo = length(ma)
 if (is.null(S)) {
  x = stats::arima.sim(list(order=c(po,d,qo), ar=ar, ma=ma), n=n, rand.gen=rand.gen, ...)
 } else {  
  Po = length(sar)
  Qo = length(sma)
  if (Po > 0){
   SAR = rep(0, Po*S)
   SAR[1] = 1
   SAR[seq(S, Po*S,by=S)] = -sar
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
   x = stats::arima.sim(list(order=c(arorder,d,maorder), ar=arnew, ma=manew), n=num, rand.gen=rand.gen, ...)
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
