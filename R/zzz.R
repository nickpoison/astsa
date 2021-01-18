.onAttach <- function(library, pkg){ 
			 palette(c("black","#F6483C","#00BA38","#1773CC","#0D9AC0","#BA23AB","#C47700","gray62"))
			 }
			 
.onDetach <- function(library, pkg){ 
			 palette("default")
			 }