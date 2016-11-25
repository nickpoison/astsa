\name{SVfilter}
\alias{SVfilter}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Switching Filter (for Stochastic Volatility Models)
%%  ~~function to do ... ~~
}
\description{Performs a special case switching filter when the observational noise is a certain mixture of normals. Used to fit a stochastic volatility model. 
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SVfilter(num, y, phi0, phi1, sQ, alpha, sR0, mu1, sR1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{time series of returns
%%     ~~Describe \code{y} here~~
}
  \item{phi0}{state constant
%%     ~~Describe \code{phi0} here~~
}
  \item{phi1}{state transition parameter
%%     ~~Describe \code{phi1} here~~
}
  \item{sQ}{state standard deviation
%%     ~~Describe \code{sQ} here~~
}
  \item{alpha}{observation constant
%%     ~~Describe \code{alpha} here~~
}
  \item{sR0}{observation error standard deviation for mixture component zero
%%     ~~Describe \code{sR0} here~~
}
  \item{mu1}{observation error mean for mixture component one
%%     ~~Describe \code{mu1} here~~
}
  \item{sR1}{observation error standard deviation for mixture component one
%%     ~~Describe \code{sR1} here~~
}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{
\item{xp }{one-step-ahead prediction of the volatility}
\item{Pp }{mean square prediction error of the volatility}
\item{like }{the negative of the log likelihood at the given parameter values}
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
%% ##-- or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(num,y,phi0,phi1,sQ,alpha,sR0,mu1,sR1){
%%   #
%%   #  y is log(return^2)
%%   #
%%   #  
%%   # Initialize
%% y=as.matrix(y)
%% Q=sQ^2
%% R0=sR0^2
%% R1=sR1^2
%% xf=0          # =h_0^0
%% Pf=sQ^2/(1-phi1)     # =P_0^0
%% Pf[Pf<0]=0           # make sure Pf not negative
%% xp=matrix(0,num,1)   # =h_t^t-1
%% Pp=matrix(0,num,1)   # =P_t^t-1
%% pi1=.5    #initial mix probs
%% pi0=.5
%% fpi1=.5
%% fpi0=.5
%% like=0                  # -log(likelihood)
%% #
%% for (i in 1:num){
%%  xp[i]=phi1*xf+phi0
%%  Pp[i]=phi1*Pf*phi1+Q
%%   sig1=Pp[i]+R1     #innov var
%%   sig0=Pp[i]+R0 
%%   k1= Pp[i]/sig1
%%   k0= Pp[i]/sig0
%%   e1=y[i]-xp[i]-mu1-alpha
%%   e0= y[i]-xp[i]-alpha
%% #  
%%  den1= (1/sqrt(sig1))*exp(-.5*e1^2/sig1)
%%  den0= (1/sqrt(sig0))*exp(-.5*e0^2/sig0)
%%  denom=pi1*den1+pi0*den0
%%  fpi1=pi1*den1/denom
%%  fpi0=pi0*den0/denom
%% #
%%  xf= xp[i]+ fpi1*k1*e1+fpi0*k0*e0
%%  Pf=fpi1*(1-k1)*Pp[i]+ fpi0*(1-k0)*Pp[i]
%%  like= like - 0.5*log(pi1*den1 + pi0*den0)
%%  }
%%  list(xp=xp,Pp=Pp,like=like)
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 