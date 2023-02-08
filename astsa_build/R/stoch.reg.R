stoch.reg <-
function(xdata, cols.full, cols.red, alpha, L, M, plot.which, ...)  {
#
##############################################################################
# This function computes the spectral matrix, F statistics and coherences, and plots them.
# Returned as well are the coefficients in the impulse response function.
#
# Enter, as the argument to this function, the full data matrix, and then the labels of the 
# columns of input series in the "full" and "reduced" regression models - enter NULL if there 
# are no inputs under the reduced model. 
#
# The response variable is the LAST column of the data matrix, and this need not be specified 
# among the inputs.  Other inputs are alpha (test size), L (smoothing), M (number 
# of points in the discretization of the integral)  and plot.which = "coh" 
# or "F", to plot either the coherences or the F statistics.
##############################################################################
#
# SPEC[i,j,k] is the spectrum between the i-th and j-th series at frequency k/n':
SPEC = array(dim = c(ncol(xdata),ncol(xdata),nextn(nrow(xdata))/2)) 
for(i in 1:ncol(xdata)) { 
for (j in i:ncol(xdata)) {
	power = stats::spec.pgram(xdata[,c(i,j)], kernel("daniell",(L-1)/2), plot = FALSE)
	SPEC[i,i, ] = power$spec[,1]
	SPEC[j,j, ] = power$spec[,2]
	coh.ij = power$coh 
	phase.ij = power$phase 
	SPEC[i,j, ] = sqrt(coh.ij*power$spec[,1]*power$spec[,2])*exp(1i*phase.ij)
	SPEC[j,i, ] = Conj(SPEC[i,j, ])
	}}

### Compute the power under the full model:
f.yy = SPEC[ncol(xdata), ncol(xdata), ]
f.xx = SPEC[cols.full, cols.full, ]
f.xy = SPEC[cols.full, ncol(xdata), ]
f.yx = SPEC[ncol(xdata), cols.full, ]

power.full = vector(length = dim(SPEC)[3])
for (k in 1:length(power.full)) {
	power.full[k] = f.yy[k] - sum(f.yx[,k]*solve(f.xx[,,k],f.xy[,k]))
	}
power.full = Re(power.full)


### Compute the IFT of the coefficients in the full model:
B = array(dim = c(length(cols.full), dim(SPEC)[3]))
for (k in 1:length(power.full)) {
	B[,k] = solve(t(f.xx[,,k]),f.yx[,k])
	}
# Isolate those frequencies at which we need B:
# These are the frequencies 1/M, 2/M, ... .5*M/M 
# Currently the frequencies used are 1/N, 2/N, ... .5*N/N 
N = 2*length(power$freq)  # This will be n', in our notation 
# R displays the power at only half of the frequencies.
sampled.indices = (N/M)*(1:(M/2))  # These are the indices of the frequencies we want
B = B[, sampled.indices]
# Invert B, by discretizing the defining integral, to get the coefficients b:
delta = 1/M
Omega = seq(from = 1/M, to = .5, length = M/2)

b = array(dim = c(M-1, length(cols.full)))
for (s in seq(from = -M/2+1, to = M/2 - 1, length = M-1)) {
	for (j in 1:length(cols.full)) {
		b[s + M/2,j] = 2*delta*sum(exp(2i*pi*Omega*s)*B[j,])
	}}
Betahat = Re(b)


### Compute the power under the reduced model:
if (length(cols.red) > 0) {
	f.xx = SPEC[cols.red, cols.red, ]
	f.xy = SPEC[cols.red, ncol(xdata), ]
	f.yx = SPEC[ncol(xdata), cols.red, ]
	}

power.red = vector(length = dim(SPEC)[3])
for (k in 1:length(power.red)) {
	if(length(cols.red)==0) power.red[k] = f.yy[k]
	if(length(cols.red)==1) power.red[k] = f.yy[k] - f.yx[k]*f.xy[k]/f.xx[k]
	if(length(cols.red)> 1) power.red[k] = f.yy[k] - sum(f.yx[,k]*solve(f.xx[,,k],f.xy[,k]))
	}
power.red = Re(power.red)

### Compute and plot the F statistics
q = length(cols.full)
q1 = length(cols.red)
q2 = q - q1
df.num = 2*q2
df.denom = 2*(L-q)
crit.F = qf(1-alpha, df.num, df.denom)
MS.drop = L*(power.red - power.full)/df.num
MSE = L*power.full/df.denom
F.to.drop = MS.drop/MSE
coh.mult = F.to.drop/(F.to.drop + df.denom/df.num)
crit.coh = crit.F/(crit.F + df.denom/df.num)

if(plot.which=="F.stat") {
	tsplot(power$freq, F.to.drop, xlab = "Frequency", ylab = "F", ylim = c(0, 3*crit.F), ...)
	abline(h=crit.F)
	}
if(plot.which=="coh") {
	tsplot(power$freq, coh.mult, xlab = "Frequency", ylab = "Sq Coherence", ylim=c(0,1), ...) 	  
	abline(h=crit.coh)
	}

list(power.full = power.full, power.red = power.red, Betahat = Betahat, eF = F.to.drop, coh = coh.mult)

}

