\name{EM0}
\alias{EM0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{EM Algorithm for Time Invariant State Space Models 
%%  ~~function to do ... ~~
}
\description{Estimation of the parameters in the model (6.1)--(6.2) via the EM algorithm.  
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
EM0(num, y, A, mu0, Sigma0, Phi, cQ, cR, max.iter = 50, tol = 0.01)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{observation vector or time series
%%     ~~Describe \code{y} here~~
}
  \item{A}{time-invariant observation matrix
%%     ~~Describe \code{A} here~~
}
  \item{mu0}{initial state mean vector
%%     ~~Describe \code{mu0} here~~
}
  \item{Sigma0}{initial state covariance matrix
%%     ~~Describe \code{Sigma0} here~~
}
  \item{Phi}{state transition matrix
%%     ~~Describe \code{Phi} here~~
}
  \item{cQ}{Cholesky-like decomposition of state error covariance matrix Q -- see details below
%%     ~~Describe \code{cQ} here~~
}
  \item{cR}{Cholesky-like decomposition of state error covariance matrix R -- see details below
%%     ~~Describe \code{cR} here~~
}
  \item{max.iter}{maximum number of iterations
%%     ~~Describe \code{max.iter} here~~
}
  \item{tol}{relative tolerance for determining convergence
%%     ~~Describe \code{tol} here~~
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as 
 \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{Phi }{Estimate of Phi}
\item{Q }{Estimate of Q}
\item{R }{Estimate of R}
\item{mu0 }{Estimate of initial state mean}
\item{Sigma0 }{Estimate of initial state covariance matrix}
\item{like }{-log likelihood at each iteration}
\item{niter }{number of iterations to convergence}
\item{cvg }{relative tolerance at convergence}
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
%% \examples{
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(num,y,A,mu0,Sigma0,Phi,cQ,cR,max.iter=50,tol=.01){
%% #
%% # Note: Q and R are given as Cholesky decomps
%% #       cQ=chol(Q), cR=chol(R)
%% #
%%    Phi=as.matrix(Phi)
%%    pdim=nrow(Phi)
%%    y=as.matrix(y)
%%    qdim=ncol(y)
%%    cvg=1+tol
%%    like=matrix(0,max.iter,1)
%%    cat("iteration","   -loglikelihood", "\n")
%% #----------------- start EM -------------------------
%% for(iter in 1:max.iter){ 
%%   ks=Ksmooth0(num,y,A,mu0,Sigma0,Phi,cQ,cR)
%%   like[iter]=ks$like
%%   cat("   ",iter, "        ", ks$like, "\n")
%%   if(iter>1) cvg=(like[iter-1]-like[iter])/abs(like[iter-1])
%%   if(cvg<0) stop("Likelihood Not Increasing")
%%   if(abs(cvg)<tol) break
%% # Lag-One Covariance Smoothers 
%%   Pcs=array(NA, dim=c(pdim,pdim,num))     # Pcs=P_{t,t-1}^n
%%   eye=diag(1,pdim)
%%   Pcs[,,num]=(eye-ks$Kn\%*\%A)\%*\%Phi\%*\%ks$Pf[,,num-1]
%%    for(k in num:3){
%%    Pcs[,,k-1]=ks$Pf[,,k-1]\%*\%t(ks$J[,,k-2])+
%%            ks$J[,,k-1]\%*\%(Pcs[,,k]-Phi\%*\%ks$Pf[,,k-1])\%*\%t(ks$J[,,k-2])}
%%    Pcs[,,1]=ks$Pf[,,1]\%*\%t(ks$J0)+
%%            ks$J[,,1]\%*\%(Pcs[,,2]-Phi\%*\%ks$Pf[,,1])\%*\%t(ks$J0)       
%% # Estimation
%%     S11 = ks$xs[,,1]\%*\%t(ks$xs[,,1]) + ks$Ps[,,1]
%%     S10 = ks$xs[,,1]\%*\%t(ks$x0n) + Pcs[,,1]
%%     S00 = ks$x0n\%*\%t(ks$x0n) + ks$P0n
%%     R=matrix(0,qdim,qdim)
%%   for(i in 2:num){
%%     S11 = S11 + ks$xs[,,i]\%*\%t(ks$xs[,,i]) + ks$Ps[,,i]
%%     S10 = S10 + ks$xs[,,i]\%*\%t(ks$xs[,,i-1]) + Pcs[,,i]
%%     S00 = S00 + ks$xs[,,i-1]\%*\%t(ks$xs[,,i-1]) + ks$Ps[,,i-1]
%%       u = y[i,]-A\%*\%ks$xs[,,i]
%%     R = R + u\%*\%t(u) + A\%*\%ks$Ps[,,i]\%*\%t(A)
%%   }
%%   Phi=S10\%*\%solve(S00)
%%   Q=(S11-Phi\%*\%t(S10))/num
%%    Q=(t(Q)+Q)/2        # make sure symmetric
%%   cQ=chol(Q)
%%   R=R/num
%%   cR=chol(R)
%%   mu0=ks$x0n
%% # mu0=mu0              # uncomment this line to keep mu0 fixed
%%   Sigma0=ks$P0n
%% # Sigma0=Sigma0        # uncomment this line to keep Sigma0 fixed
%%   }
%%  list(Phi=Phi,Q=Q,R=R,mu0=mu0,Sigma0=Sigma0,like=like[1:iter],niter=iter,cvg=cvg)
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts}
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 