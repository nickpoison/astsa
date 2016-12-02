sarima.for <-
function(xdata,n.ahead,p,d,q,P=0,D=0,Q=0,S=-1,tol=sqrt(.Machine$double.eps),no.constant=FALSE){ 
   #
   layout = graphics::layout
   par = graphics::par
   plot = graphics::plot
   grid = graphics::grid
   abline = graphics::abline
   lines = graphics::lines
   frequency = stats::frequency
   na.pass = stats::na.pass
   as.ts = stats::as.ts
   ts.plot = stats::ts.plot
   xy.coords = grDevices::xy.coords
   #
  xname=deparse(substitute(xdata))
  xdata=as.ts(xdata) 
  n=length(xdata)
  constant=1:n
  xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL
  if (d==0 & D==0) {
    fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
            xreg=xmean,include.mean=FALSE, optim.control=list(reltol=tol));
    nureg=matrix(1,n.ahead,1)        
} else if (xor(d==1, D==1) & no.constant==FALSE) {
    fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
            xreg=constant,optim.control=list(reltol=tol));
    nureg=(n+1):(n+n.ahead)       
} else { fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
            optim.control=list(reltol=tol));
          nureg=NULL   
}     
#--
 fore=stats::predict(fitit, n.ahead, newxreg=nureg)  
#-- graph:
  U  = fore$pred + 2*fore$se
  L  = fore$pred - 2*fore$se
  U1 = fore$pred + fore$se
  L1 = fore$pred - fore$se
   a=max(1,n-100)
  minx=min(xdata[a:n],L)
  maxx=max(xdata[a:n],U)
   t1=xy.coords(xdata, y = NULL)$x 
   if(length(t1)<101) strt=t1[1] else strt=t1[length(t1)-100]
   t2=xy.coords(fore$pred, y = NULL)$x 
   endd=t2[length(t2)]
   xllim=c(strt,endd)
  ts.plot(xdata,fore$pred, type="n", xlim=xllim, ylim=c(minx,maxx), ylab=xname) 
  grid(lty=1, col=gray(.9)); box()
  lines(xdata, type='o')
#  
   xx = c(time(U), rev(time(U)))
   yy = c(L, rev(U))
   polygon(xx, yy, border=8, col=gray(.6, alpha=.2) ) 
   yy1 = c(L1, rev(U1))
   polygon(xx, yy1, border=8, col=gray(.6, alpha=.2) ) 
   
   lines(fore$pred, col="red", type="o")
 # lines(U, col="red", lty=6)
 # lines(L, col="red", lty=6) 
 # lines(U1, col="blue", lty=6)
 # lines(L1, col="blue", lty=6) 
#
  return(fore)
}


