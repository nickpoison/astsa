\name{LagReg}
\alias{LagReg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Lagged Regression
%%  ~~function to do ... ~~
}
\description{Performs lagged regression as discussed in Chapter 4.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
LagReg(input, output, L = c(3, 3), M = 40, threshold = 0, 
        inverse = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{input}{input series
%%     ~~Describe \code{input} here~~
}
  \item{output}{output series
%%     ~~Describe \code{output} here~~
}
  \item{L}{degree of smoothing;  see \code{spans} in the help file for \code{spec.pgram}.
%%     ~~Describe \code{L} here~~
}
  \item{M}{must be even; number of terms used in the lagged regression
%%     ~~Describe \code{M} here~~
}
  \item{threshold}{the cut-off used to set small (in absolute value) regression coeffcients equal to zero
%%     ~~Describe \code{threshold} here~~
}
  \item{inverse}{if TRUE, will fit a forward-lagged regression
%%     ~~Describe \code{inverse} here~~
}
}
\details{For a bivariate series, \code{input} is the input series and \code{output} is the output series. The degree of smoothing for the spectral estimate is given by L; see \code{spans} in the help file for \code{spec.pgram}. The number of terms used in the lagged regression approximation is given by M, which must be even. The threshold value is the cut-off used to set small (in absolute value) regression coeffcients equal to zero (it is easiest to run LagReg twice, once with the default threshold of zero, and then again after inspecting the resulting coeffcients and the corresponding values of the CCF). Setting inverse=TRUE will fit a forward-lagged regression; the default is to run a backward-lagged regression. The script is based on code that was contributed by Professor Doug Wiens, Department of Mathematical and Statistical Sciences, University of Alberta. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{Graphs of the estimated impulse response function, the CCF, and the output with the predicted values superimposed.
%%  ~Describe the value returned
%%  If it is a LIST, use
  \item{beta}{Estimated coefficients}
  \item{fit}{The output series, the fitted values, and the residuals}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%%\note{
%%%%  ~~further notes~~
%%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%%% ~~objects to See Also as \code{\link{help}}, ~~~
%}
%% \examples{
%% ##---- Should be DIRECTLY executable !! ----
%% ##-- ==>  Define data, use random,
%% ##--	or do  help(data=index)  for the standard data sets.
%% 
%% ## The function is currently defined as
%% function(input, output, L=c(3,3), M=40, threshold=0, inverse=FALSE){
%% 
%% ## This is based on code contributed by:
%% ##  Professor Douglas P. Wiens 
%% ##  Department of Mathematical and Statistical Sciences
%% ##  University of Alberta         
%% ##  http://www.stat.ualberta.ca/\%7Ewiens/wiens.html    
%% ######################################
%% 
%% L = 2*floor((L-1)/2)+1     # make sure L is odd (can be vector)
%% M = 2*floor(M/2)           # make sure M is even
%% 
%% name.in = deparse(substitute(input))
%% name.out= deparse(substitute(output))
%% 
%% ######################################
%% ## Remove the means; they get added back in later
%% mean.in = mean(input)
%% mean.out = mean(output)
%% 
%% input = input- mean.in
%% output = output - mean.out
%% 
%% cat("INPUT:",name.in,"OUTPUT:",name.out, "  L =",L, "   M =",M, "\n\n")
%% 
%% ######################################
%% 
%% # Compute the spectra
%% # Note the order: cbind(output, input) - this is necessary in order that the phase have the right sign.
%% spectra = spectrum(ts(cbind(output, input)), spans=L , plot = FALSE)
%% 
%% 
%% N = 2*length(spectra$freq)  # This will be T'.
%% 
%% ## First look only at frequencies 1/M, 2/M, ... .5*M/M 
%% ## Currently the frequencies used are 1/N, 2/N, ... .5*N/N 
%% 
%% sampled.indices = (N/M)*(1:(M/2))  # These are the indices of the frequencies we want
%% 
%% fr.N = spectra$freq
%% fr.M = fr.N[sampled.indices]  # These will be the frequencies we want
%% 
%% ## Restrict the output of 'spectrum' to the frequencies we want:
%% 
%% coh.N = spectra$coh
%% coh.M = coh.N[sampled.indices]
%% 
%% phase.N = spectra$phase
%% phase.M = phase.N[sampled.indices]
%% 
%% output.spec.N = spectra$spec[,1]
%% output.spec.M = output.spec.N[sampled.indices]
%% 
%% input.spec.N = spectra$spec[,2]
%% input.spec.M = input.spec.N[sampled.indices]
%% 
%% 
%% 
%% ## B = sqrt(coherence*spectrum(y)/spectrum(x))*exp(1i*phase); here 'x' = input, 'y' = output:
%% 
%% B = sqrt(coh.M*output.spec.M/input.spec.M)*exp(1i*phase.M)
%% 
%% ## Invert B, by discretizing the defining integral, to get the coefficients b:
%% delta = 1/M
%% Omega = seq(from = 1/M, to = .5, length = M/2)
%% bb = function(s) 2*delta*sum(exp(2i*pi*Omega*s)*B)
%% 
%% S = ((-M/2+1):(M/2-1))
%% b = vector(length = length(S))
%% for(k in 1:length(S)) b[k] = bb(S[k])
%% b = Re(b)
%% 
%% b.pos = b[(M/2):length(b)]    # beta(0), beta(1), beta(2) ...
%% b.neg = b[(M/2):1]	          # beta(0), beta(-1), beta(-2) ... 
%% 
%% 
%% cat("The coefficients beta(0), beta(1), beta(2) ... beta(M/2-1) are", fill=TRUE, "\n")
%% cat(b.pos, fill=TRUE,  "\n\n")
%% 
%% 
%% cat("The coefficients beta(0), beta(-1), beta(-2) ... beta(-M/2+1) are", fill=TRUE, "\n")
%% cat(b.neg, fill=TRUE,"\n\n")
%% 
%% 
%% old.par <- par(no.readonly = TRUE)
%% 
%% par(mfrow=c(3,1))
%% plot(S, b, type = "h", xlab = "s", ylab = "beta(s)", main = "coefficients beta(s)")
%% abline(h=0)
%% ccf(output, input, lag.max = M/2-1, main = "cross-correlations", ylab = "CCF")
%% 
%% ######################################################
%% ##                  start cases                     ##
%% ######################################################
%% 
%% #################default####################################
%% if(inverse == FALSE){
%% ############################################################	
%% 
%% ## First isolate the significantly large betas with positive indices
%% 
%% b.pos = b[(M/2):length(b)]   # beta(0), beta(1), beta(2) ...
%% b.neg = b[(M/2):1]	         # beta(0), beta(-1), beta(-2) ... 
%% sig.s = which(abs(b.pos) >= threshold) 
%% if (length(sig.s) < 1) stop("threshold too large")
%% 
%% 
%% b.pos.sig = b.pos[sig.s]  # The vector of significant beta's
%% mat = cbind(sig.s-1, b.pos.sig)
%% colnames(mat) = c("lag s", "beta(s)")
%% 
%% 
%% 
%% cat("The positive lags, at which the coefficients are large
%% in absolute value, and the coefficients themselves, are:", "\n")
%% print(mat)
%% 
%% ## Form a matrix consisting of all series to be used in the lagged regression
%% datax = ts.intersect(output, lag(input, -sig.s[1]))
%% if(length(sig.s)>1) {for(i in 2:length(sig.s)) datax = ts.intersect(datax, lag(input, -sig.s[i]))}
%% 
%% ## put means back
%% yhat =  mean.out + datax\%*\%c(0, b.pos.sig) # These are the predicted (by the input) values of the output
%% y = datax[,1]  + mean.out  # This is the original output series, for comparison
%% alpha = mean.out - mean.in*sum(b.pos.sig)  # the constant (just for the output)
%% 
%% MSE = sum((y-yhat)^2)/length(y)
%% ts.plot(y, yhat, lty=2:1, col=c(1,4), main = "Output (dotted line) and predicted (by the input) values \n based on the impulse-response analysis")
%% 
%% cat("\n", "The prediction equation is", "\n",
%% name.out,"(t) = alpha + sum_s[ beta(s)*",name.in,"(t-s) ], where alpha = ", alpha, "\n",
%% "MSE = ", MSE, "\n", sep="") 
%%                 }
%% 
%% ###################option###############################
%% if(inverse == TRUE) {
%% ########################################################
%% 
%% ## First isolate the significantly large betas with negative indices
%% 
%% b.pos = b[(M/2):length(b)]   # beta(0), beta(-) ...
%% b.neg = b[(M/2-1):1]	     # beta(-1), beta(-2) ... 
%% 
%% sig.s = which(abs(b.neg) >= threshold)
%% if (length(sig.s) < 1) stop("threshold too large")
%% b.neg.sig = b.neg[sig.s]  # The vector of significant beta's
%% mat = cbind(sig.s-1, b.neg.sig)
%% colnames(mat) = c("lag s", "beta(s)")
%% 
%% 
%% cat("The negative lags, at which the coefficients are large
%% in absolute value, and the coefficients themselves, are:", "\n")
%% print(mat)
%% 
%% ## Form a matrix consisting of all series to be used in the lagged regression
%% datax = ts.intersect(output, lag(input, sig.s[1]))
%% if(length(sig.s)>1) {for(i in 2:length(sig.s)) datax = ts.intersect(datax, lag(input, sig.s[i]))}
%% 
%% ## put means back
%% yhat = mean.out + datax\%*\%c(0, b.neg.sig)  # These are the predicted (by the input) values of the output
%% y = datax[,1] + mean.out  # This is the original output series, for comparison
%% alpha = mean.out - mean.in*sum(b.neg.sig)  # the constant (just for the output)
%% 
%% MSE = sum((y-yhat)^2)/length(y)
%% ts.plot(y, yhat, lty=2:1, col=c(1,4), main = "Output (dotted line) and predicted (by the input) values \n based on the impulse-response analysis")
%% 
%% 
%% cat("\n", "The prediction equation is", "\n",
%% name.out,"(t) = alpha + sum_s[ beta(s)*",name.in,"(t+s) ], where alpha = ",alpha, "\n",
%% "MSE = ",MSE, "\n", sep="") 
%%                }
%% on.exit(par(old.par))             
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 