mvspec <- function(x, spans = NULL, kernel = NULL, taper = 0, pad = 0, fast = TRUE, 
         demean = FALSE, detrend = TRUE, lowess=FALSE, log='n', plot = TRUE, gg=FALSE,
         type = NULL, na.action = na.fail, nxm=2, nym=1, main=NULL, xlab=NULL, 
         cex.main=NULL, ci=.95, ci.col=4, plot.type, ...)  
{
 
     na.fail = stats::na.fail
     as.ts = stats::as.ts
     frequency = stats::frequency
     is.tskernel = stats::is.tskernel
     spec.taper  = stats::spec.taper
     nextn   = stats::nextn
     mvfft  = stats::mvfft
     kernapply  = stats::kernapply
     df.kernel  = stats:: df.kernel
    #
    series <- deparse(substitute(x))
    x <- na.action(as.ts(x))
    tspar <- tsp(x)
    xfreq <- frequency(x)
    x <- as.matrix(x)
    N <- N0 <- nrow(x)
    nser <- ncol(x)
          # marginal plot works for any dimension; coh/phase have 2 conditions on nser 
          trigger = ifelse(nser < 3, 0L, 1L)   # univar or bivar = 0, else = 1
          if (missing(plot.type)) {plot.type='marginal'}
          if (grepl('marg',  plot.type)) {plot.type='marginal'; trigger=0L}
          if (grepl('coh', plot.type)) {plot.type='coherency'; trigger=trigger*1L}
          if (grepl('phas',  plot.type)) {plot.type='phase'; trigger=trigger*2L}
    if (!is.null(spans)) 
        kernel <- {
            if (is.tskernel(spans)) 
                spans
            else kernel("modified.daniell", spans%/%2)
        }	
    if (!is.null(kernel) && !is.tskernel(kernel)) 
        stop("must specify 'spans' or a valid kernel")
    if (demean) {
         detrend = FALSE
         x <- sweep(x, 2, colMeans(x))
    }
    if (detrend) {
         x = apply(x, 2, detrend, lowess=lowess)
    }
    x <- spec.taper(x, taper)
    u2 <- (1 - (5/8) * taper * 2)
    u4 <- (1 - (93/128) * taper * 2)
    if (pad > 0) {
        x <- rbind(x, matrix(0, nrow = N * pad, ncol = ncol(x)))
        N <- nrow(x)
    }
    NewN <- if (fast) 
        nextn(N)
    else N
    x <- rbind(x, matrix(0, nrow = (NewN - N), ncol = ncol(x)))  
    N <- nrow(x)
    Nspec <- floor(N/2)
    freq <- seq(from = xfreq/N, by = xfreq/N, length = Nspec)
    xfft <- mvfft(x)
    pgram <- array(NA, dim = c(N, ncol(x), ncol(x)))
    for (i in 1:ncol(x)) {
        for (j in 1:ncol(x)) {
            pgram[, i, j] <- xfft[, i] * Conj(xfft[, j])/(N0 * 
                xfreq)
            pgram[1, i, j] <- 0.5 * (pgram[2, i, j] + pgram[N, 
                i, j])
        }
    }
    if (!is.null(kernel)) {
        for (i in 1:ncol(x)) for (j in 1:ncol(x)) pgram[, i, 
            j] <- kernapply(pgram[, i, j], kernel, circular = TRUE)
        Lh = 1/sum(kernel[-kernel$m:kernel$m]^2)    #  L_h gets divided by N below
    } else {
        Lh <- 1
    }
    df <- 2*Lh    
    df <- df/(u4/u2^2)
    df <- df * (N0/N)
    bandwidth <- Lh*xfreq/N
    pgram <- pgram[2:(Nspec + 1), , , drop = FALSE]
    spec <- matrix(NA, nrow = Nspec, ncol = nser)
    for (i in 1:nser) spec[, i] <- Re(pgram[1:Nspec, i, i])
    if (nser == 1) {
        coh <- phase <- NULL
    }
    else {
        coh <- phase <- matrix(NA, nrow = Nspec, ncol = nser * 
            (nser - 1)/2)
        for (i in 1:(nser - 1)) {
            for (j in (i + 1):nser) {
                coh[, i + (j - 1) * (j - 2)/2] <- Mod(pgram[, 
                  i, j])^2/(spec[, i] * spec[, j])
                phase[, i + (j - 1) * (j - 2)/2] <- Arg(pgram[, 
                  i, j])
            }
        }
    }
    for (i in 1:nser) spec[, i] <- spec[, i]/u2
    spec <- drop(spec)
##== rearrange pgram for more useful display
#    if (nser == 1) {  # this was to prevent double output for 
#     fxx=NULL         # univariate case, but was not compatible 
#     } else {         # with dependent package
     fxx = base::aperm(pgram, c(2,3,1))
#    }
##== show details to help find peaks 
    details <- round( cbind(frequency=freq, period=1/freq, spectrum=spec), 4)
##== output
    spg.out <- list(freq = freq, spec = spec, coh = coh, phase = phase, 
        kernel = kernel, df = df, bandwidth = bandwidth,  
        fxx=fxx, Lh=Lh, n.used = N, details=details,
        orig.n = N0, series = series, snames = colnames(x), method = ifelse(!is.null(kernel), 
            "Smoothed Periodogram", "Raw Periodogram"), taper = taper, 
        pad = pad, detrend = detrend, demean = demean, tspar = tspar)
    class(spg.out) <- "spec"
#   
    if (plot & trigger < 1) {   #  for any univar or bivar plot
        if (Lh > 1) {cat("Bandwidth:", round(bandwidth,3), "|", "Degrees of Freedom:", round(df,2),"|", "split taper:", paste(100*taper,"%",sep=''), '\n')}
        if (is.null(cex.main)) cex.main=1
        if (is.null(main))  main <- paste("Series:", series,  " | ", spg.out$method) 
        topper = ifelse (is.na(main), 1, 0)
        if (!gg){
        par(mar = c(2.75, 2.75, 2-topper, 0.75), mgp = c(1.6, 0.6, 0), cex.main = cex.main)
         col.grid=gray(.9)
         } else {
         par(mar=c(2.75,2.75,2-topper,.5), mgp=c(1.6,.3,0), cex.main=1.1, tcl=-.2, cex.axis=.8, las=0)
         }
        type0 <- 'n' 
        type1 <- ifelse(is.null(type), 'l', type) 
        if (is.null(xlab)) xlab = ifelse(xfreq>1, paste('frequency', expression('\u00D7'), xfreq), 'frequency')
        plot(spg.out, type = type0, sub=NA, axes=FALSE, ann=FALSE, log = log, main='', plot.type=plot.type, ...) 
        if (gg) { 
        brdr = par("usr")
        rect(brdr[1], brdr[3], brdr[2], brdr[4], col=gray(.92), border='white')
        col.grid = 'white' 
        }          
        Grid(nxm=nxm, nym=nym, col=col.grid)
        par(new=TRUE)
        plot(spg.out, xlab=xlab, log = log, type = type1, sub=NA, main=main, ci.col=ci.col, plot.type=plot.type, ...) 
        if (gg) box(col=col.grid, lwd=2)
    }
    if (plot & trigger == 1) {  # coherency plot for nser > 2 
       .plotcoh(spg.out, ci=ci, gg=gg, main=main,  ...)
    }
        if (plot & trigger == 2) {  # phase plot for nser > 2 
       .plotphase(spg.out, ci=ci, gg=gg, main=main,  ...)
    }
    return(invisible(spg.out))
}




