\name{Kfilter0}
\alias{Kfilter0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Kalman Filter - Time Invariant Model 
%%  ~~function to do ... ~~
}
\description{Returns the filtered values for the basic time invariant state-space model; inputs are not allowed.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Kfilter0(num, y, A, mu0, Sigma0, Phi, cQ, cR)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{data matrix, vector or time series
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
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
%%     ~~Describe \code{cQ} here~~
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
%%     ~~Describe \code{cR} here~~
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{xp }{one-step-ahead state prediction}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{innov }{innovation series}
\item{sig }{innovation covariances}
\item{Kn }{last value of the gain, needed for smoothing}
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
%%  \examples{
%%  ##---- Should be DIRECTLY executable !! ----
%%  ##-- ==>  Define data, use random,
%%  ##--	or do  help(data=index)  for the standard data sets.
%%  
%%  ## The function is currently defined as
%%  function(num,y,A,mu0,Sigma0,Phi,cQ,cR){
%%    #
%%    # NOTE: must give cholesky decomp: cQ=chol(Q), cR=chol(R)
%%   Q=t(cQ)\%*\%cQ
%%   R=t(cR)\%*\%cR
%%     # y is num by q  (time=row series=col)
%%     # A is a q by p matrix
%%     # R is q by q
%%     # mu0 is p by 1
%%     # Sigma0, Phi, Q are p by p
%%   Phi=as.matrix(Phi)
%%   pdim=nrow(Phi)    
%%   y=as.matrix(y)
%%   qdim=ncol(y)
%%   xp=array(NA, dim=c(pdim,1,num))         # xp=x_t^{t-1}          
%%   Pp=array(NA, dim=c(pdim,pdim,num))      # Pp=P_t^{t-1}
%%   xf=array(NA, dim=c(pdim,1,num))         # xf=x_t^t
%%   Pf=array(NA, dim=c(pdim,pdim,num))      # Pf=x_t^t
%%   innov=array(NA, dim=c(qdim,1,num))      # innovations
%%   sig=array(NA, dim=c(qdim,qdim,num))     # innov var-cov matrix
%%  # initialize (because R can't count from zero)
%%     x00=as.matrix(mu0, nrow=pdim, ncol=1)
%%     P00=as.matrix(Sigma0, nrow=pdim, ncol=pdim)
%%     xp[,,1]=Phi\%*\%x00
%%     Pp[,,1]=Phi\%*\%P00\%*\%t(Phi)+Q
%%       sigtemp=A\%*\%Pp[,,1]\%*\%t(A)+R
%%     sig[,,1]=(t(sigtemp)+sigtemp)/2     # innov var - make sure it's symmetric
%%     siginv=solve(sig[,,1])          
%%     K=Pp[,,1]\%*\%t(A)\%*\%siginv
%%     innov[,,1]=y[1,]-A\%*\%xp[,,1]
%%     xf[,,1]=xp[,,1]+K\%*\%innov[,,1]
%%     Pf[,,1]=Pp[,,1]-K\%*\%A\%*\%Pp[,,1]
%%     sigmat=as.matrix(sig[,,1], nrow=qdim, ncol=qdim)
%%     like = log(det(sigmat)) + t(innov[,,1])\%*\%siginv\%*\%innov[,,1]   # -log(likelihood)
%%  ########## start filter iterations ###################
%%   for (i in 2:num){
%%     if (num < 2) break
%%    xp[,,i]=Phi\%*\%xf[,,i-1]
%%    Pp[,,i]=Phi\%*\%Pf[,,i-1]\%*\%t(Phi)+Q
%%       sigtemp=A\%*\%Pp[,,i]\%*\%t(A)+R
%%     sig[,,i]=(t(sigtemp)+sigtemp)/2     # innov var - make sure it's symmetric
%%     siginv=solve(sig[,,i])              
%%    K=Pp[,,i]\%*\%t(A)\%*\%siginv
%%    innov[,,i]=y[i,]-A\%*\%xp[,,i]
%%    xf[,,i]=xp[,,i]+K\%*\%innov[,,i]
%%    Pf[,,i]=Pp[,,i]-K\%*\%A\%*\%Pp[,,i]
%%      sigmat=as.matrix(sig[,,i], nrow=qdim, ncol=qdim)
%%    like= like + log(det(sigmat)) + t(innov[,,i])\%*\%siginv\%*\%innov[,,i]
%%    }
%%      like=0.5*like
%%      list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
%%    }
%%  }
%%  % Add one or more standard keywords, see file 'KEYWORDS' in the
%%  % R documentation directory.
\keyword{ ts }
%%  %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%%  