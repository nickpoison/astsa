R: Fit a Poisson or Normal Hidden Markov Model



| HmmFit {astsa} | R Documentation |
| --- | --- |

## Fit a Poisson or Normal Hidden Markov Model

### Description

Fits an `m`-state Poisson or Normal HMM to a time series by EM,with automatic initialization, randomized restarts, and optionalstandard errors.

### Usage

```
HmmFit(x, m = 2, family = c("pois", "norm"),
       n_perturb = 5, start = NULL, se = c("hessian", "boot", "none"),
       B = 200, n_cores = 1, order_by = c("mean", "sd"),
       init_method = c("auto", "location", "volatility"), ...)

```

### Arguments



| `x` | Numeric vector. Counts for `family = "pois"`,<br>continuous values for `family = "norm"`. |
| --- | --- |
| `m` | Number of states. |
| `family` | `"pois"` or `"norm"`. |
| `n_perturb` | Number of randomized restarts (both emission<br>parameters and the transition matrix are perturbed). Set to<br>`0` to fit `start` exactly, with no perturbation. |
| `start` | Optional list of your own starting values, skipping<br>the automatic initializer. `family = "pois"`: needs<br>`lambda0`, `Gamma0` ( `delta0` optional, defaults<br>to uniform). `family = "norm"`: needs `mu0`,<br>`sigma0`, `Gamma0` ( `delta0` optional). |
| `se` | `"hessian"` (default; asymptotic SEs from the<br>observed information, requires nlme), `"boot"`<br>(parametric bootstrap, slow), or `"none"`. |
| `B` | Bootstrap replicates, if `se = "boot"`. |
| `n_cores` | Cores for the bootstrap. Fork-based on Unix; falls<br>back to a `PSOCK` cluster on Windows. |
| `order_by` | State ordering: `"mean"` (default) or<br>`"sd"` (useful when states differ mainly in spread, e.g.<br>volatility regimes). |
| `init_method` | `family = "norm"` only; if supplied with<br>`family = "pois"` a warning is issued and it is ignored<br>(there is only one automatic initializer for the Poisson case).<br>Also unused if `start` is supplied. Controls which automatic<br>starting-value<br>strategy is used – see **Automatic Initialization** below.<br>`"auto"` (default) tries both `"location"` and<br>`"volatility"` and keeps whichever converges to the higher<br>log-likelihood; `"location"` or `"volatility"` forces<br>one directly, which is faster and useful once you know which<br>kind of regime structure your series has. |
| `...` | Passed to the EM engine: `maxiter` (default 500)<br>and `tol` (default `1e-8`), the iteration cap and<br>log-likelihood convergence tolerance. Also accepts<br>`qres_seed` ( `family = "pois"` only): an optional seed<br>for the randomized (jittered) quantile residuals – see<br>**Quantile Residuals** below. Default `NULL` means the<br>jitter is not fixed and will vary slightly between identical<br>calls. |

### Value

A list with:



| `lambda` | (pois) fitted rates. |
| --- | --- |
| `mu`, `sigma` | (norm) fitted means and SDs. |
| `Pmatrix` | Fitted transition matrix. |
| `delta` | Fitted initial-state distribution. |
| `pis` | Stationary distribution of `Pmatrix`. |
| `loglik` | Log-likelihood at convergence. |
| `posterior` | Smoothed state probabilities (n x m). |
| `resid` | Numeric vector (length `n`) of one-step-ahead<br>quantile (normal pseudo-)residuals, one entry per time point.<br>See **Quantile Residuals** below. |
| `AIC`, `BIC`, `npar` | Information criteria and parameter count. |
| `se` | If requested, a data frame of SEs/CIs. |

### Starting Values

Starting values are optional – if `start` is omitted,`HmmFit` builds its own from the data (see**Automatic Initialization** below). When supplying`start` manually, the following elements are used toinitialize the EM algorithm:

`lambda0`

( `family = "pois"`) Numeric vector oflength `m` giving starting values for the Poisson rate ineach state.

`mu0`

( `family = "norm"`) Numeric vector oflength `m` giving starting values for the mean in eachstate.

`sigma0`

( `family = "norm"`) Numeric vector oflength `m` giving starting values for the standarddeviation in each state. Must be positive.

`Gamma0`

An `m x m` matrix of startingtransition probabilities. Each row must sum to 1.

`delta0`

Optional numeric vector of length `m`giving the starting initial-state distribution. Must sum to 1.If omitted, defaults to a uniform distribution,`rep(1/m, m)`.

These values are only a starting point for the EM iterations(further randomized by `n_perturb`, unless it is set to`0`); the fitted values are returned in the output list( `lambda`/ `mu`, `sigma`, `Pmatrix`, `delta`).

### Automatic Initialization

When `start` is not supplied, `HmmFit` derives startingvalues from `x` itself rather than using fixed defaults (e.g.quantile-spaced means and a diagonal-heavy `Gamma`), because adata-driven starting point lands EM much closer to a good localmaximum than an arbitrary one, particularly once `m > 2`.

**Hard clustering step.** The core idea is the same for bothfamilies: run `kmeans` on a 1-D summary of the serieswith `centers = m` and `nstart = 25` (25 random starts ofk-means itself, to avoid a bad k-means initialization compoundinginto a bad HMM initialization), producing a hard state label forevery time point. The cluster centers become the starting emissionparameters, and empirical transition counts between consecutivehard labels (with a small `+0.5` pseudo-count added to everycell, so no row of `Gamma0` is ever exactly zero) become`Gamma0`; the marginal label frequencies become `delta0`.Clusters are always relabeled by sorted center so that state 1 isthe lowest-rate/lowest-mean state, matching the package'sconvention that `lambda`/ `mu` come back sorted.

