Grid <-
function (nx = NULL, ny = nx, col = gray(.9), lty = 1, lwd = par("lwd"), equilogs = TRUE, 
          minor = TRUE, nxm = 2, nym = 2, tick.ratio = 0.5, ...) 
{
    if (is.null(nx) || (!is.na(nx) && nx >= 1)) {
        log <- par("xlog")
        if (is.null(nx)) {
            ax <- par("xaxp")
            if (log && equilogs && ax[3L] > 0) 
                ax[3L] <- 1
            at <- axTicks(1, axp = ax, log = log)
        }
        else {
            U <- par("usr")
            at <- seq.int(U[1L], U[2L], length.out = nx + 1)
            at <- (if (log) 
                10^at
            else at)[-c(1, nx + 1)]
        }
        abline(v = at, col = col, lty = lty, lwd = lwd)
    }
    if (is.null(ny) || (!is.na(ny) && ny >= 1)) {
        log <- par("ylog")
        if (is.null(ny)) {
            ax <- par("yaxp")
            if (log && equilogs && ax[3L] > 0) 
                ax[3L] <- 1
            at <- axTicks(2, axp = ax, log = log)
        }
        else {
            U <- par("usr")
            at <- seq.int(U[3L], U[4L], length.out = ny + 1)
            at <- (if (log) 
                10^at
            else at)[-c(1, ny + 1)]
        }
        abline(h = at, col = col, lty = lty, lwd = lwd)
    }
##	
	if(minor){nx = nxm; ny = nym; x.args = list(); y.args = list() 
    ax <- function(w, n, tick.ratio, add.args) {
    range <- par("usr")[if (w == "x") 1 : 2  else 3 : 4]
    tick.pos <- if (w == "x") par("xaxp") else par("yaxp")
    distance.between.minor <- (tick.pos[2] - tick.pos[1])/tick.pos[3]/n
    possible.minors <- tick.pos[1] - (0 : 100) * distance.between.minor
    low.candidates <- possible.minors >= range[1]
    low.minor <- if (any(low.candidates))
                   min(possible.minors[low.candidates])
                 else 
                   tick.pos[1]
    possible.minors <- tick.pos[2] + (0 : 100) * distance.between.minor
    hi.candidates <- possible.minors <= range[2]
    hi.minor <- if (any(hi.candidates)) 
                  max(possible.minors[hi.candidates])
                else
                  tick.pos[2]
    axis.args <- c(list(if (w == "x") 1 else 2,
                        seq(low.minor, hi.minor, by = distance.between.minor), 
                        labels = FALSE, tcl = par("tcl") * tick.ratio),
                        add.args);
	do.call(axis, axis.args);
    }
   if (nx > 1) 
    ax("x", nx, tick.ratio = tick.ratio, x.args)
   if (ny > 1) 
    ax("y", ny, tick.ratio = tick.ratio, y.args)
  invisible()}
##
}