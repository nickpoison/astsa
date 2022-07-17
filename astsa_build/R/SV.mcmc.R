SV.mcmc <-
function(y, nmcmc=1000, burnin=100,  init=NULL, hyper=NULL, tuning=NULL, sigma_MH=NULL, npart=NULL, mcmseed=NULL){
  # Input:
  #   nmcmc - number of MCMC
  #   burnin - number of burnin
  #   y - measurements
  #   init - initial values of (phi, sigma, beta)
  #   npart - number of particles
  #   hyper - hyperparameters for bivariate normal (phi, q), user inputs (mu_phi, mu_q, sigma_phi, sigma_q, rho)
  #   sigma_MH - covariance matrix for Random Walk Metropolis Hastings
  #   mcmseed - seed for mcmc
  
  # Output:
  #   phi - sampled phi
  #   sigma - sampled state stdev
  #   beta - sampled beta 
  #   X - sampled log-volatility
  #   time2run - running time
  #   acp - acceptence rate of Random Walk Metropolis Hastings
  
  if (is.null(init))   init       = c(0.9, 0.5, .1)   # phi, q, beta
  if (is.null(hyper))  hyper      = c(0.9, 0.5, 0.075, 0.1, -0.25)
  if (is.null(tuning)) tuning     =.03
  if (is.null(sigma_MH)) sigma_MH = tuning * matrix(c(1,-.25,-.25,1),nrow=2,ncol=2)
  if (is.null(npart)) npart       = 10
  if (is.null(mcmseed)) mcmseed   = 90210
  
  numMCMC = nmcmc+burnin
  N = npart
  set.seed(mcmseed)
  pb = txtProgressBar(min = 0, max = numMCMC, initial = 0, style=3)  # progress bar

  
  T = length(y)
  X = matrix(0,numMCMC,T)
  q = rep(0,numMCMC)             # q = state variance ## W(t) ~ iid N(0,q)
  phi = rep(0,numMCMC)           # phi-values
  beta = rep(0,numMCMC)
  

  # Initialize the parameters
   phi[1]  = init[1]
     q[1]  = init[2]^2   
  beta[1]  = init[3]

  
  # hyperparameters
  mu_phi = hyper[1]
  mu_q = hyper[2]^2
  sigma_phi = hyper[3]
  sigma_q = hyper[4]
  rho = hyper[5]   
  mu_MH = c(0,0)   
  sigma_MH = sigma_MH  
  
  
  # Initialize the state by running a PF
  u = .cpf_as_sv(y, phi[1], q[1],  N,  X[1,], beta[1])   #  changed from X to X[1,]
  particles = u$x           # returned particles
  w = u$w                   # returned weights
  # Draw J
  J = which( (runif(1)-cumsum(w[,T])) < 0 )[1]
  X[1,] = scale(particles[J,], center=TRUE, scale=FALSE)        

  ptm <- proc.time()
  # Run MCMC loop
  for(k in 2:numMCMC){
    # Sample the parameters (phi, sqrt_q) ~ bivariate normal Random Walk Metropolis Hastings
    parms = cbind(phi[k-1], sqrt(q[k-1]))
    parms_star = parms + MASS::mvrnorm(1, mu_MH, sigma_MH)
    
    while(parms_star[2]^2 < 2e-2|parms_star[1]>2){
      parms_star = parms + MASS::mvrnorm(1, mu_MH, sigma_MH)
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
old.par = par(no.readonly = TRUE)
parms   = cbind(phi, sigma, beta)
names   = c(expression(phi), expression(sigma), expression(beta))
colnames(parms) = names
lwr     = min(min(acf(phi)$acf), min(acf(sigma)$acf), min(acf(beta)$acf))
culer   = c(6,4,3)
par(mfcol=c(3,3))
for (i in 1:3){
  tsplot(parms[,i], main=names[i], col=culer[i], ylab='', xlab='Index')
  acf1(parms[,i],   main='', col=culer[i], ylim=c(lwr,1))
  hist(parms[,i],   main='', xlab='', col=astsa.col(culer[i], .4))
  abline(v=c(stats::quantile(parms[,i], probs=c(.025,.5,.975))), col=8)
}  
readline(prompt="Press [enter] to continue - Press [esc] to stop")
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

 argmnts = list(nmcmc=nmcmc, burnin=burnin, init=init,  hyper=hyper, tuning=tuning, sigma_MH=sigma_MH, npart=npart, mcmseed=mcmseed)
 return(list(phi=phi, sigma=sigma, beta=beta, log.vol=X, options=argmnts))
}
