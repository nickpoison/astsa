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
  x = .zarima_sim(list(order=c(po,d,qo), ar=ar, ma=ma), n=n, rand.gen=rand.gen, ...)
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
   x = .zarima_sim(list(order=c(arorder,d,maorder), ar=arnew, ma=manew), n=num, rand.gen=rand.gen, ...)
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


##
.zarima_sim <-
function (model, n, rand.gen = rnorm, innov = rand.gen(n, ...), 
    n.start = NA, start.innov = rand.gen(n.start, ...), ...) 
{
    if (!is.list(model)) 
        stop("'model' must be list")
    if (n <= 0L) 
        stop("'n' must be strictly positive")
    p <- length(model$ar)
    q <- length(model$ma)
    if (is.na(n.start)) { n.start <- 50 + p + q }
	d <- model$order[2L]
        if (d != round(d) || d < 0) 
            stop("number of differences must be a positive integer")
    if (!missing(start.innov) && length(start.innov) < n.start) 
        stop(sprintf(ngettext(n.start, "'start.innov' is too short: need %d point", 
            "'start.innov' is too short: need %d points"), 
            n.start), domain = NA)
    x <- ts(c(start.innov[seq_len(n.start)], innov[1L:n]), start = 1 - 
        n.start)
    if (length(model$ma)) {
        x <- filter(x, c(1, model$ma), sides = 1L)
        x[seq_along(model$ma)] <- 0
    }
    if (length(model$ar)) 
        x <- filter(x, model$ar, method = "recursive")
    if (n.start > 0) 
        x <- x[-(seq_len(n.start))]
    if (d > 0) 
        x <- diffinv(x, differences = d)
    as.ts(x)
}


