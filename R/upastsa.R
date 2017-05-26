upastsa <- function(check=TRUE){
# check if devtools is installed
if(check) {if (!'devtools' %in% installed.packages()[,1]) install.packages(devtools) } 
# update astsa
devtools::install_github("nickpoison/astsa")
}