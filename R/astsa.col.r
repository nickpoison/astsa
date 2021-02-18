astsa.col <- function(col=1, alpha=1) {  
     u <- c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62")
	 culers = u[(col+8-1)%%8 +1]
	 grDevices::adjustcolor(culers, alpha=alpha)
	 }
