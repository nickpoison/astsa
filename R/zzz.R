.onAttach <- function(library, pkg){ 
			 palette(c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62"))
			 }
			 
.onDetach <- function(library, pkg){ 
			 palette("default")
			 }	 