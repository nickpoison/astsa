sarima.sim <-
function(ar=NULL, d=0, ma=NULL, sar=NULL, D=0, sma=NULL, S=NULL,
          n=500, rand.gen=rnorm, burnin=NA, ...){ 
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
  if (is.na(burnin)) burnin = 50 + po + qo + d 	   
  if (burnin != round(burnin) || burnin < 0) { 	 
       stop("'burnin' must be a non-negative integer")        
   }
  num = n + burnin   
  x = .zarima_sim(list(order=c(po,d,qo), ar=ar, ma=ma), n=num, rand.gen=rand.gen, ...)
 } else {  
  if (length(sar)==1 && sar==0) sar=NULL
  if (length(sma)==1 && sma==0) sma=NULL 
  if (S <= po)
      { stop("AR order should be less than seasonal order 'S'") } 
  if (S <= qo)
      { stop("MA order should be less than seasonal order 'S'") } 	  
  if (D != round(D) || D < 0) 
      { stop("seasonal difference order 'D' must be a positive integer") }	  
  Po = length(sar)
  Qo = length(sma)
  if (S > 0 && Po + Qo + D < 1) 
     { stop("S > 0 but no seasonal parameters are specified") }
  if (Po > 0){
   SAR = c(1, rep(0, Po*S))
   SAR[seq(S+1, Po*S+1, by=S)] = -sar
    minroots <- min(Mod(polyroot(SAR)))
    if (minroots <= 1) { stop("AR side is not causal") }
   if (po>0) {
    AR = c(1,-ar) 
   } else {
    AR = 1
   }
   arnew = polyMul(AR, SAR)
   arnew = -arnew[-1]
   } else {
   arnew = ar
   }
  if (Qo > 0){
   SMA = c(1, rep(0, Qo*S))
   SMA[seq(S+1, Qo*S+1, by=S)] = sma
    minroots <- min(Mod(polyroot(SMA)))
     if (minroots <= 1) { stop("MA side is not invertible") }
   if (qo>0) {
    MA = c(1,ma) 
   } else {
    MA = 1
   }
   manew = polyMul(MA, SMA)
   manew = manew[-1]
   } else {
   manew = ma
   }  
   arorder = length(arnew)
   maorder = length(manew)
   if (is.na(burnin))  burnin = 50 + (D + Po + Qo)*S + d + po + qo
   if (burnin != round(burnin) || burnin < 0) { 	 
       stop("'burnin' must be a non-negative integer")         
   }
   num = n + burnin
   x = .zarima_sim(list(order=c(arorder,d,maorder), ar=arnew, ma=manew), n=num, rand.gen=rand.gen, ...)
  if (D > 0){
   x = stats::diffinv(x, lag=S, differences=D)
   }
  } 
###
frq = ifelse(is.null(S),1,S)
x = ts(x[(burnin+1):(burnin+n)], start=0, frequency=frq)
return(x)
}


##
.zarima_sim <-
function (model, n, rand.gen = rnorm, innov = rand.gen(n, ...), ...)
{
    filter = stats::filter
	if (length(innov) < n)
	   warning(paste("the number of innovations should be at least 'n + burnin' = ", n))
    if (n <= 0L) 
        stop("'n' must be strictly positive")
    p <- length(model$ar)
    q <- length(model$ma)
	d <- model$order[2L]
        if (d != round(d) || d < 0) 
            stop("'d' must be a positive integer")
    x <- ts(innov)
	if (length(model$ma)) {
        x <- filter(x, c(1, model$ma), sides = 1L)
        x[seq_along(model$ma)] <- 0
    }
    if (length(model$ar)) 
        x <- filter(x, model$ar, method = "recursive")
    if (d > 0) 
        x <- diffinv(x, differences = d)
    as.ts(x)
}

