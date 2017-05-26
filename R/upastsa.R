# check if devtools is installed
if (!'devtools' %in% installed.packages()[,1]) install.packages(devtools)   
# update astsa
devtools::install_github("nickpoison/astsa")
