.onLoad <- function(libname, pkgname){  # astsa palette
		 palette(c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62"))
		}

.onUnload <- function(libpath){  # restore default palette
		 palette("default")
		 }


.onAttach <- function(libname, pkgname) {  # ask if want to install xts
  # Check if in an interactive session
  if (interactive()) {
    # Define the package to suggest
    suggested_package <- "xts"

    # Check if the suggested package is already installed
    if (!requireNamespace(suggested_package, quietly = TRUE)) {
      # Prompt the user
      response <- menu(c("Yes", "No"), title = paste0("Would you like to install the '", suggested_package, "' package?"))

      # Install if the user chooses 'Yes'
      if (response == 1) {
        message(paste0("Installing '", suggested_package, "'..."))
        tryCatch({
          install.packages(suggested_package)
          message(paste0("'", suggested_package, "' installed successfully."))
        }, error = function(e) {
          warning(paste0("Failed to install '", suggested_package, "': ", e$message))
        })
      } else {
        message(paste0("Skipping installation of '", suggested_package, "'."))
      }
    }
  }
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
