\name{HmmFit}
\alias{HmmFit}
\title{Fit a Poisson or Normal Hidden Markov Model}
\description{
Fits an \code{m}-state Poisson or Normal HMM to a time series by EM,
with automatic initialization, randomized restarts, and optional
standard errors.
}
\usage{
HmmFit(y, m = 2, family = c("pois", "norm"),
       n_perturb = 5, se = c("hessian", "boot", "none"),
       B = 200, n_cores = 1, order_by = c("mean", "sd"), \dots)
}
\arguments{
  \item{y}{Numeric vector. Counts for \code{family = "pois"},
    continuous values for \code{family = "norm"}.}
  \item{m}{Number of states.}
  \item{family}{\code{"pois"} or \code{"norm"}.}
  \item{n_perturb}{Number of randomized restarts (both emission
    parameters and the transition matrix are perturbed).}
  \item{se}{\code{"hessian"} (default; asymptotic SEs from the
    observed information, requires \pkg{nlme}), \code{"boot"}
    (parametric bootstrap, slow), or \code{"none"}.}
  \item{B}{Bootstrap replicates, if \code{se = "boot"}.}
  \item{n_cores}{Cores for the bootstrap. Fork-based on Unix; falls
    back to a \code{PSOCK} cluster on Windows.}
  \item{order_by}{State ordering: \code{"mean"} (default) or
    \code{"sd"} (useful when states differ mainly in spread, e.g.
    volatility regimes).}
  \item{\dots}{Passed to the EM engine (\code{maxiter}, \code{tol}) or,
    for \code{family = "norm"}, \code{init_method}.}
}
\value{
A list with:
  \item{lambda}{(pois) fitted rates.}
  \item{mu, sigma}{(norm) fitted means and SDs.}
  \item{Pmatrix}{Fitted transition matrix.}
  \item{delta}{Fitted initial-state distribution.}
  \item{pis}{Stationary distribution of \code{Pmatrix}.}
  \item{loglik}{Log-likelihood at convergence.}
  \item{posterior}{Smoothed state probabilities (n x m).}
  \item{AIC, BIC, npar}{Information criteria and parameter count.}
  \item{se}{If requested, a data frame of SEs/CIs.}
}
\examples{

\dontrun{
fit <- HmmFit(EQcount, m = 2, family = "pois")
fit$lambda; fit$Pmatrix; fit$se

fit <- HmmFit(sp500w, m = 2, family = "norm", order_by = "sd")
fit$mu; fit$sigma; fit$se
}
}
\keyword{ts}
\keyword{models}