##############################################
.plotcoh <-
    function(x, ci = 0.95, ylim=c(0,1), gg=FALSE,
              main=NULL, ci.col=4, ci.lty = 3, scale=1, addLegend=TRUE, ...)
{
    nser <- NCOL(x$spec)
    gg2 <- 2/x$df
    se <- sqrt(gg2/2)
    z <- -qnorm((1-ci)/2)
       if (gg) scale = scale*1.05
       dev.hold(); on.exit(dev.flush())
        if (is.null(main)) main='Squared Coherencies'
        topper = ifelse(is.na(main),0,.65) 
        if (nser > 3) topper = topper+.15
        opar <- par(mfrow = c(nser-1, nser-1), mgp=c(1.6,.6,0), mar=c(0,0,0,0)+.5,
                   oma =  c(.25,.25,0+topper,0))
        on.exit(par(opar), add = TRUE)
        plot.new()
        par(cex = par('cex')*scale)
        for (j in 2:nser) for (i in 1L:(j-1)) {
            par(mfg=c(j-1,i, nser-1, nser-1), bty='L') 
            ind <- i + (j - 1) * (j - 2)/2
            tsplot(x$freq, x$coh[, ind], ylim=ylim, xlab=NA, ylab=NA, gg=gg, las=0, 
                   margins=c(0,0,-.8,0)+.2, ...)  
            coh <- pmin(0.99999, sqrt(x$coh[, ind]))
            lines(x$freq, (tanh(atanh(coh) + z*se))^2, lty=ci.lty, col=ci.col)
            lines(x$freq, (pmax(0, tanh(atanh(coh) - z*se)))^2,
                  lty=ci.lty, col=ci.col)
          if (i == 1) {
              title(ylab=x$snames[j], xpd = NA, cex.lab=1.25 )
          }
          if (j == nser) {
              title(xlab=x$snames[i], xpd = NA, cex.lab=1.25)
          }
            mtext(main, side=3, line=-.65*scale, outer=TRUE, cex = 1.025*scale, font = 1)
        } 
           if (addLegend){
            mult = ifelse(nser < 5, 1, 1.05) 
            par(fig = c(.75*mult, 1,.75*mult,1), new=TRUE, bty="L", cex.axis=.7*mult, cex.lab=.8*mult)
            xlab = ifelse(x$tspar[3]>1, paste('frequency', expression('\u00D7'), x$tspar[3]), 'frequency')
            plot(x$freq, x$coh[,1], type='n', ylab='Sq. Coh.', xlab=xlab, axes=FALSE, col.lab=gray(.4))
            axis(1, col=gray(.5)); axis(2, col=gray(.5))
            }
     invisible()
}

