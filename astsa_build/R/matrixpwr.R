matrixpwr <-
function(A, power) {
  if (!is.numeric(power) || length(power) != 1 || !is.finite(power))
    stop("power must be a single finite number")
  if (!is.matrix(A))
    stop("object not a matrix")
  if (nrow(A) != ncol(A))
    stop("matrix must be square")
  if (power == 0) return(diag(1, nrow(A)))
  if (power == 1) return(A)

  # For negative powers check near-singularity via condition number
  if (power < 0 && rcond(A) < .Machine$double.eps)
    stop("matrix is (near-)singular")

  e <- eigen(A)

  if (isSymmetric(unname(A))) {
    tcrossprod(e$vectors * rep(e$values^power, each=nrow(A)), e$vectors)
  } else {
    e$vectors %*% (e$values^power * solve(e$vectors))
  }
}

"%^%" <- function(A, power) matrixpwr(A, power)
