SigExtract <-
function(series, L=c(3,3), M=50, max.freq=.05){

## Based on conde contributed by:
##  Professor Douglas P. Wiens 
##  Department of Mathematical and Statistical Sciences
##  University of Alberta         
##   http://www.stat.ualberta.ca/%7Ewiens/wiens.html     
##                               
######################################
ts     = stats::ts
par    = graphics::par
plot   = graphics::plot
dev.new = grDevices::dev.new
abline = graphics::abline
ccf    = stats::ccf
ts.intersect = stats::ts.intersect 
ts.plot = stats::ts.plot
na.omit = stats::na.omit
lines = graphics::lines

######## Smoothing parameter (L) is odd
######## Number of estimates (M) is even
######## Frequency response function A(nu) real and symmetric  

L = 2*floor((L-1)/2)+1     # make sure L is odd
 if (max.freq < 0 || max.freq > .5) stop("max.freq must be between 0 and 1/2")
  chek=FALSE
 if (max.freq < (1/M)) {M = 2.5*(1/max.freq); chek=TRUE} 
M = 2*floor(M/2)           # make sure M  is even
 if (chek==TRUE)  {cat("WARNING: must have max.freq > 1/M -- M changed to", M, "\n")}


# Compute the spectrum
series = ts(series, frequency = 1)  # This script assumes frequency = 1 (so 0 < nu < .5)
spectra = stats::spec.pgram(series, spans=L, plot = FALSE)


A <- function(nu) {
qwe = ifelse((nu > .01 && nu < max.freq), 1, 0) 
qwe  # Sets A(nu) to be qwe
}

######################################
## Compute the filter coefficients

N = 2*length(spectra$freq)  # This will be T'.

# First look only at frequencies 1/M, 2/M, ... .5*M/M   (this is why max.freq > 1/M)
# Currently the frequencies used are are 1/N, 2/N, ... .5*N/N 

sampled.indices = (N/M)*(1:(M/2))  # These are the indices of the frequencies we want

fr.N = spectra$freq
fr.M = fr.N[sampled.indices]  # These will be the frequencies we want

spec.N = spectra$spec
spec.M = spec.N[sampled.indices] # Power at these frequencies

# Evaluate the desired frequency reponse A(nu) at these frequencies:

A.desired = vector(length = length(fr.M))
for(k in 1:length(fr.M)) A.desired[k] = A(fr.M[k])

# Invert A.desired, by discretizing the defining integral, to get the coefficients a:
delta = 1/M
Omega = seq(from = 1/M, to = .5, length = M/2)
aa = function(s) 2*delta*sum(exp(2i*pi*Omega*s)*A.desired)

S = ((-M/2+1):(M/2-1))
a = vector(length = length(S))
for(k in 1:length(S)) a[k] = aa(S[k])
a = Re(a)  # The filter coefficients 

# Apply a cosine taper
h = .5*(1+cos(2*pi*S/length(S)))
a = a*h    # Comment out this line, to see the effect of NOT tapering


cat("The filter coefficients are", "\n")
qwe = cbind(S, a)
colnames(qwe) = c("s", "a(s)")
print(qwe[((length(S)+1)/2):1,])
cat("for s >=0; and a(-s) = a(s).", "\n")


# Compute the realized frequency response function, and the filtered series:

A.M = function(nu) Re(sum(exp(-2i*pi*nu*S)*a))
A.attained = vector(length = length(fr.N))
A.theoretical = vector(length = length(fr.N))
for(k in 1:length(fr.N)) {
A.attained[k] = A.M(fr.N[k]) # The attained freq. resp.
A.theoretical[k] = A(fr.N[k])
}

series.filt = stats::filter(series, a, sides = 2) # The filtered series
old.par <- par(no.readonly = TRUE)
par(mfrow=c(2,1))
plot.ts(series, main = "Original series")
plot.ts(series.filt, main = "Filtered series")

dev.new()
par(mfrow=c(2,1))
stats::spectrum(series, spans=L, log="no", main = "Spectrum of original series")
stats::spectrum(na.omit(series.filt), spans=L, log="no", main = "Spectrum of filtered series")


dev.new()
par(mfrow=c(2,1))
plot(S, a, xlab = "s", ylab = "a(s)", main = "Filter coefficients")
plot(fr.N, A.theoretical, type = "l", lty = 2, xlab = "freq", ylab = "freq. response", 
    main = "Desired and attained frequency response functions")
lines(fr.N, A.attained, lty = 1, col = 2)
on.exit(par(old.par))
return(invisible(series.filt))
}