**What is clustered differs by family/method**:

`family = "pois"`

k-means runs directly on `x`.There is only one initializer for the Poisson case, so`init_method` does not apply here; passing it anywaytriggers a warning and is otherwise ignored.

`family = "norm"`, `init_method = "location"`

k-means runs directly on `x`, exactly as in the Poissoncase. This is the right choice when states differ mainly in*level* – e.g. low/medium/high readings.

`family = "norm"`, `init_method = "volatility"`

k-means instead runs on the log of a rolling local variance of`x` (window width `w = max(3, min(10, n / (2*m)))`).This targets states that differ mainly in *spread* ratherthan level – e.g. calm vs. turbulent regimes in a returnsseries like `sp500w`, where every state has a mean nearzero and the log transform is used because variances areskewed and strictly positive. This initializer is skippedentirely if `n < 5*m` (too few points per state toestimate a rolling variance sensibly).

`family = "norm"`, `init_method = "auto"`(the default)

both of the above are tried, each is runthrough the EM engine, and whichever reaches the higherlog-likelihood is kept as the base starting point before`n_perturb` restarts are layered on top. This costs oneextra EM run but removes the need to know in advance whether aseries' regimes differ in level or in spread.

**Small-sample fallback.** If `n < 5*m` (too fewobservations per state for k-means to be trustworthy),`HmmFit` instead bins `x` into `m` contiguous groupsby *rank* (via `rank(x, ties.method = "first")`,split into `m` roughly equal-sized contiguous blocks) and usesthe within-bin means (and, for `family = "norm"`, within-binSDs) as starting values, with the same pseudo-count treatment for`Gamma0`. Rank-based binning is used rather than empiricalquantile cutpoints (e.g. via `cut`) because quantilecutpoints are not guaranteed to be unique when `x` has ties –the norm for small samples of count data – which can otherwiseleave a bin empty or produce a non-unique-breaks error; ranks arealways unique regardless of ties, so every bin is guaranteednon-empty whenever `n >= m`.

**Randomized restarts ( `n_perturb`).** Because EM/Baum-Welchonly guarantees convergence to *a* local maximum, not theglobal one, `HmmFit` does not stop at the single k-means-basedstarting point. It additionally fits `n_perturb` perturbedvariants (default 5) built by jittering the winning initializer:emission parameters are jittered multiplicatively( `lambda`/ `sigma`, by a `runif(m, 0.7, 1.3)` factor)or additively on the natural scale ( `mu`, by mean-zero normalnoise scaled to `0.3 * sd(x)`), and each row of `Gamma0`is mixed with a fresh random point on the simplex (a`Dirichlet(1,...,1)` draw) at a random mixing strength between`0.1` and `0.7` via the internal `.perturb_gamma()`helper. Note that the jittered emission parameters are *not*individually re-sorted before each restart's EM run – EM'slikelihood does not depend on state-label order, and re-sorting ajittered emission vector without applying the same permutation toits paired `Gamma0` would create an inconsistent startingpoint. Instead, whichever restart wins is canonically relabeled*once*, by sorted rate/mean, after all restarts have beencompared – so `lambda`/ `mu` (and correspondingly`Pmatrix`, `delta`, `pis`, `posterior`) alwayscome back in the package's usual sorted-state convention regardlessof which restart produced the best fit. Every perturbed fit thatconverges to a higher log-likelihood than the current best replaces it, so the finalresult is the best of `1 + n_perturb` EM runs (times 2 if`init_method = "auto"`). Set `n_perturb = 0` to fit theautomatic (or user-supplied `start`) initializer exactly, withno restarts – useful for reproducing a specific fit or when youalready trust your starting point (e.g. an exact saddle point youwant to test EM's behavior at).

**Practical guidance.** For quick exploratory fits, thedefaults are usually fine. For a final/reported fit, especiallywith `m >= 3`, consider increasing `n_perturb`(e.g. to 20-50) and checking that the reported `loglik` isstable across re-runs; if it isn't, the likelihood surface likelyhas multiple competing local maxima and it is worth also trying ahand-chosen `start` informed by a plot of the data (as in thethree-state `sp500w` example below).

### Quantile Residuals

`HmmFit` also reports *one-step-ahead quantile residuals*in `resid` (a plain numeric vector) , These transform eachobservation onto the scale of the standard normal distributionvia its one-step-ahead predictive CDF, so that residual diagnosticscan be read the same way regardless of whether `family` is `"pois"` or`"norm"`.

### Examples

[Run examples](../Example/HmmFit)

```
## Not run:

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

## End(Not run)

```

---

\[Package *astsa* version 2.5.1 [Index](00Index.html)\]

# Contents

- [Description](#_sec_description)
- [Usage](#_sec_usage)
- [Arguments](#_sec_arguments)
  - [](#x)
  - [](#m)
  - [](#family)
  - [](#n_perturb)
  - [](#start)
  - [](#se)
  - [](#B)
  - [](#n_cores)
  - [](#order_by)
  - [](#init_method)
  - [](#...)
- [Value](#_sec_value)
- [Starting Values](#Starting-Values)
- [Automatic Initialization](#Automatic-Initialization)
- [Quantile Residuals](#Quantile-Residuals)
- [Examples](#_sec_examples)
