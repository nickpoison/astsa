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
       n_perturb = 5, start = NULL, se = c("hessian", "boot", "none"),
       B = 200, n_cores = 1, order_by = c("mean", "sd"), \dots)
}
\arguments{
  \item{y}{Numeric vector. Counts for \code{family = "pois"},
    continuous values for \code{family = "norm"}.}
  \item{m}{Number of states.}
  \item{family}{\code{"pois"} or \code{"norm"}.}
  \item{n_perturb}{Number of randomized restarts (both emission
    parameters and the transition matrix are perturbed). Set to
    \code{0} to fit \code{start} exactly, with no perturbation.}
  \item{start}{Optional list of your own starting values, skipping
    the automatic initializer. \code{family = "pois"}: needs
    \code{lambda0}, \code{Gamma0} (\code{delta0} optional, defaults
    to uniform). \code{family = "norm"}: needs \code{mu0},
    \code{sigma0}, \code{Gamma0} (\code{delta0} optional).}
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

\section{Starting Values}{
  Starting values are optional.  
  When supplying \code{start} manually, the following elements are
  used to initialize the EM algorithm:
  \describe{
    \item{\code{lambda0}}{(\code{family = "pois"}) Numeric vector of
      length \code{m} giving starting values for the Poisson rate in
      each state.}
    \item{\code{mu0}}{(\code{family = "norm"}) Numeric vector of
      length \code{m} giving starting values for the mean in each
      state.}
    \item{\code{sigma0}}{(\code{family = "norm"}) Numeric vector of
      length \code{m} giving starting values for the standard
      deviation in each state. Must be positive.}
    \item{\code{Gamma0}}{An \code{m x m} matrix of starting
      transition probabilities. Each row must sum to 1.}
    \item{\code{delta0}}{Optional numeric vector of length \code{m}
      giving the starting initial-state distribution. Must sum to 1.
      If omitted, defaults to a uniform distribution,
      \code{rep(1/m, m)}.}
  }
  These values are only a starting point for the EM iterations
  (further randomized by \code{n_perturb}, unless it is set to
  \code{0}); the fitted values are returned in the output list
  (\code{lambda}/\code{mu}, \code{sigma}, \code{Pmatrix}, \code{delta}).
}

\examples{
\dontrun{

##-- Poisson --##
fit <- HmmFit(EQcount, m = 2, family = "pois")
fit$lambda; fit$Pmatrix; fit$se
state <- apply(fit$posterior, 1, which.max)   # predicted state
post  <- fit$posterior                        # n x 2 smoothed state probs  
# graphics 
pi1 <- fit$pis[1];  pi2 <- fit$pis[2]   # stationary probs
layout(matrix(c(1, 2, 1, 3), 2, 2), heights = c(1.2, 1))
tsplot(EQcount)
points(EQcount, bg = 6 * state - 2, pch = 21, cex = 1.5)
tsplot(ts(post[, 2], start = 1900), ylab = expression(hat(pi)[~2] * '(t | n)'))
abline(h = .5, col = 2, lty = 6)
hist(EQcount, breaks = 30, prob = TRUE, main = NA, col = gray(.9))
xvals <- seq(1, 45)
u1 <- pi1 * dpois(xvals, fit$lambda[1])
u2 <- pi2 * dpois(xvals, fit$lambda[2])
lines(xvals, u1, col = 4, lwd = 2)
lines(xvals, u2, col = 2, lwd = 2)

#-- Normal --##
fit <- HmmFit(sp500w, m = 2, family = "norm", order_by = "sd")
fit$mu; fit$sigma; fit$se

# use your own kind of starting values
fit <- HmmFit(sp500w, m = 3, family = "norm", order_by = "sd", n_perturb = 0,
            start = list(mu0 = c(.004, -.034, -.003),
                        sigma0 = c(.014, .009, .044),
                        Gamma0 = matrix(c(.945,.055,.000,
                                          .739,.000,.261,
                                          .032,.027,.942), 3, 3, byrow = TRUE)))
}
}
\keyword{ts}
\keyword{models}
