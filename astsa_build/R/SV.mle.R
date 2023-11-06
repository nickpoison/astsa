SV.mle <- 
function(returns, gamma=0, phi=.95, sQ=.1, alpha=NULL, sR0=1, mu1=-3, sR1=2, rho=NULL,
           feedback=FALSE)
{

if (!is.null(rho)) { if (abs(rho)>=1) rho=0 } # check rho is corr if used

del = returns    # del holds original returns
returns[abs(returns) < 10^-8] = jitter(returns[abs(returns) < 10^-8], amount=10^-5)  # jitter 0s

y = log(returns^2)
num = length(y)
if (is.null(alpha)) alpha=mean(y)

if (feedback){      # include feedback

if (is.null(rho)){
 init.par = c(gamma, phi, sQ, alpha, sR0, mu1, sR1)
 # Innovations Likelihood
 Linn = function(para){
   gamma=para[1]; phi=para[2]; sQ=para[3]
   alpha=para[4]; sR0=para[5]; mu1=para[6]; sR1=para[7]
   sv = .SVfilter(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho=0)
    k=k+1; setTxtProgressBar(pb,k)
  return(sv$like)    }
} else {
 init.par = c(gamma, phi, sQ, alpha, sR0, mu1, sR1, rho)
 # Innovations Likelihood
 Linn = function(para){
   gamma=para[1]; phi=para[2]; sQ=para[3]
   alpha=para[4]; sR0=para[5]; mu1=para[6]; sR1=para[7]; rho=para[8]
   sv = .SVfilter(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho)
     k=k+1; setTxtProgressBar(pb,k)
  return(sv$like)    }
}

pb = txtProgressBar(min = 0, max = 100, initial = 0, style = 2, char = ' ')
k=0


# Estimation
(est = optim(init.par, Linn, NULL, method='BFGS', 
       hessian=TRUE, control=list(trace=1,REPORT=5)))
close(pb)
SE = sqrt(diag(solve(est$hessian)))
u = rbind(estimates=est$par, SE)
 if (is.null(rho))  { 
  colnames(u)=c('gamma', 'phi','sQ','alpha','sigv0','mu1','sigv1')
  } else {
  colnames(u)=c('gamma','phi','sQ','alpha','sigv0','mu1','sigv1','rho')
 }
cat("<><><><><><><><><><><><><><>") 
cat("\n", "\n")
cat("Coefficients:", "\n")
print(round(u, 4))
cat("\n")



# Graphics   (need filters at the estimated parameters)
gamma = est$par[1]; phi=est$par[2]; sQ=est$par[3]; 
alpha=est$par[4]; sR0=est$par[5]; mu1=est$par[6]; sR1=est$par[7]
rho = ifelse(is.null(rho), 0, est$par[8])
sv = .SVfilter(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho)

old.par <- par(no.readonly = TRUE)

layout(matrix(1:2, 2), height=c(3,2))
# data/volatility plot
tapp = tsp(y)
tsxp = ts(sv$Xp, start=tapp[1], frequency=tapp[3] )
tsPp = ts(sv$Pp, start=tapp[1], frequency=tapp[3] )
Low = min(10*returns, tsxp-2*sqrt(tsPp))
Upp = max(10*returns, tsxp+2*sqrt(tsPp))+.2
tsplot(cbind(10*returns, tsxp), col=astsa.col(c(2,4),.7), spag=TRUE, ylim=c(Low,Upp), gg=TRUE,
    margins=c(0,-.6,0,0)+.2)
xx = c(time(y), rev(time(y)))
yy = c(tsxp-2*sqrt(tsPp), rev(tsxp+2*sqrt(tsPp)))
 polygon(xx, yy, border=NA, col=astsa.col(4, alpha = .2))
legend('topright', legend=c('log-volatility', 'returns (\u00D7 10)'), lty=1, col=c(4,astsa.col(2,.9)), bty='n')

# densities plot (f is chi-sq, fm is fitted mixture)
x  = seq(-15,6,by=.01)
f  = exp(-.5*(exp(x)-x))/(sqrt(2*pi))
f0 = exp(-.5*(x^2)/sR0^2)/(sR0*sqrt(2*pi))
f1 = exp(-.5*(x-mu1)^2/sR1^2)/(sR1*sqrt(2*pi))
fm = .5*f0 +.5*f1
Upp = max(f, fm)
tsplot(x, f, yaxt='n', ylab=NA, col=4, ylim=c(0,Upp), gg=TRUE, xlab=NA, margins=c(-.6,-.6,0,0)+.2) 
lines(x, fm, lty=5, lwd=2, col=5)
cs = expression(log~chi[1]^2)
legend('topleft', legend=c(cs, 'normal mixture' ), lty=c(1,5), lwd=1:2, col=4, bty='n')
on.exit(par(old.par))

output = list(PredLogVol=tsxp, RMSPE=sqrt(tsPp), Coefficients=t(u))
invisible(output)

# end with feedback
} else {  # no feedback
init.par = c(phi, sQ, alpha, sR0, mu1, sR1)

pb = txtProgressBar(min = 0, max = 100, initial = 0, style = 2, char = ' ')
k=0
# Innovations Likelihood
Linn = function(para){
  phi=para[1]; sQ=para[2]; alpha=para[3]
  sR0=para[4]; mu1=para[5]; sR1=para[6]
  sv = .SVfilter(num, y, del, gamma=0, phi, sQ, alpha, sR0, mu1, sR1, rho=0)
    k=k+1; setTxtProgressBar(pb,k)
  return(sv$like)    }

# Estimation
(est = optim(init.par, Linn, NULL, method='BFGS', hessian=TRUE, control=list(trace=1,REPORT=5)))
close(pb)
SE = sqrt(diag(solve(est$hessian)))
u = rbind(estimates=est$par, SE)
colnames(u)=c('phi','sQ','alpha','sigv0','mu1','sigv1')
cat("<><><><><><><><><><><><><><>") 
cat("\n", "\n")
cat("Coefficients:", "\n")
print(round(u, 4))
cat("\n")

# Graphics   (need filters at the estimated parameters)
phi=est$par[1]; sQ=est$par[2]; alpha=est$par[3]
sR0=est$par[4]; mu1=est$par[5]; sR1=est$par[6]
sv = .SVfilter(num, y, del, gamma=0, phi, sQ, alpha, sR0, mu1, sR1, rho=0)

old.par <- par(no.readonly = TRUE)

layout(matrix(1:2, 2), height=c(3,2))
# data/volatility plot
tapp = tsp(y)
tsxp = ts(sv$Xp, start=tapp[1], frequency=tapp[3] )
tsPp = ts(sv$Pp, start=tapp[1], frequency=tapp[3] )
Low = min(10*returns, tsxp-2*sqrt(tsPp))
Upp = max(10*returns, tsxp+2*sqrt(tsPp))
tsplot(cbind(10*returns, tsxp), col=c(astsa.col(2,.5),4), spag=TRUE, ylim=c(Low,Upp))
xx = c(time(y), rev(time(y)))
yy = c(tsxp-2*sqrt(tsPp), rev(tsxp+2*sqrt(tsPp)))
 polygon(xx, yy, border=NA, col=astsa.col(4, alpha = .2))
legend('topright', legend=c('log-volatility', 'Returns (\u00D7 10)'), lty=1, col=c(4,astsa.col(2,.6)), bty='n')

# densities plot (f is chi-sq, fm is fitted mixture)
x  = seq(-15,6,by=.01)
f  = exp(-.5*(exp(x)-x))/(sqrt(2*pi))
f0 = exp(-.5*(x^2)/sR0^2)/(sR0*sqrt(2*pi))
f1 = exp(-.5*(x-mu1)^2/sR1^2)/(sR1*sqrt(2*pi))
fm = .5*f0 +.5*f1
Upp = max(f, fm)
tsplot(x, f, ylab='density', col=4, ylim=c(0,Upp))  
 lines(x, fm, lty=5, lwd=2, col=5)
cs = expression(log~chi[1]^2)
legend('topleft', legend=c(cs, 'normal mixture' ), lty=c(1,5), lwd=1:2, col=4)
on.exit(par(old.par))

output = list(PredLogVol=tsxp, RMSPE=sqrt(tsPp), Coefficients=t(u))
invisible(output)



}   # end no feedback

}  # the end