##############################################
.plotphase <-
    function(x, ci = 0.95, ylim=c(-.5, .5), gg=FALSE,
              main=NULL, ci.col=4, ci.lty = 3, scale=1, addLegend=TRUE, ...)
{
    nser <- NCOL(x$spec)
    gg2 <- 2/x$df
    se <- sqrt(gg2/2)
    z <- -qnorm((1-ci)/2)
       if (gg) scale = scale*1.05
       dev.hold(); on.exit(dev.flush())
        if (is.null(main)) main="Phase Spectrum"
        topper = ifelse(is.na(main),0,.65) 
        opar <- par(mfrow = c(nser-1, nser-1), mgp=c(1.6,.6,0), mar=c(0,0,0,0)+.5,
                   oma = c(.25,.25,0+topper,0))
        on.exit(par(opar), add = TRUE)
        plot.new()
        par(cex = par('cex')*scale)
        for (j in 2:nser) for (i in 1L:(j-1)) {
            par(mfg=c(j-1,i, nser-1, nser-1)) 
            ind <- i + (j - 1) * (j - 2)/2
            tsplot(x$freq, x$phase[, ind]/(2*pi), ylim=ylim, xlab=NA, ylab=NA, gg=gg, las=0,
                   margins=c(0,0,-.8,0)+.2, ...)  
            coh <- pmin(0.99999, sqrt(x$coh[, ind]))
            cl <- asin( pmin( 0.9999, qt(ci, 2/gg2-2)*
                             sqrt(gg2*(coh^{-2} - 1)/(2*(1-gg2)) ) ) )
            lines(x$freq, (x$phase[, ind] + cl)/(2*pi), lty=ci.lty, col=ci.col)
            lines(x$freq, (x$phase[, ind] - cl)/(2*pi), lty=ci.lty, col=ci.col)
          if (i == 1) {
              title(ylab=x$snames[j], xpd = NA, cex.lab=1.25 )
          }
          if (j == nser) {
              title(xlab=x$snames[i], xpd = NA, cex.lab=1.25)
          }
            mtext(main, side=3, line=-.65*scale, outer=TRUE, cex = 1.025*scale, font = 1)
        }
           if (addLegend){
            mult = ifelse(nser < 5, 1, 1.05) 
            par(fig = c(.75*mult, 1,.75*mult,1), new=TRUE, bty="L", cex.axis=.7*mult, cex.lab=.8*mult)
            xlab = ifelse(x$tspar[3]>1, paste('frequency', expression('\u00D7'), x$tspar[3]), 'frequency')
            plot(x$freq, x$coh[,1], type='n', ylab='phase', xlab=xlab, axes=FALSE, col.lab=gray(.4))
            axis(1, col=gray(.5)); axis(2, col=gray(.5))
            }
     invisible()
}