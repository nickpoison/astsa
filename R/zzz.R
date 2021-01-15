.onAttach <- function(library, pkg){ 
			 palette(c("black","#F8766D","#00BA38","#1773CC","#00BFC4","#F564E3","#B79F00","gray62"))
			 }
			 
.onDetach <- function(library, pkg){ 
			 palette("default")
			 }			 