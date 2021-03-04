test.linear <-
function(series, color=TRUE){
x = series
N = length(x)       # data length
L = floor(N^.49)    # block width
P = floor(N/L)      # number of blocks
#  dft for each block
X = matrix(NA, L, P)
 for (p in 1:P) {
  strt  = (p-1)*L+1
  endd  = p*L
  X[,p] = fft(x[strt:endd])/sqrt(L) 
 }
X  = X[-1,]  # get rid of k=0 freq; now X[-k,p] = X[L-k,p]
S  = rowSums(Mod(X)^2)/N
L1 = floor((L-1)/2)
G  = matrix(as.complex(0), L1,L1)
  for (k1 in 1:L1){ 
   for (k2 in 1:L1){ u = 0
    for (p in 1:P) { u = X[k1,p]*X[k2,p]*X[L-(k1+k2),p] + u
    }
   G[k1,k2]=u/(sqrt(S[k1]*S[k2]*S[k1+k2])*N)
   }
  }
Test   = 2*N^(-1+2*.49)*abs(G)^2
Tst    = Test     # this is just a placeholder
lamhat = mean(Test)
 for (k1 in 1:L1){ 
  for (k2 in 1:L1){
   Tst[k1,k2] = pchisq(Test[k1,k2], df=2, ncp=lamhat, lower.tail=FALSE)
  }
 }
u    = seq(0, .5, length.out = nrow(Tst))
cm.c = cm.colors(201);  clrs = rev(cm.c[c(94:50, 121, 141, 161, 181, 201)]) 
if(color==FALSE)  clrs = rev(gray(c(400:356/400, .7, .6, .5, .4, .3)))  
par(mar=c(4,4,3,1)+.1, mgp=c(1.6,.6,0))      
filled.contour(u,u,Tst,  col=clrs, nlevels=50, zlim=c(0,1), 
               key.title = {par(cex.main=.75); title(main="p-value")})
mtext(expression(omega[1]), side=1, line=2,    adj=.4, cex=1.2)  
mtext(expression(omega[2]), side=2, line=2.75, adj=.5, cex=1.2, las=1)
title("Normalized BiSpectrum", adj =.35, line=1, cex.main=1.2) 
test.out = list(prob=Tst)
return(invisible(test.out))
}

