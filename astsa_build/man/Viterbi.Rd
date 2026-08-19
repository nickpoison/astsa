\name{Viterbi}
\alias{Viterbi}
\title{Viterbi Decoding for HmmFit() and MSwM::msmFit() Objects}
\description{
Decodes the single most likely hidden-state path for a fitted
hidden-state or Markov-switching model. Handles two kinds of fitted
objects through a single call: an object returned by \code{\link{HmmFit}}
(Poisson or Normal HMM), or an object returned by \code{msmFit} from the
\pkg{MSwM} package (Markov-switching regression). Which one \code{fit} is
gets auto-detected unless \code{type} is set explicitly.
}
\usage{
Viterbi(fit, x = NULL, type = c("auto", "HmmFit", "msmFit"),
        family = c("auto", "pois", "norm"), use = NULL)
}
\arguments{
  \item{fit}{The fitted model object: either a list returned by
    \code{HmmFit(x, m, family = ...)}, or an object returned by
    \code{MSwM::msmFit(...)} (class \code{"MSM.lm"} / \code{"MSM.glm"}).}
  \item{x}{(\code{type = "HmmFit"} only) Optional numeric vector: the data
    originally passed to \code{HmmFit()}. \code{HmmFit()} stores this on
    the fit object itself (\code{fit$x}), so \code{x} normally does not
    need to be supplied here -- pass it only to override \code{fit$x}
    (e.g. to decode some other series under the same fitted parameters).
    Ignored for \code{type = "msmFit"}, since \code{msmFit()} already
    stores regime-conditional residuals on the fit object
    (\code{fit@Fit@error}).}
  \item{type}{\code{"auto"} (default), \code{"HmmFit"}, or \code{"msmFit"}.
    Under \code{"auto"}, \code{fit} is treated as an \code{msmFit} object
    if it is S4 (\code{isS4(fit)}), and as an \code{HmmFit} object
    otherwise.}
  \item{family}{(\code{type = "HmmFit"} only) \code{"auto"} (default;
    detected from whether \code{fit$mu} is present), \code{"pois"}, or
    \code{"norm"}.}
  \item{use}{Which distribution to use as the initial-state prior.
    Defaults depend on \code{type}:
    \describe{
      \item{\code{type = "HmmFit"}}{\code{"delta"} (default; the model's
        own fitted initial-state estimate, \code{fit$delta}) or
        \code{"stationary"} (the long-run distribution, \code{fit$pis}).}
      \item{\code{type = "msmFit"}}{\code{"stationary"} (default; the
        stationary distribution of \code{fit@transMat}) or
        \code{"iniProb"} (\code{fit@iniProb}). \pkg{MSwM}'s own
        documentation describes \code{iniProb} ambiguously as "initial
        values of the parameters", so it is \emph{not} guaranteed to be
        the initial-state distribution -- \code{"stationary"} is the
        safer default.}
    }
  }
}
\value{
A list with:
  \item{states}{Integer vector of length \code{T}, the decoded state at
    each time point (the single most likely joint path, not a pointwise
    argmax).}
  \item{logprob}{Log-probability of that best path.}
  \item{delta}{\code{n x m} matrix of running best-path log-probabilities
    (Viterbi's dynamic-programming table), kept for diagnostics.}
  \item{psi}{\code{n x m} matrix of backpointers used to reconstruct
    \code{states}, kept for diagnostics.}

For \code{type = "HmmFit"}, an additional \code{family} element records
which emission distribution was used. For \code{type = "msmFit"}, an
additional \code{regimes} element aliases \code{states} (matching
\pkg{MSwM}'s own terminology).
}
\details{
Viterbi returns the single most likely \emph{joint} path across all
\code{T} time points -- not the same thing as taking \code{which.max} of
a filtered or smoothed probability at each \code{t} independently, which
is what, e.g., \pkg{MSwM}'s own \code{plot}/\code{plotProb} methods do
with \code{fit@Fit@smoProb}. The two will usually agree but can diverge
right around regime-switch points, since Viterbi enforces path-wide
consistency with the transition matrix while a pointwise argmax does
not.

For \code{type = "msmFit"}, note that \code{msmFit()} silently drops the
first \code{p} observations to build AR lags, so \code{states}/
\code{regimes} will be \code{p} shorter than the series originally
passed to \code{msmFit()}.
}
\seealso{
\code{\link{HmmFit}}
}

\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}

\examples{
\dontrun{
##-- HmmFit --##
fit  <- HmmFit(EQcount, m = 2, family = "pois")
path <- Viterbi(fit)   # x not needed -- HmmFit() already stored it on fit$x
tsplot(EQcount)
points(EQcount, col = path$states, pch = 16)

## compare against the smoothed-probability (pointwise) state estimate
state.pointwise <- apply(fit$posterior, 1, which.max)
table(viterbi = path$states, pointwise = state.pointwise)

##-- MSwM::msmFit --##
set.seed(1)
n  <- 300
mu <- c(-2, 2); sd_true <- c(1, 2); ar <- 0.5
Gamma_true <- matrix(c(.95, .05, .1, .9), 2, 2, byrow = TRUE)
s <- integer(n); s[1] <- 1
y <- numeric(n)
for (t in 2:n) s[t] <- sample(2, 1, prob = Gamma_true[s[t - 1], ])
for (t in 2:n) y[t] <- mu[s[t]] + ar * y[t - 1] + rnorm(1, 0, sd_true[s[t]])

library(MSwM)
## sw has length 3 here: p = 1 folds an AR(1) term into the model matrix,
## so Coef has 2 columns (intercept, ar1); sw needs one flag per
## coefficient plus one for the variance, i.e. length(sw) = ncol(Coef) + 1
fit2  <- msmFit(lm(y ~ 1), k = 2, sw = c(TRUE, TRUE, TRUE), p = 1)
path2 <- Viterbi(fit2)
table(path2$regimes)
}
}
\keyword{ts}
\keyword{models}
