mvspec <- function(x, spans = NULL, kernel = NULL, taper = 0, pad = 0, 
    fast = TRUE, demean = FALSE, detrend = TRUE, plot = TRUE, log='n',
	type = NULL, na.action = na.fail,...) 
{
     #
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
    xfreq <- frequency(x)
    x <- as.matrix(x)
    N <- N0 <- nrow(x)
    nser <- ncol(x)
    if (!is.null(spans)) 
        kernel <- {
            if (is.tskernel(spans)) 
                spans
            else kernel("modified.daniell", spans%/%2)
        }	
    if (!is.null(kernel) && !is.tskernel(kernel)) 
        stop("must specify 'spans' or a valid kernel")
    if (detrend) {
        t <- 1:N - (N + 1)/2
        sumt2 <- N * (N^2 - 1)/12
        for (i in 1:ncol(x)) x[, i] <- x[, i] - mean(x[, i]) - 
            sum(x[, i] * t) * t/sumt2
    }
    else if (demean) {
        x <- sweep(x, 2, colMeans(x))
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
        # df <- df.kernel(kernel)
        ######### bandwidth <- bandwidth.kernel(kernel)
        Lh = 1/sum(kernel[-kernel$m:kernel$m]^2)    # this is Lh  - it gets divided by N below
    } else {
        # df <- 2
        #########   bandwidth <- sqrt(1/12)    ############ fix this
        Lh <- 1
    }
    df <- 2*Lh    # df/(u4/u2^2)
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
#========================
    fxx=array(NA, dim=c(nser,nser,Nspec))
    for (k in 1:Nspec){
		fxx[,,k]=pgram[k,,]
	    }
#========================  
    details <- round( cbind(frequency=freq, period=1/freq, spectrum=spec), 4)
#======================== 
    spg.out <- list(freq = freq, spec = spec, coh = coh, phase = phase, 
        kernel = kernel, df = df, bandwidth = bandwidth,  
        fxx=fxx, Lh=Lh, n.used = N, details=details,
        orig.n = N0, series = series, snames = colnames(x), method = ifelse(!is.null(kernel), 
            "Smoothed Periodogram", "Raw Periodogram"), taper = taper, 
        pad = pad, detrend = detrend, demean = demean)
    class(spg.out) <- "spec"
    if (plot) {
        type0 <- 'n' 
        type1 <- ifelse(is.null(type), 'l', type) 
        plot(spg.out, type = type0, sub=NA, axes=FALSE, ann=FALSE, log = log, ...) 
        Grid()
        par(new=TRUE)
        plot(spg.out, log = log, type = type1, ...) 
        return(invisible(spg.out))
    }
    else return(spg.out)
}

