###############################################################################
#     PGAS for an SV model.        
#      X(t) = phi * X(t-1) + sigma*W(t);    W(t) ~ iid N(0,1)  
#      Y(t) = beta*exp{X(t)/2}V(t);         V(t) ~ iid N(0,1)   ind of Ws  
###############################################################################

SV.mcmc = function(y, nmcmc=1000, burnin=100, init=NULL, hyper=NULL, tuning=NULL, 
                    sigma_MH=NULL, npart=NULL, mcmseed=NULL){
  # Input:
  #   y - returns
  #   nmcmc - number of MCMC
  #   burnin - number of burnin
  #   init - initial values of (phi, sigma, beta)
  #   npart - number of particles
  #   hyper - hyperparameters for bivariate normal (phi, q), user inputs (mu_phi, mu_q, sigma_phi, sigma_q, rho)
  #   tuning - tuning parameter for RW Metropolis
  #   sigma_MH - covariance matrix for Random Walk Metropolis Hastings = tuning * sigma_MH
  #   mcmseed - seed for mcmc
  
  # Output:
  #   phi - sampled phi
  #   sigma - sampled state stdev
  #   beta - sampled beta 
  #   X - sampled log-volatility
  #   time2run - running time
  #   acp - acceptence rate of Random Walk Metropolis Hastings
  #   ESS - effective sample size
  
  if (NCOL(y) > 1) stop("univariate time series only")
  if (is.null(init))   init       = c(0.9, 0.5, .1)   # phi, sigma, beta
  if (is.null(hyper))  hyper      = c(0.9, 0.5, 0.075, 0.3, -0.25)
  if (is.null(tuning)) tuning     =.03
  if (is.null(sigma_MH)) sigma_MH = matrix(c(1,-.25,-.25,1),nrow=2,ncol=2)
  if (is.null(npart)) npart       = 10
  if (is.null(mcmseed)) mcmseed   = 90210
  
  numMCMC = nmcmc+burnin
  N = npart
  set.seed(mcmseed)
  pb = txtProgressBar(min = 0, max = numMCMC, initial = 0, style=3)  # progress bar

  T = length(y)
  X = matrix(0,numMCMC,T)
  q = rep(0,numMCMC)             # q = state variance ## W(t) ~ iid N(0,q)
  phi = rep(0,numMCMC)
  beta = rep(0,numMCMC)

  # Initialize the parameters
   phi[1]  = init[1]
     q[1]  = init[2]^2
  beta[1]  = init[3]

  
  # hyper and MH parameters
  mu_phi = hyper[1]
  mu_q = hyper[2]^2
  sigma_phi = hyper[3]
  sigma_q = hyper[4]^2
  rho = hyper[5]
  mu_MH = c(0,0)
   sigtemp = sigma_MH  # holds the matrix for output
  sigma_MH = tuning * sigma_MH 
  
  
  # Initialize the state by running a PF
  u = .cpf_as_sv(y, phi[1], q[1],  N,  X[1,], beta[1])    
  particles = u$x           # returned particles
  w = u$w                   # returned weights
  # Draw J
  J = which( (runif(1)-cumsum(w[,T])) < 0 )[1]
  X[1,] = scale(particles[J,], center=TRUE, scale=FALSE)        

  ptm <- proc.time()
  # Run MCMC loop
  for(k in 2:numMCMC){
    # Sample the parameters (phi, sigma=sqrt_q) ~ bivariate normal RW Metropolis  
    parms = cbind(phi[k-1], sqrt(q[k-1]))
    parms_star = parms + .rmvnorm(mu_MH, sigma_MH)
    
    while(parms_star[2]^2 < 2e-2|parms_star[1]>2){
      parms_star = parms + .rmvnorm(mu_MH, sigma_MH)
    }
    
    g_star = .log_g_func(parms_star, mu_phi, sigma_phi, mu_q, sigma_q, rho, X[(k-1),])
    g_old  = .log_g_func(parms, mu_phi, sigma_phi, mu_q, sigma_q, rho, X[(k-1),])
    g_diff = g_star - g_old
    if(is.na(g_diff)){
      phi[k] = parms[1]
      q[k] = parms[2]^2
    }else {
      if(log(runif(1)) < g_diff){
        phi[k] = parms_star[1]
        q[k] = parms_star[2]^2
      }else{
        phi[k] = parms[1]
        q[k] = parms[2]^2
      }
    }
    
    
    
    # Sample beta, prior unif, N(0,b)=N(0,inf)
     atemp = T/2 - 1
     btemp = sum(y^2/exp(X[k-1,]))/2
     beta[k] = sqrt(1/rgamma(1, atemp, btemp))
    
    # Sample beta, prior IG(a,b)
    # a = .001
    # b = .001
    #   atemp = T/2 + a
    #   btemp = sum(y^2/exp(X[k-1,]))/2 + b
    #   beta[k] = sqrt(1/rgamma(1, atemp, btemp))
    
    # Run CPF-AS
    u = .cpf_as_sv(y, phi[k], q[k], N, X[k-1,], beta[k])
    particles = u$x           # returned particles
    w = u$w                   # returned weight
    # Draw J (extract a particle trajectory)
    J = which( (runif(1)-cumsum(w[,T])) < 0 )[1]
    X[k,] = scale(particles[J,], center=TRUE, scale=FALSE)        
     setTxtProgressBar(pb,k) 
  }#end
  close(pb)
  cat("Time to run (secs):", "\n")
  time2run = proc.time() - ptm
  print(time2run)
  
  bi = 1:burnin  
  acp = dim(table(phi[-bi]))/nmcmc*100 
  cat("The acceptance rate is: ", acp, "%", sep='', "\n", "\n")
  
  phi   = phi[-bi] 
  sigma = sqrt(q[-bi]) 
  beta  = beta[-bi]
  X     = X[-bi,]
 

# plots
legend  = graphics::legend
par     = graphics::par
abline  = graphics::abline
old.par = par(no.readonly = TRUE)
parms   = cbind(phi, sigma, beta)
names   = c(expression(phi), expression(sigma), expression(beta))
colnames(parms) = names
lwr     = min(min(acf(phi)$acf), min(acf(sigma)$acf), min(acf(beta)$acf))
culer   = c(6,4,3)


par(mfcol=c(3,3))
for (i in 1:3){
  tsplot(parms[,i], main=names[i], col=culer[i], ylab='', xlab='Index')
   ess = ESS(parms[,i])
  legend("topright", legend=paste('ESS = ', round(ess, digits=1)), adj=.1, bg='white')	
  acf1(parms[,i],   main='', col=culer[i], ylim=c(lwr,1))
  hist(parms[,i],   main='', xlab='', col=astsa.col(culer[i], .4))
  abline(v=c(stats::quantile(parms[,i], probs=c(.025,.5,.975))), col=8)
}  

cat("Press [Enter] or [Left Mouse] on the active graphic device", "\n")
par(ask=TRUE)
par(mfcol = c(1,1))
 tspar =  tsp(as.ts(y))
 mX = ts(apply(X, 2, mean), start=tspar[1], frequency=tspar[3])
 lX = ts(apply(X, 2, quantile, 0.025), start=tspar[1], frequency=tspar[3])
 uX = ts(apply(X, 2, quantile, 0.975), start=tspar[1], frequency=tspar[3])
tsplot(mX, col=4, ylab='Log Volatiltiy (%)', ylim=c(min(lX), max(uX)))
  xx=c(time(mX), rev(time(mX)))
  yy=c(lX, rev(uX))
polygon(xx, yy, border=NA, col=astsa.col(4,.2)) 
par(old.par)

# output
 argmnts = list(nmcmc=nmcmc, burnin=burnin, init=init,  hyper=hyper, tuning=tuning, sigma_MH=sigtemp, npart=npart, mcmseed=mcmseed)
 return(invisible(list(phi=phi, sigma=sigma, beta=beta, log.vol=X, options=argmnts)))

}#end

