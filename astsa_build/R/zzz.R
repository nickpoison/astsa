.onLoad <- function(libname, pkgname){ 
		 palette(c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62"))
		}

.onUnload <- function(libpath){ 
		 palette("default")
		 }

# below were used for `stats::pairs` in `ar.boot` and `ar.mcmc` and
#    maybe elsewhere, but `tspairs` has replaced these in v2.3
#
# .panelcor is in the printed 5th edition of tsa5 for something else
#   as astsa:::.panelcor so it has to remain, but
# .panelhist is no longer used - it's here in case we missed something
#   or is being used

.panelcor <- function(x, y, ...){
usr <- par("usr") 
par(usr = c(0, 1, 0, 1))
r <- round(cor(x, y), 2)
text(0.5, 0.5, r, cex = 1.5)
}


.panelhist <- function(x, ...){
    usr <- par("usr") 
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, ...)
}
