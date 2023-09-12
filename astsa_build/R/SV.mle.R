SV.mle <- 
function(returns, phi1=.95, sQ=.1, alpha=NULL, sR0=1, mu1=-3, sR1=2){


if (any(returns < 10^-8)) returns = jitter(returns) 
y = log(returns^2)

num = length(y)
if (is.null(alpha)) alpha=mean(y)
init.par = c(phi1, sQ, alpha, sR0, mu1, sR1)

pb = txtProgressBar(min = 0, max = 100, initial = 0, style = 2, char = ' ')
k=0
# Innovations Likelihood
Linn = function(para){
  phi1=para[1]; sQ=para[2]; alpha=para[3]
  sR0=para[4]; mu1=para[5]; sR1=para[6]
  sv = SVfilter(num, y, phi0=0, phi1, sQ, alpha, sR0, mu1, sR1)
    k=k+1; setTxtProgressBar(pb,k)
  return(sv$like)    }

# Estimation
(est = optim(init.par, Linn, NULL, method='BFGS', hessian=TRUE, control=list(trace=1,REPORT=5)))
close(pb)
SE = sqrt(diag(solve(est$hessian)))
u = cbind(estimates=est$par, SE)
rownames(u)=c('phi1','sQ','alpha','sigv0','mu1','sigv1')
cat("<><><><><><><><><><><><><><>") 
cat("\n", "\n")
cat("Coefficients:", "\n")
print(round(u, 4))
cat("\n")


# Graphics   (need filters at the estimated parameters)
phi0=0; phi1=est$par[1]; sQ=est$par[2]; alpha=est$par[3]
sR0=est$par[4]; mu1=est$par[5]; sR1=est$par[6]
sv = SVfilter(num,y,phi0,phi1,sQ,alpha,sR0,mu1,sR1)

layout(matrix(1:2, 2), height=c(3,2))
# data/volatility plot
tapp = tsp(y)
tsxp = ts(sv$xp, start=tapp[1], frequency=tapp[3] )
tsPp = ts(sv$Pp, start=tapp[1], frequency=tapp[3] )
Low = min(10*returns, tsxp-2*sqrt(tsPp))
Upp = max(10*returns, tsxp+2*sqrt(tsPp))
tsplot(cbind(10*returns, tsxp), col=c(astsa.col(2,.4),4), spag=TRUE, ylim=c(Low,Upp))
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
tsplot(x, f, ylab='density', col=4)  
 lines(x, fm, lty=5, lwd=2, col=5)
cs = expression(log~chi[1]^2)
legend('topleft', legend=c(cs, 'normal mixture' ), lty=c(1,5), lwd=1:2, col=4)

invisible(cbind(PredLogVol=tsxp, RMSPE=sqrt(tsPp)))
}