#--------------------------------------------------------------------------
.cpf_as_sv = function(y, phi, q, N, X, beta){
  # Conditional particle filter with ancestor sampling
  # Input:
  #   y - measurements
  #   phi - transition parameter
  #   q - state noise variance
  #   N - number of particles
  #   X - conditioned particles
  #   beta - state noise scale
  
  T = length(y)
  x = matrix(0, N, T); # Particles
  a = matrix(0, N, T); # Ancestor indices
  w = matrix(0, N, T); # Weights
  x[,1] = 0; # Deterministic initial condition
  x[N,1] = X[1] 
  
  for (t in 1:T){
    if(t != 1){
      ind = .resamplew(w[,t-1]) 
      ind = ind[sample.int(N)]  # default: no replacement
      t1 = t-1
      xpred = phi*x[, t1]  
      x[,t] = xpred[ind] + sqrt(q)*rnorm(N)
      x[N,t] = X[t] 
      
      # Ancestor sampling 
      logm = -1/(2*q)*(X[t]-xpred)^2 
      maxlogm = max(log(w[,t-1])+logm)
      w_as = exp(log(w[,t-1])+logm - maxlogm)
      w_as = w_as/sum(w_as) 
      ind[N] =  which( (runif(1)-cumsum(w_as)) < 0 )[1]   
      
      # Store the ancestor indices
      a[,t] = ind;
    }#end IF
 
    # Compute importance weights
    exp_now = exp(x[,t])
    temp = (y[t]/beta)^2
    logweights = -sum(log(beta)) - (1/2)*x[,t] - 0.5*(sum(temp)/exp_now) # (up to an additive constant)
    const = max(logweights); # Subtract the maximum value for numerical stability
    weights = exp(logweights-const)
    w[,t] = weights/sum(weights) # Save the normalized weights
  }#end FOR
  
  # Generate the trajectories from ancestor indices
  ind = a[,T];
  for(t in (T-1):1){
    x[,t] = x[ind,t];
    ind = a[ind,t];
  }#end
  list(x=x, w=w)
}#end
#-------------------------------------------------------------------
.resamplew = function(w){
  # multinomial resampling
  N = length(w)
  u = runif(N)    # uniform random number
  cw = cumsum(w)  # Cumulative Sum
  cw = cw/cw[N]
  ucw = c(u,cw)
  ind1 = sort(ucw, index.return=TRUE)$ix   # $ix will give the index
  ind2 = which(ind1<=N)
  i = ind2-(0:(N-1))
  return(i)
}

#-------------------------------------------------------------------
.log_g_func = function(parms, mu_phi, sigma_phi, mu_q, sigma_q, rho, x){
  # Calculate acceptance probability for RWMH
  phi = parms[1]
  q = parms[2]
  Z = cbind(x[2:T], x[1:(T-1)])  # (T-1)*2 matrix
  V = t(Z)%*%Z
  term1 = -((phi-mu_phi)^2/(sigma_phi^2) + (q-mu_q)^2/(sigma_q^2) - 2*rho*(phi-mu_phi)*(q-mu_q)/(sigma_q*sigma_phi))/(2*(1-rho^2))
  term2 = -(1-phi^2)*(x[1])^2/(2*q^2) - V[1,1]/(2*q^2) - V[2,2]*(phi^2)/(2*q^2) + V[1,2]*phi/(q^2)
  g = .25*(log((1-phi^2)^2)) - .5*T*log((q)^2) + term1 + term2
  return(g)
}


.rmvnorm = function(mu, Sigma){
z  = rnorm(length(mu))
cS = t(chol(Sigma)) 
return(drop(cS%*%z + mu))
}