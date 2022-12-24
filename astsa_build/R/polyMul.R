polyMul <-
function(p, q){ 
m <- outer(p, q)
as.vector(tapply(m, row(m) + col(m), sum))
}