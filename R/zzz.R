.onAttach <- function(library, pkg){ 
			 palette(c("black","#F6483C","#00BA38","#1773CC","#00AFC4","#BA23AB","#B79F00","gray62"))
			 }
			 
.onDetach <- function(library, pkg){ 
			 palette("default")
			 }