SVfilter = function(num,y,phi0,phi1,sQ,alpha,sR0,mu1,sR1){
  #
  #  see: http://www.stat.pitt.edu/stoffer/booty.pdf  section 2.2 for details
  #  y is log(return^2)
  #  model is   h_t+1 = phi0 + phi1*h_t + w_t
  #               y_t = alpha + h_t + v_t  
  #             v_t is a mixture, see (14) of the above reference
  #
  #  
  #  
# Initialize
y=as.matrix(y)
Q=sQ^2
R0=sR0^2
R1=sR1^2
# initial values
xp=matrix(0,num,1)        # = h_t+1^t
Pp=matrix(0,num,1)        # = P_t+1^t
xp[1]= 0                  # = h_1^0   | E(h_0) = mu 0 = 0     initial conditions
Pp[1]= phi1^2 + Q         # = P_1^0   | var(h_0) = Sigma0 = 1 
pi1=.5                    # initial mix probs
pi0=.5
pit1=.5                 
pit0=.5               
like=0                     # -log(likelihood)
#
for (i in 2:num){
  sig1 = Pp[i-1]+R1     #innov var
  sig0 = Pp[i-1]+R0 
  k1 = phi1*Pp[i-1]/sig1
  k0 = phi1*Pp[i-1]/sig0
  e1 = y[i]-xp[i-1]-mu1-alpha
  e0 = y[i]-xp[i-1]-alpha
  den1 = (1/sqrt(sig1))*exp(-.5*e1^2/sig1)
  den0 = (1/sqrt(sig0))*exp(-.5*e0^2/sig0)
  denom = pi1*den1+pi0*den0
  pit1 = pi1*den1/denom
  pit0 = pi0*den0/denom
#  
  xp[i] = phi0 + phi1*xp[i-1] + pit0*k0*e0 + pit1*k1*e1
  Pp[i] = (phi1^2)*Pp[i-1] + Q - pit0*(k0^2)*sig0 - pit1*(k1^2)*sig1
#
  like = like - 0.5*log(pi1*den1 + pi0*den0)
 }
 list(xp=xp,Pp=Pp,like=like)
}

