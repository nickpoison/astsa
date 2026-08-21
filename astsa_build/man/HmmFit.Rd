\name{HmmFit}
\alias{HmmFit}
\title{Fit a Poisson or Normal Hidden Markov Model}
\description{
Fits an \code{m}-state Poisson or Normal HMM to a time series by EM,
with automatic initialization, randomized restarts, and optional
standard errors.
}
\usage{
HmmFit(x, m = 2, family = c("pois", "norm"), \dots)
}
\arguments{
  \item{x}{Numeric vector. Counts for \code{family = "pois"},
    continuous values for \code{family = "norm"}.}
  \item{m}{Number of states.}
  \item{family}{\code{"pois"} or \code{"norm"}.}
  \item{\dots}{\code{HmmFit} itself takes only \code{x}, \code{m},
    and \code{family} as named formals; everything else below is
    collected via \code{\dots} and dispatched internally, so all of
    the following can be passed by name:
    \describe{
      \item{\code{n_perturb}}{Number of randomized restarts (both
        emission parameters and the transition matrix are
        perturbed). Default \code{5}. Set to \code{0} to fit
        \code{start} (or the automatic initializer) exactly, with no
        perturbation.}
      \item{\code{start}}{Optional list of your own starting values,
        skipping the automatic initializer. \code{family = "pois"}:
        needs \code{lambda0}, \code{Gamma0} (\code{delta0} optional,
        defaults to uniform). \code{family = "norm"}: needs
        \code{mu0}, \code{sigma0}, \code{Gamma0} (\code{delta0}
        optional). Default \code{NULL}.}
      \item{\code{se}}{\code{"hessian"} (default; asymptotic SEs
        from the observed information, requires \pkg{nlme}),
        \code{"boot"} (parametric bootstrap, slow), or
        \code{"none"}.}
      \item{\code{B}}{Bootstrap replicates, if \code{se = "boot"}.
        Default \code{200}.}
      \item{\code{boot_n_perturb}}{\code{n_perturb} to use for each
        bootstrap replicate's own fit, if \code{se = "boot"}. Default
        \code{1} -- deliberately smaller than the main fit's
        \code{n_perturb}, since \code{B} replicate fits each doing
        many restarts is expensive; raise it if bootstrap replicates
        are converging to visibly different log-likelihoods.}
      \item{\code{n_cores}}{Cores for the bootstrap. Fork-based on
        Unix; falls back to a \code{PSOCK} cluster on Windows.
        Default \code{1}.}
      \item{\code{order_by}}{State ordering: \code{"mean"} (default)
        or \code{"sd"} (useful when states differ mainly in spread,
        e.g. volatility regimes).}
      \item{\code{init_method}}{\code{family = "norm"} only; if
        supplied with \code{family = "pois"} a warning is issued and
        it is ignored (there is only one automatic initializer for
        the Poisson case). Also unused if \code{start} is supplied.
        Controls which automatic starting-value strategy is used --
        see \strong{Automatic Initialization} below. \code{"auto"}
        (default) tries both \code{"location"} and
        \code{"volatility"} and keeps whichever converges to the
        higher log-likelihood; \code{"location"} or
        \code{"volatility"} forces one directly, which is faster and
        useful once you know which kind of regime structure your
        series has.}
      \item{\code{maxiter}}{Passed to the EM engine: iteration cap.
        Default \code{500}.}
      \item{\code{tol}}{Passed to the EM engine: log-likelihood
        convergence tolerance. Default \code{1e-8}.}
      \item{\code{qres_seed}}{\code{family = "pois"} only: an
        optional seed for the randomized (jittered) quantile
        residuals -- see \strong{Quantile Residuals} below. Default
        \code{NULL} means the jitter is not fixed and will vary
        slightly between identical calls.}
    }
  }
}
\value{
A list with:
  \item{lambda}{(pois) fitted rates.}
  \item{mu, sigma}{(norm) fitted means and SDs.}
  \item{x}{The (numeric-stripped) data originally passed in, stored so
    that later calls -- e.g. \code{\link{Viterbi}} -- don't need it
    supplied again separately.}
  \item{Pmatrix}{Fitted transition matrix.}
  \item{delta}{Fitted initial-state distribution.}
  \item{pis}{Stationary distribution of \code{Pmatrix}.}
  \item{loglik}{Log-likelihood at convergence.}
  \item{posterior}{Smoothed state probabilities (n x m).}
  \item{resid}{Numeric vector (length \code{n}) of one-step-ahead
    quantile (normal pseudo-)residuals, one entry per time point.
    See \strong{Quantile Residuals} below.}
  \item{AIC, BIC, npar}{Information criteria and parameter count.}
  \item{se}{If requested, a data frame of SEs/CIs.}
}

