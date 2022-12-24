polyMul <-
function(p, q){ 
m <- outer(p, q)
return(as.vector(tapply(m, row(m) + col(m), sum)))
}
