bart <-
function(m){
mkName <- function(name, args) paste0(name, "(", paste(args, collapse = ","), ")")
#
if (length(m) == 1L){ 
v = seq(m+1,1,by=-1)
v = v/sum(c(v, v[-1]))
return(stats::kernel(v, name='Bartlett'))
} else {
 k <- Recall(m[1L])
 for (i in 2L:length(m)) k <- stats::kernapply(k, Recall(m[i]))
 attr(k, "name") <- mkName("Bartlett", m)
 return(k)
}
}