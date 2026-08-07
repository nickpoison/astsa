\name{HmmPois}
\alias{HmmPois}
\title{Fit a Poisson Hidden Markov Model by EM}
\description{
Fits an \eqn{m}-state hidden Markov model with Poisson emissions to a
univariate count time series using the Baum-Welch (EM) algorithm.
}
\usage{
HmmPois(y, m = 2, n_perturb = 5, se = c("none", "boot"), B = 200, 
         boot_n_perturb = 1, ...)
}
\arguments{
  \item{y}{a numeric vector of non-negative integer counts (the
    observed process). Coerced internally with
    \code{as.numeric()} if not already numeric.}
  \item{m}{integer; the number of hidden states. Defaults to \code{2}.}
  \item{n_perturb}{integer; the number of additional randomized
    restarts to try, on top of the automatic k-means-based starting
    point. Each restart perturbs the automatic \code{lambda0} by a
    random factor in \eqn{[0.7, 1.3]} and re-runs the EM algorithm;
    the fit with the highest log-likelihood across all restarts is
    returned. Set to \code{0} to skip restarts and use only the
    automatic starting values. Defaults to \code{5}.}
  \item{se}{character; either \code{"none"} (the default) or
    \code{"boot"}. If \code{"boot"}, a parametric bootstrap is run
    after fitting to attach standard errors and percentile confidence
    intervals for \code{lambda} as component \code{se} of the
    returned list (see \sQuote{Value} and \sQuote{Details} below).}
  \item{B}{integer; the number of parametric bootstrap replicates to
    draw when \code{se = "boot"}. Ignored when \code{se = "none"}.
    Defaults to \code{200}.}
  \item{boot_n_perturb}{integer; the value of \code{n_perturb} used
    for each of the \code{B} internal refits during bootstrapping
    (rather than the outer \code{n_perturb}). Kept low by default
    since the bootstrap already costs \code{B} refits; increase if
    bootstrap replicates look unstable or fail to converge often.
    Ignored when \code{se = "none"}. Defaults to \code{1}.}
  \item{\dots}{additional arguments passed through to the internal EM
    engine, \code{.pois_hmm_em}, e.g. \code{maxiter} (default
    \code{500}) or \code{tol} (default \code{1e-8}), the convergence
    tolerance on successive log-likelihood values. When
    \code{se = "boot"}, these are also passed through to each internal
    bootstrap refit.}
}
\details{
Fits an \eqn{m}-state hidden Markov model with Poisson emissions to a
univariate count time series using the Baum-Welch (EM) algorithm.
Starting values for the state-dependent rates, transition matrix, and
initial-state distribution are chosen automatically via k-means
clustering of the observed counts, with optional randomized restarts
to guard against poor local optima. Standard errors and confidence
intervals for the fitted rates \code{lambda} can optionally be
obtained via a parametric bootstrap.

When \code{se = "boot"}, standard errors for \code{lambda} are
obtained by simulating \code{B} count series from the fitted model
(same \code{lambda}, \code{Gamma}, \code{delta}, and length \code{n =
length(y)}), refitting \code{fit_pois_hmm} to each simulated series,
and taking the sample standard deviation (for \code{se_boot}) and the
2.5\%/97.5\% empirical quantiles (for \code{lower95}/\code{upper95})
of the resulting \code{B} bootstrap estimates of \code{lambda}, state
by state. Percentile intervals are used rather than
\code{lambda \eqn{\pm} 1.96*se_boot} because bootstrap distributions
for Poisson rate parameters are often right-skewed, particularly in
small samples.

Each bootstrap refit is itself subject to label switching (the two
hidden states can converge in either order across replicates); this
is corrected by reordering each replicate's fitted \code{lambda} from
lowest to highest before summarizing, the same convention used by
\code{.auto_init_pois_hmm}. This heuristic works well when the states
are reasonably well separated, but can occasionally misassign when
two fitted rates are close; in that case it is worth inspecting the
raw bootstrap draws (stored only transiently inside
\code{.pois_hmm_boot}, not returned) for bimodality, e.g. by rerunning
that helper interactively.

If some simulated replicates fail to fit (an error inside the inner
\code{fit_pois_hmm} call, e.g.\ from a degenerate simulated sequence),
they are silently skipped and re-drawn, up to \code{5*B} total
attempts, after which a warning is issued reporting how many of the
\code{B} requested replicates actually converged.

Because the Poisson HMM likelihood is generally multimodal, EM only
guarantees convergence to a local maximum. The k-means-based
initialization is usually close to the global optimum for
well-separated states, and the randomized restarts (\code{n_perturb})
provide some protection against unlucky starting points, but they are
not an exhaustive search. For a thorough check, refit several times
with different \code{n_perturb} / random seeds and compare
\code{loglik} across runs.

States are labeled in increasing order of their fitted \code{lambda}
values (state 1 = lowest rate), which avoids most label-switching
ambiguity between runs.
}
\value{
A list with the following components:
\item{lambda}{numeric vector of length \code{m}; the fitted
  state-dependent Poisson rates, in natural (not log) units, ordered
  from lowest to highest.}
\item{Pmatrix}{an \code{m x m} matrix; the fitted transition matrix,
  with rows summing to 1.}
\item{delta}{numeric vector of length \code{m}; the fitted
  initial-state distribution.}
\item{pis}{numeric vector of length \code{m}; the stationary
  probabilities for each state.}
\item{loglik}{numeric; the log-likelihood at convergence.}
\item{posterior}{an \code{n x m} matrix of smoothed state
  probabilities, \eqn{P(S_t = j \mid y_{1:n})}, where \code{n =
  length(y)}. Analogous to columns 2 and beyond of
  \code{depmixS4::posterior(fm)}.}
\item{niter}{integer; the number of EM iterations run for the
  best-fitting restart.}
\item{init}{a list returned by \code{.auto_init_pois_hmm}, containing
  the automatic starting values (\code{lambda0}, \code{Gamma0},
  \code{delta0}) and the k-means/quantile-binning hard cluster
  assignments (\code{cluster}) used to construct them, useful for
  diagnostics.}
\item{se}{present only when \code{se = "boot"} was requested; a
  data frame with one row per state and columns \code{state},
  \code{lambda} (the fitted rate, sorted low to high),
  \code{se_boot} (bootstrap standard error), \code{lower95} and
  \code{upper95} (2.5\%/97.5\% percentile bootstrap confidence
  limits), and \code{n_boot} (the number of the \code{B} requested
  replicates that actually converged and were used).}
}
\note{
The returned values of  \code{lambda} are in natural units, not
root units.}
\seealso{
\code{\link{kmeans}}, \code{\link{dpois}}
}
\examples{
\dontrun{

set.seed(666)
fm <- HmmPois(EQcount, m = 2, se='boot') 

fm$delta      # initial state probabilities
fm$Pmatrix    # transition matrix
fm$lambda     # lambda estimates directly  
fm$loglik     # final log-likelihood
fm$se         # standard errors

state <- apply(fm$posterior, 1, which.max)  # MAP state path
post  <- fm$posterior                       # n x 2 smoothed state probs

pi1 <- fm$pis[1]        
pi2 <- fm$pis[2]

## -- graphics --
layout(matrix(c(1, 2, 1, 3), 2, 2), heights = c(1.2, 1))
tsplot(EQcount)
points(EQcount, bg = 6 * state - 2, pch = 21, cex = 1.5)
tsplot(ts(post[, 2], start = 1900), lwd = 2,
       ylab = expression(hat(pi)[~2] * '(t | n)'))
abline(h = .5, col = 2, lty = 6)
hist(EQcount, breaks = 30, prob = TRUE, main = NA, col = gray(.9))
xvals <- seq(1, 45)
u1 <- pi1 * dpois(xvals, fm$lambda[1])
u2 <- pi2 * dpois(xvals, fm$lambda[2])
lines(xvals, u1, col = 4, lwd = 2)
lines(xvals, u2, col = 2, lwd = 2)
}
}
\keyword{models}
\keyword{ts}
