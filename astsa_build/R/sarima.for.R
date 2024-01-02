sarima.for <-
function(xdata,n.ahead,p,d,q,P=0,D=0,Q=0,S=-1,tol=sqrt(.Machine$double.eps),
         no.constant=FALSE, plot=TRUE, plot.all=FALSE,
         xreg = NULL, newxreg = NULL, fixed=NULL, data=NULL, ...){ 
#

  trans = ifelse (is.null(fixed), TRUE, FALSE)
  xname = deparse(substitute(xdata))


  if(!is.null(data)) { 
     if (!is.data.frame(data)){ 
     tp = tsp(as.ts(data))
     suppressWarnings(rm(list = colnames(data),  envir = .GlobalEnv))
     attach(as.data.frame(data), warn.conflicts = FALSE)   # detached later
     xdata = ts(xdata, start = tp[1], frequency = tp[3])
  } else { 
     suppressWarnings(rm(list = colnames(data),  envir = .GlobalEnv))
     attach(data, warn.conflicts = FALSE)   # detached later
     tp =tsp(data[,1])
   }
 } 


  n = length(xdata)
  if (is.null(xreg)) {  
    constant=1:n
    xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL
    if (d==0 & D==0) {
      fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
              xreg=xmean,include.mean=FALSE,fixed=fixed,transform.pars=trans,optim.control=list(reltol=tol));
      nureg=matrix(1,n.ahead,1);  if(no.constant==TRUE) nureg=NULL
    } else if (xor(d==1, D==1) & no.constant==FALSE) {
      fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
              xreg=constant,fixed=fixed,transform.pars=trans,optim.control=list(reltol=tol));
      nureg=(n+1):(n+n.ahead)       
    } else { fitit=stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
              fixed=fixed,transform.pars=trans,optim.control=list(reltol=tol))
      nureg=NULL   
    }
  }
  if (!is.null(xreg)) {
      fitit = stats::arima(xdata, order = c(p, d, q), seasonal = list(order = c(P, 
              D, Q), period = S), xreg = xreg, fixed=fixed, transform.pars=trans)
      nureg = newxreg 
  }

if(!is.null(data)) { 
    if (!is.data.frame(data)){ detach(as.data.frame(data))
    } else { detach(data)
    }   # detach data if there
}
##--##
fore <- stats::predict(fitit, n.ahead, newxreg=nureg)
##--##

##-- graph:
  if (plot){
    lines = graphics::lines
    polygon = graphics::polygon
    xy.coords = grDevices::xy.coords
    time = stats::time
    tsp  = stats::tsp
    U  = fore$pred + 2*fore$se
    L  = fore$pred - 2*fore$se
    U1 = fore$pred + fore$se
    L1 = fore$pred - fore$se
    a  = ifelse(plot.all, 1, max(1,n-100))
    minx = min(xdata[a:n],L)
    maxx = max(xdata[a:n],U)
     t1 = xy.coords(xdata, y = NULL)$x 
     if(length(t1)<101) strt=t1[1] else strt=t1[length(t1)-100]
     t2=xy.coords(fore$pred, y = NULL)$x 
     endd=t2[length(t2)]
     if(plot.all)  {strt=time(xdata)[1]} 
     xllim=c(strt,endd)
     typel = ifelse(plot.all, 'l', 'o')
       if (!is.null(data)) { xdatanew= ts(c(xdata,fore$pred), start=tp[1], frequency=tp[3])
      } else {
      xdatanew = ts(c(xdata,fore$pred), start=tsp(xdata)[1], frequency=tsp(xdata)[3]) }
    tsplot(xdatanew, type=typel, xlim=xllim, ylim=c(minx,maxx), ylab=xname, ...)    
      xx = c(time(U), rev(time(U)))
      yy = c(L, rev(U))
     polygon(xx, yy, border=8, col=gray(.6, alpha=.2) ) 
      yy1 = c(L1, rev(U1))
     polygon(xx, yy1, border=8, col=gray(.6, alpha=.2) ) 
     lines(fore$pred, col=2, type="o")
  } 
  return(fore)
}


