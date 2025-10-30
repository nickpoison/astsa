arma.spec <-
function(ar=0, ma=0, var.noise=1, n.freq=500, main=NULL, redundancy.tol=.1,
          frequency=1, ylim=NULL, plot=TRUE, ...)
{  
   check <- 0
  # check causality
   ar.poly <- c(1, -ar)
   z.ar <- polyroot(ar.poly)
   if(any(abs(z.ar) <= 1)) {cat("WARNING: Model Not Causal", "\n"); check <- check + 1}  
  # check invertibility
   ma.poly <- c(1, ma)
   z.ma <- polyroot(ma.poly)
   if(any(abs(z.ma) <= 1)) {cat("WARNING: Model Not Invertible", "\n"); check <- check + 1}
   if (check > 0) stop("Try Again")
  #
   xfreq    <- frequency
   ar.order <- length(ar)
   ma.order <- length(ma)
  # check (near) parameter redundancy [i.e. are any inverse roots (approximately) equal] 
    if (redundancy.tol < 0) { 
     redundancy.tol=.1
     cat("\n'redundancy.tol' cannot be negative and has been reset to its default value\n\n")
    }
     red.count = 0
   for (i in 1:ar.order) {
    if ( (ar[1] == 0 && ar.order == 1) || (ma[1] == 0 && ma.order == 1) )  break
    if(any(abs(1/z.ar[i]-1/z.ma[1:ma.order]) < redundancy.tol)) 
             {cat("WARNING: (Possible) Parameter Redundancy", "\n"); red.count=1; break}
   }

  freq <- seq.int(0, 0.5, length.out = n.freq)
    cs.ar <- outer(freq, 1:ar.order, function(x, y) cos(2 * pi * x * y)) %*% ar
    sn.ar <- outer(freq, 1:ar.order, function(x, y) sin(2 * pi * x * y)) %*% ar
    cs.ma <- outer(freq, 1:ma.order, function(x, y) cos(2 * pi * x * y)) %*% -ma
    sn.ma <- outer(freq, 1:ma.order, function(x, y) sin(2 * pi * x * y)) %*% -ma
  spec <- var.noise*((1 - cs.ma)^2 + sn.ma^2)/((1 - cs.ar)^2 + sn.ar^2)

  spg.out <- list(freq=freq*xfreq, spec=spec)
 if(plot){
  if (is.null(main)){
   if ((ar[1] == 0 && ar.order == 1) && (ma[1] == 0 && ma.order == 1)){
     main = 'White Noise'
     } else {
     pAR = ar.order - (ar[1]==0 && ar.order==1)
     qMA = ma.order - (ma[1]==0 && ma.order==1) 
     main = bquote(ARMA(.(pAR),.(qMA)))
    }
  }
  Ylab = 'spectrum'
  Xlab = ifelse(xfreq>1, paste('frequency \u00D7', xfreq), 'frequency')
   m1  = min(spec) 
   m2  = max(spec) 
   if (red.count > 0) { 
       ylim = c(1e-6, 10*m2)
   } else {
   yspread =  (m2 - m1)/var.noise 
   if (is.null(ylim) & yspread < 1) ylim = c(max(m1-2*var.noise, 0.1*var.noise), m2+2*var.noise)
   }
 tsplot(freq*xfreq, spec, xlab=Xlab, ylab=Ylab, main=main, ylim=ylim, ...)
 }
 return(invisible(spg.out))
}

