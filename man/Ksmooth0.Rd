\name{Ksmooth0}
\alias{Ksmooth0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Kalman Filter and Smoother - Time invariant model without inputs
%%  ~~function to do ... ~~
}
\description{Returns both the filtered values  and  smoothed values   for the state-space model.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Ksmooth0(num, y, A, mu0, Sigma0, Phi, cQ, cR)
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
\details{Practically, the script only requires that Q or R may be reconstructed as  \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively, which allows more flexibility.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{xs }{state smoothers}
\item{Ps }{smoother mean square error}
\item{x0n }{initial mean smoother}
\item{P0n }{initial smoother covariance}
\item{J0 }{initial value of the J matrix}
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
%% function(num,y,A,mu0,Sigma0,Phi,cQ,cR){
%% #
%% # Note: Q and R are given as Cholesky decomps
%% #       cQ=chol(Q), cR=chol(R)
%% #
%%  kf=Kfilter0(num,y,A,mu0,Sigma0,Phi,cQ,cR)
%%  pdim=nrow(as.matrix(Phi))  
%%  xs=array(NA, dim=c(pdim,1,num))      # xs=x_t^n
%%  Ps=array(NA, dim=c(pdim,pdim,num))   # Ps=P_t^n
%%  J=array(NA, dim=c(pdim,pdim,num))    # J=J_t
%%  xs[,,num]=kf$xf[,,num] 
%%  Ps[,,num]=kf$Pf[,,num]
%%  for(k in num:2)  {
%%  J[,,k-1]=(kf$Pf[,,k-1]\%*\%t(Phi))\%*\%solve(kf$Pp[,,k])
%%  xs[,,k-1]=kf$xf[,,k-1]+J[,,k-1]\%*\%(xs[,,k]-kf$xp[,,k])
%%  Ps[,,k-1]=kf$Pf[,,k-1]+J[,,k-1]\%*\%(Ps[,,k]-kf$Pp[,,k])\%*\%t(J[,,k-1])
%%   }
%% # and now for the initial values because R can't count backward to zero
%%     x00=mu0
%%     P00=Sigma0
%%    J0=as.matrix((P00\%*\%t(Phi))\%*\%solve(kf$Pp[,,1]), nrow=pdim, ncol=pdim)
%%    x0n=as.matrix(x00+J0\%*\%(xs[,,1]-kf$xp[,,1]), nrow=pdim, ncol=1)
%%    P0n= P00 + J0\%*\%(Ps[,,k]-kf$Pp[,,k])\%*\%t(J0)
%% list(xs=xs,Ps=Ps,x0n=x0n,P0n=P0n,J0=J0,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 