.SVfilter = function(num, y, del, gamma, phi, sQ, alpha, sR0, mu1, sR1, rho){
 
# Initialize
 Q  = sQ^2
 R0 = sR0^2
 R1 = sR1^2
 Xp = c(0)            #  x_t+1^t
 Pp = c(phi^2 + Q)    #  P_t+1^t

 pi1  = .5    # initial mix probs
 pi0  = .5
 pit1 = .5 
 pit0 = .5 
 like =  0    # -log(likelihood)

#
for (i in 2:num){
  sig1 = Pp[i-1] + R1
  sig0 = Pp[i-1] + R0
  k1   = (phi*Pp[i-1] + abs(sQ*sR1)*rho)/sig1   
  k0   = (phi*Pp[i-1] + abs(sQ*sR0)*rho)/sig0
  e1   = y[i] - Xp[i-1] - mu1 - alpha
  e0   = y[i] - Xp[i-1] - alpha
  den1 = (1/sqrt(sig1))*exp(-.5*e1^2/sig1)
  den0 = (1/sqrt(sig0))*exp(-.5*e0^2/sig0)
  denom = pi1*den1 + pi0*den0
  pit1  = pi1*den1/denom
  pit0  = pi0*den0/denom
#  
  Xp[i] = gamma*del[i-1] + phi*Xp[i-1] + pit0*k0*e0 + pit1*k1*e1
  Pp[i] = (phi^2)*Pp[i-1] + Q - pit0*(k0^2)*sig0 - pit1*(k1^2)*sig1
  Pp[i][Pp[i]<0] = 10^-8   # fix for roundoff errors
  like = like - 0.5*log(pi1*den1 + pi0*den0)
 }
 list(Xp=Xp, Pp=Pp, like=like)
}