tspairs <-
    function(x, main=NA, pt.col=astsa.col(4,.6), pt.size=1.1, lab.size=1.25, 
             title.size=1.5, scale=1, corr=TRUE, smooth=TRUE, lwl=1, lwc=2, gg=FALSE, 
             hist.diag=TRUE, col.diag=4, location='topright', ...)
{
    nser <- NCOL(x)
    if (nser < 2) stop('need at least 2 series')

    # Convert to matrix to avoid repeated coercion inside the loop
    x <- as.matrix(x)

    old.par <- par(no.readonly = TRUE)
    on.exit(par(old.par))  

    colnames(x) <- colnames(x, do.NULL=FALSE, prefix="Ser.")
    topper <- ifelse(is.na(main), 0, 2)

    # Compute full correlation matrix  
    Corr <- cor(x)

    # Pre-format all correlation labels  
    Corr_labels <- matrix(format(round(Corr, digits=2), nsmall=2), nrow=nser, ncol=nser)

    # Pre-compute histograms for diagonal panels if needed
    hist_data <- if (hist.diag) {
        lapply(seq_len(nser), function(i) hist(x[, i], plot=FALSE))
    } else {
        NULL
    }

    # Pre-compute LOWESS smooths  
    smooth_data <- if (smooth) {
        pairs <- vector("list", nser * nser)
        for (j in seq_len(nser)) {
            for (i in seq_len(nser)) {
                if (i != j) pairs[[( j - 1) * nser + i]] <- lowess(x[, i], x[, j])
            }
        }
        pairs
    } else {
        NULL
    }

    # Pre-compute colors once
    bgc <- if (gg) gray(.92, .3) else gray(1, .3)
    box_col <- if (gg) gray(.8) else gray(.62)

    par(mfrow=c(nser, nser), mgp=c(1.6, .6, 0), oma=c(.25, .25, .1 + topper, .1) * scale)
    par(cex=par('cex') * scale)

    for (j in seq_len(nser)) {
        for (i in seq_len(nser)) {
            if (i == j) {
                par(bty='l')
                if (hist.diag) {
                    xh <- hist_data[[i]]
                    tsplot(xh$counts, ylab=NA, xlab=NA, type='n', gg=gg, main=NA, minor=FALSE,
                           xlim=range(xh$breaks), ylim=c(0, max(xh$counts)), ...)
                    hist(x[, i], col=adjustcolor(col.diag, .5), border=col.diag, axes=FALSE, add=TRUE)
                    if (gg) box(col=gray(1))
                } else {
                    tsplot(x[, i], ylab=NA, xlab=NA, col=col.diag, gg=gg, main=NA, ...)
                }
            } else {
                par(bty='o')
                tsplot(x[, i], x[, j], type='p', xlab=NA, ylab=NA,
                       margins=c(0, 0, -.8, 0) + .2, col=pt.col, cex=pt.size, gg=gg, ...)
                if (smooth) lines(smooth_data[[(j - 1) * nser + i]], col=lwc, lwd=lwl)
                if (corr) {
                    legend(location, legend=Corr_labels[i, j],
                           box.col=gray(1, 0), bg=bgc, adj=.25)
                }
                box(col=box_col)
            }
            if (i == 1) title(ylab=colnames(x)[j], xpd=NA, cex.lab=lab.size)
            if (j == nser) title(xlab=colnames(x)[i], xpd=NA, cex.lab=lab.size)
            mtext(main, side=3, line=0, outer=TRUE, font=1, cex=title.size * scale)
        }
    }
}
