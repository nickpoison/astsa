\name{Kfilter1}
\alias{Kfilter1}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Kalman Filter -  Model may be time varying or have inputs
%%  ~~function to do ... ~~
}
\description{Returns both the predicted and filtered values for a linear  state space model. Also evaluates
the likelihood at the given parameter values.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Kfilter1(num, y, A, mu0, Sigma0, Phi, Ups, Gam, cQ, cR, input)
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
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
%%     ~~Describe \code{cQ} here~~
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
%%     ~~Describe \code{cR} here~~
}
  \item{input}{matrix or vector of inputs having the same row dimension as y; use \code{input = 0} if not needed
%%     ~~Describe \code{input} here~~
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{xp }{one-step-ahead prediction of the state}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{innov }{innovation series}
\item{sig }{innovation covariances}
\item{Kn }{last value of the gain, needed for smoothing}
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
%% ##--or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,cQ,cR,input){
%%   #
%%   # NOTE: must give cholesky decomp: cQ=chol(Q), cR=chol(R)
%%  Q=t(cQ)\%*\%cQ
%%  R=t(cR)\%*\%cR
%%    # y is num by q  (time=row series=col)
%%    # input is num by r (use 0 if not needed)
%%    # A is an array with dim=c(q,p,num)
%%    # Ups is p by r  (use 0 if not needed)
%%    # Gam is q by r  (use 0 if not needed)
%%    # R is q by q
%%    # mu0 is p by 1
%%    # Sigma0, Phi, Q are p by p
%%  Phi=as.matrix(Phi)
%%  pdim=nrow(Phi)     
%%  y=as.matrix(y)
%%  qdim=ncol(y)
%%  rdim=ncol(as.matrix(input))
%%   if (Ups==0) Ups = matrix(0,pdim,rdim)
%%   if (Gam==0) Gam = matrix(0,qdim,rdim)
%%   Ups=as.matrix(Ups)
%%   Gam=as.matrix(Gam)
%%  ut=matrix(input,num,rdim)
%%  xp=array(NA, dim=c(pdim,1,num))         # xp=x_t^{t-1}          
%%  Pp=array(NA, dim=c(pdim,pdim,num))      # Pp=P_t^{t-1}
%%  xf=array(NA, dim=c(pdim,1,num))         # xf=x_t^t
%%  Pf=array(NA, dim=c(pdim,pdim,num))      # Pf=x_t^t
%%  innov=array(NA, dim=c(qdim,1,num))      # innovations
%%  sig=array(NA, dim=c(qdim,qdim,num))     # innov var-cov matrix
%% # initialize (because R can't count from zero) 
%%  x00=as.matrix(mu0, nrow=pdim, ncol=1)
%%    P00=as.matrix(Sigma0, nrow=pdim, ncol=pdim)
%%    xp[,,1]=Phi\%*\%x00 + Ups\%*\%ut[1,]
%%    Pp[,,1]=Phi\%*\%P00\%*\%t(Phi)+Q
%%      B = matrix(A[,,1], nrow=qdim, ncol=pdim)  
%%      sigtemp=B\%*\%Pp[,,1]\%*\%t(B)+R
%%    sig[,,1]=(t(sigtemp)+sigtemp)/2     # innov var - make sure it's symmetric
%%    siginv=solve(sig[,,1])          
%%    K=Pp[,,1]\%*\%t(B)\%*\%siginv
%%    innov[,,1]=y[1,]-B\%*\%xp[,,1]-Gam\%*\%ut[1,]
%%    xf[,,1]=xp[,,1]+K\%*\%innov[,,1]
%%    Pf[,,1]=Pp[,,1]-K\%*\%B\%*\%Pp[,,1]
%%    sigmat=as.matrix(sig[,,1], nrow=qdim, ncol=qdim)
%%    like = log(det(sigmat)) + t(innov[,,1])\%*\%siginv\%*\%innov[,,1]   # -log(likelihood)
%% ############################# 
%% # start filter iterations
%% #############################
%%  for (i in 2:num){
%% 	 if (num < 2) break
%%   xp[,,i]=Phi\%*\%xf[,,i-1] + Ups\%*\%ut[i,]
%%   Pp[,,i]=Phi\%*\%Pf[,,i-1]\%*\%t(Phi)+Q
%%       B = matrix(A[,,i], nrow=qdim, ncol=pdim)  
%%       siginv=B\%*\%Pp[,,i]\%*\%t(B)+R
%%   sig[,,i]=(t(siginv)+siginv)/2     # make sure sig is symmetric
%%     siginv=solve(sig[,,i])          # now siginv is sig[[i]]^{-1}
%%   K=Pp[,,i]\%*\%t(B)\%*\%siginv
%%   innov[,,i]=y[i,]-B\%*\%xp[,,i]-Gam\%*\%ut[i,]
%%   xf[,,i]=xp[,,i]+K\%*\%innov[,,i]
%%   Pf[,,i]=Pp[,,i]-K\%*\%B\%*\%Pp[,,i]
%%     sigmat=matrix(sig[,,i], nrow=qdim, ncol=qdim)
%%   like= like + log(det(sigmat)) + t(innov[,,i])\%*\%siginv\%*\%innov[,,i]
%%   }
%%     like=0.5*like
%%     list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 