\section{Starting Values}{
  Starting values are optional -- if \code{start} is omitted,
  \code{HmmFit} builds its own from the data (see
  \strong{Automatic Initialization} below). When supplying
  \code{start} manually, the following elements are used to
  initialize the EM algorithm:
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

\section{Automatic Initialization}{
  When \code{start} is not supplied, \code{HmmFit} derives starting
  values from \code{x} itself rather than using fixed defaults (e.g.
  quantile-spaced means and a diagonal-heavy \code{Gamma}), because a
  data-driven starting point lands EM much closer to a good local
  maximum than an arbitrary one, particularly once \code{m > 2}.

  \strong{Hard clustering step.} The core idea is the same for both
  families: run \code{\link{kmeans}} on a 1-D summary of the series
  with \code{centers = m} and \code{nstart = 25} (25 random starts of
  k-means itself, to avoid a bad k-means initialization compounding
  into a bad HMM initialization), producing a hard state label for
  every time point. The cluster centers become the starting emission
  parameters, and empirical transition counts between consecutive
  hard labels (with a small \code{+0.5} pseudo-count added to every
  cell, so no row of \code{Gamma0} is ever exactly zero) become
  \code{Gamma0}; the marginal label frequencies become \code{delta0}.
  Clusters are always relabeled by sorted center so that state 1 is
  the lowest-rate/lowest-mean state, matching the package's
  convention that \code{lambda}/\code{mu} come back sorted.

  \strong{What is clustered differs by family/method}:
  \describe{
    \item{\code{family = "pois"}}{k-means runs directly on \code{x}.
      There is only one initializer for the Poisson case, so
      \code{init_method} does not apply here; passing it anyway
      triggers a warning and is otherwise ignored.}
    \item{\code{family = "norm"}, \code{init_method = "location"}}{
      k-means runs directly on \code{x}, exactly as in the Poisson
      case. This is the right choice when states differ mainly in
      \emph{level} -- e.g. low/medium/high readings.}
    \item{\code{family = "norm"}, \code{init_method = "volatility"}}{
      k-means instead runs on the log of a rolling local variance of
      \code{x} (window width \code{w = max(3, min(10, n / (2*m)))}).
      This targets states that differ mainly in \emph{spread} rather
      than level -- e.g. calm vs. turbulent regimes in a returns
      series like \code{sp500w}, where every state has a mean near
      zero and the log transform is used because variances are
      skewed and strictly positive. This initializer is skipped
      entirely if \code{n < 5*m} (too few points per state to
      estimate a rolling variance sensibly).}
    \item{\code{family = "norm"}, \code{init_method = "auto"}
      (the default)}{both of the above are tried, each is run
      through the EM engine, and whichever reaches the higher
      log-likelihood is kept as the base starting point before
      \code{n_perturb} restarts are layered on top. This costs one
      extra EM run but removes the need to know in advance whether a
      series' regimes differ in level or in spread.}
  }

  \strong{Small-sample fallback.} If \code{n < 5*m} (too few
  observations per state for k-means to be trustworthy),
  \code{HmmFit} instead bins \code{x} into \code{m} contiguous groups
  by \emph{rank} (via \code{\link{rank}(x, ties.method = "first")},
  split into \code{m} roughly equal-sized contiguous blocks) and uses
  the within-bin means (and, for \code{family = "norm"}, within-bin
  SDs) as starting values, with the same pseudo-count treatment for
  \code{Gamma0}. Rank-based binning is used rather than empirical
  quantile cutpoints (e.g. via \code{\link{cut}}) because quantile
  cutpoints are not guaranteed to be unique when \code{x} has ties --
  the norm for small samples of count data -- which can otherwise
  leave a bin empty or produce a non-unique-breaks error; ranks are
  always unique regardless of ties, so every bin is guaranteed
  non-empty whenever \code{n >= m}.

  \strong{Randomized restarts (\code{n_perturb}).} Because EM/Baum-Welch
  only guarantees convergence to \emph{a} local maximum, not the
  global one, \code{HmmFit} does not stop at the single k-means-based
  starting point. It additionally fits \code{n_perturb} perturbed
  variants (default 5) built by jittering the winning initializer:
  emission parameters are jittered multiplicatively
  (\code{lambda}/\code{sigma}, by a \code{runif(m, 0.7, 1.3)} factor)
  or additively on the natural scale (\code{mu}, by mean-zero normal
  noise scaled to \code{0.3 * sd(x)}), and each row of \code{Gamma0}
  is mixed with a fresh random point on the simplex (a
  \code{Dirichlet(1,...,1)} draw) at a random mixing strength between
  \code{0.1} and \code{0.7} via the internal \code{.perturb_gamma()}
  helper. Note that the jittered emission parameters are \emph{not}
  individually re-sorted before each restart's EM run -- EM's
  likelihood does not depend on state-label order, and re-sorting a
  jittered emission vector without applying the same permutation to
  its paired \code{Gamma0} would create an inconsistent starting
  point. Instead, whichever restart wins is canonically relabeled
  \emph{once}, by sorted rate/mean, after all restarts have been
  compared -- so \code{lambda}/\code{mu} (and correspondingly
  \code{Pmatrix}, \code{delta}, \code{pis}, \code{posterior}) always
  come back in the package's usual sorted-state convention regardless
  of which restart produced the best fit. Every perturbed fit that
  converges to a higher log-likelihood than the current best replaces it, so the final
  result is the best of \code{1 + n_perturb} EM runs (times 2 if
  \code{init_method = "auto"}). Set \code{n_perturb = 0} to fit the
  automatic (or user-supplied \code{start}) initializer exactly, with
  no restarts -- useful for reproducing a specific fit or when you
  already trust your starting point (e.g. an exact saddle point you
  want to test EM's behavior at).

  \strong{Practical guidance.} For quick exploratory fits, the
  defaults are usually fine. For a final/reported fit, especially
  with \code{m >= 3}, consider increasing \code{n_perturb}
  (e.g. to 20-50) and checking that the reported \code{loglik} is
  stable across re-runs; if it isn't, the likelihood surface likely
  has multiple competing local maxima and it is worth also trying a
  hand-chosen \code{start} informed by a plot of the data (as in the
  three-state \code{sp500w} example below).
}

\section{Quantile Residuals}{
  \code{HmmFit} also reports   \emph{one-step-ahead quantile residuals} 
  in \code{resid} (a   plain numeric vector) , These transform each 
  observation onto the scale of the standard normal distribution 
  via its one-step-ahead predictive CDF, so that residual diagnostics 
  can be read the same way regardless of whether \code{family} is \code{"pois"} or
  \code{"norm"}.
}

\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}

\seealso{\code{\link{Viterbi}} 
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
# residuals diagnostics 
ts.diag(fit$resid, col=4, Qstat=FALSE)

#-- Normal --##
# the graphics for these follow the Poisson example with appropriate name changes
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
