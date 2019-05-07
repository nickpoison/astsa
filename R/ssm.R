ssm <-
function(y, A, phi, alpha, sigw, sigv, fixphi=FALSE){
strt = stats::tsp(as.ts(y))[1]
frq  = stats::tsp(as.ts(y))[3]
num = length(y)
if (num < 20) { stop("This script requires at least 20 observations") }
x00 = mean(y[1:5])
P00 = stats::var(jitter(y[1:5])) 
A = array(A, dim=c(1,1,num))
# function to calc likelihood
Linn=function(para){
  if (fixphi){ phi=phi; alpha = para[1]; sigw = para[2];  sigv = para[3] 
  } else {phi=para[1]; alpha = para[2];   sigw = para[3];  sigv = para[4]}
 kf = Kfilter1(num,y,A,x00,P00,phi,alpha,0,sigw,sigv,rep(1,num))
 return(kf$like) 
}
# Estimation
if (fixphi){ init.par = c(alpha,sigw,sigv) 
 } else {init.par = c(phi,alpha,sigw,sigv)
 }
est = optim(init.par, Linn, NULL, method="BFGS", hessian=TRUE, control=list(trace=1,REPORT=1)) 
SE = sqrt(diag(solve(est$hessian))) 
#
if (fixphi){ phat = c(phi, est$par)
} else {phat = est$par}
# run filter /smoother with estimates
ks = Ksmooth1(num,y,A,x00,P00,phat[1],phat[2],0,phat[3],phat[4],rep(1,num))
Xp = ts(as.vector(ks$xp), start=strt, frequency=frq) 
Pp = ts(as.vector(ks$Pp), start=strt, frequency=frq)
Xf = ts(as.vector(ks$xf), start=strt, frequency=frq) 
Pf = ts(as.vector(ks$Pf), start=strt, frequency=frq)
Xs = ts(as.vector(ks$xs), start=strt, frequency=frq) 
Ps = ts(as.vector(ks$Ps), start=strt, frequency=frq)
estimate = est$par 
u = cbind(estimate, SE) 
if (fixphi){rownames(u)=c("alpha", "sigw", "sigv"); u[2:3,1] = abs(u[2:3,1]) 
 } else { rownames(u)=c("phi", "alpha", "sigw", "sigv"); u[3:4,1] = abs(u[3:4,1])
 }
print(u)
timserout = list(Xp=Xp, Pp=Pp, Xf=Xf, Pf=Pf, Xs=Xs, Ps=Ps)
return(invisible(timserout))
}
