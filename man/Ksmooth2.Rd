\name{Ksmooth2}
\alias{Ksmooth2}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Kalman Filter and Smoother - General model, may have correlated errors
%%  ~~function to do ... ~~
}
\description{Returns the filtered and smoothed values  for the state-space model. This is the smoother companion to Kfilter2.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Ksmooth2(num, y, A, mu0, Sigma0, Phi, Ups, Gam, Theta, cQ, cR, 
          S, input)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{data matrix, vector or time series
%%     ~~Describe \code{y} here~~
}
  \item{A}{time-varying observation matrix, an array with \code{dim=c(q,p,n)}
%%     ~~Describe \code{A} here~~
}
  \item{mu0}{initial state mean
%%     ~~Describe \code{mu0} here~~
}
  \item{Sigma0}{initial state covariance matrix
%%     ~~Describe \code{Sigma0} here~~
}
  \item{Phi}{state transition matrix
%%     ~~Describe \code{Phi} here~~
}
  \item{Ups}{state input matrix; use \code{Ups = 0} if not needed
%%     ~~Describe \code{Ups} here~~
}
  \item{Gam}{observation input matrix; use \code{Gam = 0} if not needed
%%     ~~Describe \code{Gam} here~~
}
  \item{Theta}{state error pre-matrix
%%     ~~Describe \code{Theta} here~~
}
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
%%     ~~Describe \code{cQ} here~~
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
%%     ~~Describe \code{cR} here~~
}
  \item{S}{covariance matrix of state and observation errors
%%     ~~Describe \code{S} here~~
}
  \item{input}{matrix or vector of inputs having the same row dimension as y; use \code{input = 0} if not needed
%%     ~~Describe \code{input} here~~
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as 
 \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively, which allows more flexibility.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{xs }{state smoothers}
\item{Ps }{smoother mean square error}
\item{J }{the J matrices}
\item{xp }{one-step-ahead prediction of the state}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{Kn }{last value of the gain}
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}\cr

See also \url{http://www.stat.pitt.edu/stoffer/tsa4/chap6.htm} for an explanation of the difference between levels 0, 1, and 2.
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%%\note{
%%%%  ~~further notes~~
%%}
%%
%%%% ~Make other sections like Warning with \section{Warning }{....} ~
%%
%%\seealso{
%%%% ~~objects to See Also as \code{\link{help}}, ~~~
%%}
%% \examples{
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,Theta,cQ,cR,S,input){
%%   #
%%   ######## Reference Property 6.5 in Section 6.6 ###########
%%   # num is the number of observations
%%   # y is the data matrix (num by q)
%%   # mu0 initial mean is converted to mu1 in code
%%   # Sigma0 initial var is converted to Sigma1 in code
%%     #mu1= E(x_1) = x_1^0 = Phi\%*\%mu0 + Ups\%*\%input1 
%%     # Sigma1 = var(x_1)= P_1^0 =  Phi\%*\%Sigma0\%*\%t(Phi)+Theta\%*\%Q\%*\%t(Theta)
%%   # input has to be a matrix (num by r) - similar to obs y
%%   # set Ups or Gam or input to 0 if not used
%%   # Must give Cholesky decomp: cQ=chol(Q), cR=chol(R)  
%% Q=t(cQ)\%*\%cQ
%% R=t(cR)\%*\%cR 
%%   #
%%  Phi=as.matrix(Phi)
%%  pdim=nrow(Phi) 
%%  y=as.matrix(y)
%%  qdim=ncol(y)
%%  rdim=ncol(as.matrix(input))
%%   if (max(abs(Ups))==0) Ups = matrix(0,pdim,rdim)
%%   if (max(abs(Gam))==0) Gam = matrix(0,qdim,rdim)
%%  ut=matrix(input,num,rdim)
%%  xp=array(NA, dim=c(pdim,1,num))      # xp=x_t^{t-1}          
%%  Pp=array(NA, dim=c(pdim,pdim,num))   # Pp=P_t^{t-1}
%%  xf=array(NA, dim=c(pdim,1,num))      # xf=x_t^{t} 
%%  Pf=array(NA, dim=c(pdim,pdim,num))   # Pf=P_t^{t}
%%  Gain=array(NA, dim=c(pdim,qdim,num))
%%  innov=array(NA, dim=c(qdim,1,num))   # innovations
%%  sig=array(NA, dim=c(qdim,qdim,num))  # innov var-cov matrix
%%  like=0                               # -log(likelihood)
%%  xp[,,1]=Phi\%*\%mu0 + Ups\%*\%as.matrix(ut[1,],rdim)   # mu1
%%  Pp[,,1]=Phi\%*\%Sigma0\%*\%t(Phi)+Theta\%*\%Q\%*\%t(Theta)  #Sigma1
%%  for (i in 1:num){
%% 	B = matrix(A[,,i], nrow=qdim, ncol=pdim) 
%%    innov[,,i] = y[i,]-B\%*\%xp[,,i]-Gam\%*\%as.matrix(ut[i,],rdim)
%%     sigma = B\%*\%Pp[,,i]\%*\%t(B)+R 
%%     sigma=(t(sigma)+sigma)/2     # make sure sig is symmetric
%%    sig[,,i]=sigma
%%     siginv=solve(sigma)
%%    Gain[,,i]=(Phi\%*\%Pp[,,i]\%*\%t(B)+Theta\%*\%S)\%*\%siginv 
%%     K=as.matrix(Gain[,,i], nrow=qdim, ncol=pdim)
%%    xf[,,i]=xp[,,i]+ Pp[,,i]\%*\%t(B)\%*\%siginv\%*\%innov[,,i]
%%    Pf[,,i]=Pp[,,i] - Pp[,,i]\%*\%t(B)\%*\%siginv\%*\%B\%*\%Pp[,,i] 
%%      sigma=matrix(sigma, nrow=qdim, ncol=qdim)
%%    like= like + log(det(sigma)) + t(innov[,,i])\%*\%siginv\%*\%innov[,,i]
%%    if (i==num) break
%%    xp[,,i+1]=Phi\%*\%xp[,,i] + Ups\%*\%as.matrix(ut[i+1,],rdim) + K\%*\%innov[,,i]
%%    Pp[,,i+1]=Phi\%*\%Pp[,,i]\%*\%t(Phi)+ Theta\%*\%Q\%*\%t(Theta) - K\%*\%sig[,,i]\%*\%t(K)
%%   }	 
%%   like=0.5*like
%%   list(xp=xp,Pp=Pp,xf=xf,Pf=Pf, K=Gain,like=like,innov=innov,sig=sig)
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 