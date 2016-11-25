\name{SigExtract}
\alias{SigExtract}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Signal Extraction And Optimal Filtering
%%  ~~function to do ... ~~
}
\description{Performs signal extraction and optimal filtering as discussed in Chapter 4.

%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SigExtract(series, L = c(3, 3), M = 50, max.freq = 0.05)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{series}{univariate time series to be filtered
%%     ~~Describe \code{series} here~~
}
  \item{L}{degree of smoothing (may be a vector); see \code{spans} in \code{spec.pgram}
  for more details 
%%     ~~Describe \code{L} here~~
}
  \item{M}{number of terms used in the lagged regression approximation
%%     ~~Describe \code{M} here~~
}
  \item{max.freq}{truncation frequency, which must be larger than 1/M.
%%     ~~Describe \code{max.freq} here~~
}
}
\details{The basic function of the script, and the default setting, is to remove frequencies above 1/20 (and, in particular, the seasonal frequency of 1 cycle every 12 time points). The  sampling frequency of the time series is set to unity prior to the analysis. 
%%  ~~ If necessary, more details than the description above ~~
}
\value{Returns plots of (1) the original and filtered series, (2) the estiamted spectra of each series, (3)  the filter coefficients and the desired and attained frequency response function.  The filtered series is returned invisibly.
%%  ~Describe the value returned
%%  If it is a LIST, use
%%\item{series.filt }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
\note{The script is based on code that was contributed by Professor Doug Wiens,
Department of Mathematical and Statistical Sciences, University of Alberta.
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
%% function(series, L=c(3,3), M=50, max.freq=.05){
%% 
%% ## Based on conde contributed by:
%% ##  Professor Douglas P. Wiens 
%% ##  Department of Mathematical and Statistical Sciences
%% ##  University of Alberta         
%% ##   http://www.stat.ualberta.ca/\%7Ewiens/wiens.html     
%% ##                               
%% ######################################
%% 
%% ######## Smoothing parameter (L) is odd
%% ######## Number of estimates (M) is even
%% ######## Frequency response function A(nu) real and symmetric  
%% 
%% L = 2*floor((L-1)/2)+1     # make sure L is odd
%%  if (max.freq < 0 || max.freq > .5) stop("max.freq must be between 0 and 1/2")
%%   chek=FALSE
%%  if (max.freq < (1/M)) {M = 2.5*(1/max.freq); chek=TRUE} 
%% M = 2*floor(M/2)           # make sure M  is even
%%  if (chek==TRUE)  {cat("WARNING: must have max.freq > 1/M -- M changed to", M, "\n")}
%% 
%% 
%% # Compute the spectrum
%% series = ts(series, frequency = 1)  # This script assumes frequency = 1 (so 0 < nu < .5)
%% spectra = spec.pgram(series, spans=L, plot = FALSE)
%% 
%% 
%% A <- function(nu) {
%% qwe = ifelse((nu > .01 && nu < max.freq), 1, 0) 
%% qwe  # Sets A(nu) to be qwe
%%   }
%% 
%% ######################################
%% ## Compute the filter coefficients
%% 
%% N = 2*length(spectra$freq)  # This will be T'.
%% 
%% # First look only at frequencies 1/M, 2/M, ... .5*M/M   (this is why max.freq > 1/M)
%% # Currently the frequencies used are are 1/N, 2/N, ... .5*N/N 
%% 
%% sampled.indices = (N/M)*(1:(M/2))  # These are the indices of the frequencies we want
%% 
%% fr.N = spectra$freq
%% fr.M = fr.N[sampled.indices]  # These will be the frequencies we want
%% 
%% spec.N = spectra$spec
%% spec.M = spec.N[sampled.indices] # Power at these frequencies
%% 
%% # Evaluate the desired frequency reponse A(nu) at these frequencies:
%% 
%% A.desired = vector(length = length(fr.M))
%% for(k in 1:length(fr.M)) A.desired[k] = A(fr.M[k])
%% 
%% # Invert A.desired, by discretizing the defining integral, to get the coefficients a:
%% delta = 1/M
%% Omega = seq(from = 1/M, to = .5, length = M/2)
%% aa = function(s) 2*delta*sum(exp(2i*pi*Omega*s)*A.desired)
%% 
%% S = ((-M/2+1):(M/2-1))
%% a = vector(length = length(S))
%% for(k in 1:length(S)) a[k] = aa(S[k])
%% a = Re(a)  # The filter coefficients 
%% 
%% # Apply a cosine taper
%% h = .5*(1+cos(2*pi*S/length(S)))
%% a = a*h    # Comment out this line, to see the effect of NOT tapering
%% 
%% 
%% cat("The filter coefficients are", "\n")
%% qwe = cbind(S, a)
%% colnames(qwe) = c("s", "a(s)")
%% print(qwe[((length(S)+1)/2):1,])
%% cat("for s >=0; and a(-s) = a(s).", "\n")
%% 
%% 
%% # Compute the realized frequency response function, and the filtered series:
%% 
%% A.M = function(nu) Re(sum(exp(-2i*pi*nu*S)*a))
%% A.attained = vector(length = length(fr.N))
%% A.theoretical = vector(length = length(fr.N))
%% for(k in 1:length(fr.N)) {
%% A.attained[k] = A.M(fr.N[k]) # The attained freq. resp.
%% A.theoretical[k] = A(fr.N[k])
%%   }
%% 
%% series.filt = filter(series, a, sides = 2) # The filtered series
%% old.par <- par(no.readonly = TRUE)
%% par(mfrow=c(2,1))
%% plot.ts(series, main = "Original series")
%% plot.ts(series.filt, main = "Filtered series")
%% 
%% dev.new()
%% par(mfrow=c(2,1))
%% spectrum(series, spans=L, log="no", main = "Spectrum of original series")
%% spectrum(na.omit(series.filt), spans=L, log="no", main = "Spectrum of filtered series")
%% 
%% 
%% dev.new()
%% par(mfrow=c(2,1))
%% plot(S, a, xlab = "s", ylab = "a(s)", main = "Filter coefficients")
%% plot(fr.N, A.theoretical, type = "l", lty = 2, xlab = "freq", ylab = "freq. response", 
%%     main = "Desired and attained frequency response functions")
%% lines(fr.N, A.attained, lty = 1, col = 2)
%% on.exit(par(old.par))
%% return(invisible(series.filt))
%%   }
%% }
%% % Add one or more standard keywords, see file 'KEYWORDS' in the
%% % R documentation directory.
\keyword{ ts }
%% %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%% 