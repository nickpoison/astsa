\name{stoch.reg}
\alias{stoch.reg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Frequency Domain Stochastic Regression
%%  ~~function to do ... ~~
}
\description{Performs frequency domain stochastic regression discussed in Chapter 7.  
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
stoch.reg(data, cols.full, cols.red, alpha, L, M, plot.which)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{data matrix
%%     ~~Describe \code{data} here~~
}
  \item{cols.full}{specify columns of data matrix that are in the full model
%%     ~~Describe \code{cols.full} here~~
}
  \item{cols.red}{specify columns of data matrix that are in the reduced model (use NULL if there are no inputs in the reduced model) 
%%     ~~Describe \code{cols.red} here~~
}
  \item{alpha}{test size
%%     ~~Describe \code{alpha} here~~
}
  \item{L}{smoothing - see \code{spans} in \code{spec.pgram}
%%     ~~Describe \code{L} here~~
}
  \item{M}{number of points in the discretization of the integral
%%     ~~Describe \code{M} here~~
}
  \item{plot.which}{\code{coh} or \code{F.stat}, to plot either the squared-coherencies or the F-statistics, respectively
%%     ~~Describe \code{plot.which} here~~
}
}
%\details{
%%  ~~ If necessary, more details than the description above ~~
%}
\value{\item{power.full }{spectrum under the full model}
\item{power.red }{spectrum under the reduced model}
\item{Betahat }{regression parameter estimates}
\item{eF }{pointwise (by frequency) F-tests}
\item{coh }{coherency}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
\note{The script is based on code that was contributed by Professor Doug Wiens, Department of Mathematical and Statistical Sciences, University of Alberta. See Example 7.1 on page 417 for a demonstration.
%%  ~~further notes~~
}

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
%% function(data, cols.full, cols.red, alpha, L, M, plot.which)  {
%% # SPEC[i,j,k] is the spectrum between the i-th and j-th series at frequency k/n':
%% SPEC = array(dim = c(ncol(data),ncol(data),nextn(nrow(data))/2)) 
%% for(i in 1:ncol(data)) { 
%% for (j in i:ncol(data)) {
%% 	power = spec.pgram(data[,c(i,j)], kernel("daniell",(L-1)/2), plot = FALSE)
%% 	SPEC[i,i, ] = power$spec[,1]
%% 	SPEC[j,j, ] = power$spec[,2]
%% 	coh.ij = power$coh 
%% 	phase.ij = power$phase 
%% 	SPEC[i,j, ] = sqrt(coh.ij*power$spec[,1]*power$spec[,2])*exp(1i*phase.ij)
%% 	SPEC[j,i, ] = Conj(SPEC[i,j, ])
%% 	}}
%% 
%% ### Compute the power under the full model:
%% f.yy = SPEC[ncol(data), ncol(data), ]
%% f.xx = SPEC[cols.full, cols.full, ]
%% f.xy = SPEC[cols.full, ncol(data), ]
%% f.yx = SPEC[ncol(data), cols.full, ]
%% 
%% power.full = vector(length = dim(SPEC)[3])
%% for (k in 1:length(power.full)) {
%% 	power.full[k] = f.yy[k] - sum(f.yx[,k]*solve(f.xx[,,k],f.xy[,k]))
%% 	}
%% power.full = Re(power.full)
%% 
%% 
%% ### Compute the IFT of the coefficients in the full model:
%% B = array(dim = c(length(cols.full), dim(SPEC)[3]))
%% for (k in 1:length(power.full)) {
%% 	B[,k] = solve(t(f.xx[,,k]),f.yx[,k])
%% 	}
%% # Isolate those frequencies at which we need B:
%% # These are the frequencies 1/M, 2/M, ... .5*M/M 
%% # Currently the frequencies used are 1/N, 2/N, ... .5*N/N 
%% N = 2*length(power$freq)  # This will be n', in our notation 
%% 	# R displays the power at only half of the frequencies.
%% sampled.indices = (N/M)*(1:(M/2))  # These are the indices of the frequencies we want
%% B = B[, sampled.indices]
%% # Invert B, by discretizing the defining integral, to get the coefficients b:
%% delta = 1/M
%% Omega = seq(from = 1/M, to = .5, length = M/2)
%% 
%% b = array(dim = c(M-1, length(cols.full)))
%% for (s in seq(from = -M/2+1, to = M/2 - 1, length = M-1)) {
%% 	for (j in 1:length(cols.full)) {
%% 		b[s + M/2,j] = 2*delta*sum(exp(2i*pi*Omega*s)*B[j,])
%% 	}}
%% Betahat = Re(b)
%% 
%% 
%% ### Compute the power under the reduced model:
%% if (length(cols.red) > 0) {
%% 	f.xx = SPEC[cols.red, cols.red, ]
%% 	f.xy = SPEC[cols.red, ncol(data), ]
%% 	f.yx = SPEC[ncol(data), cols.red, ]
%% 	}
%% 
%% power.red = vector(length = dim(SPEC)[3])
%% for (k in 1:length(power.red)) {
%% 	if(length(cols.red)==0) power.red[k] = f.yy[k]
%% 	if(length(cols.red)==1) power.red[k] = f.yy[k] - f.yx[k]*f.xy[k]/f.xx[k]
%% 	if(length(cols.red)> 1) power.red[k] = f.yy[k] - sum(f.yx[,k]*solve(f.xx[,,k],f.xy[,k]))
%% 	}
%% power.red = Re(power.red)
%% 
%% ### Compute and plot the F statistics
%% q = length(cols.full)
%% q1 = length(cols.red)
%% q2 = q - q1
%% df.num = 2*q2
%% df.denom = 2*(L-q)
%% crit.F = qf(1-alpha, df.num, df.denom)
%% MS.drop = L*(power.red - power.full)/df.num
%% MSE = L*power.full/df.denom
%% F.to.drop = MS.drop/MSE
%% coh.mult = F.to.drop/(F.to.drop + df.denom/df.num)
%% crit.coh = crit.F/(crit.F + df.denom/df.num)
%% 
%% if(plot.which=="F.stat") {
%% 	plot(power$freq, F.to.drop, type = "l", xlab = "Frequency", ylab = "F", ylim = c(0, 3*crit.F))
%% 	abline(h=crit.F)
%% 	}
%% if(plot.which=="coh") {
%% 	plot(power$freq, coh.mult, type = "l", xlab = "Frequency", ylab = "Sq Coherence", ylim=c(0,1)) 	  
%% 	abline(h=crit.coh)
%% 	}
%% 
%% list(power.full = power.full, power.red = power.red, Betahat = Betahat, eF = F.to.drop, coh = coh.mult)
%% 
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 