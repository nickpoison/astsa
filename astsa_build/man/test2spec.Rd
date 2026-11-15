\name{test2spec}
\alias{test2spec}
\title{Two-Sample Test for Equality of Spectral Densities}
\description{
Tests the null hypothesis that two stationary series have the same spectral density. By default the series are assumed to be independent and may have different sample sizes. With \code{dependent = TRUE}, series of equal length observed at the same time points may be correlated with an unspecified cross-dependence. The test is based on a divergence between smoothed periodogram estimates, with a frequency domain bootstrap under the pooled spectrum.
}
\usage{
test2spec(x1, x2, kernel = "modified.daniell", r = NULL,
          bandwidth = NULL, spans1 = NULL, spans2 = NULL,
          B = 1000, n_grid = NULL, divergence = c("is", "log"),
          normalize = FALSE, taper = 0, seed = NULL,
          dependent = FALSE, max_coh = 0.99, coh_correct = TRUE)
}
\arguments{
  \item{x1, x2}{numeric series. Unless \code{dependent = TRUE}, the series may have different lengths and are assumed to be independent of each other. If \code{dependent = TRUE}, they must have the same length and be observed at the same time points. Missing values are not allowed.}

  \item{kernel}{the smoothing kernel. Either a name: \code{"modified.daniell"} (default), \code{"daniell"}, \code{"bartlett"} (see \code{\link{bart}}), \code{"dirichlet"} or \code{"fejer"} (see \code{\link[stats]{kernel}}); or a \code{tskernel} object, used for both series; or a list of two \code{tskernel} objects, one for each series. A user supplied kernel fixes the smoothing, so \code{bandwidth}, \code{spans1} and \code{spans2} are then ignored.}

  \item{r}{the parameter \code{r} required by the \code{"dirichlet"} and \code{"fejer"} kernels; ignored otherwise.}

  \item{bandwidth}{common smoothing half-bandwidth in cycles per observation. Series \eqn{i} is smoothed with half-width \eqn{m_i = }\code{round(bandwidth * n_i)} Fourier frequencies, so both estimators smooth over about the same frequency band. The default is \code{max(2, round(n_min^(1/3))) / n_min}, where \code{n_min} is the smaller sample size.}

  \item{spans1, spans2}{optional overrides of \code{bandwidth} for series 1 and 2, specified as in \code{\link{mvspec}}: a vector of odd integers with \eqn{m =} \code{spans \%/\% 2}. A vector of length greater than one gives a convolved kernel (for example \code{c(5, 5)}), which is possible for the Daniell-type and Bartlett kernels only.}

  \item{B}{number of bootstrap replicates.}

  \item{n_grid}{number of points in the common frequency grid on \eqn{(0, 0.5)}. The default is \code{min(floor(n_min/2), 500)}.}

  \item{divergence}{the statistic: \code{"is"} is the symmetrized Itakura-Saito divergence, \eqn{\int (f_1/f_2 + f_2/f_1 - 2)\,d\omega}{integral of (f1/f2 + f2/f1 - 2)}; \code{"log"} is the integrated squared log ratio, \eqn{\int (\log f_1 - \log f_2)^2\,d\omega}{integral of (log f1 - log f2)^2}, which is less sensitive to frequencies where a spectrum is very small.}

  \item{normalize}{if \code{TRUE}, each spectrum is divided by its average over the frequency grid, so that the test compares shapes rather than levels (variances).}

  \item{taper}{proportion of data to taper (split cosine bell) for the observed estimates. The default is \code{0} (no taper). The bootstrap simulates untapered periodograms, so it is exact for \code{taper = 0} and only approximate otherwise; in simulations, tapering inflated the rejection rate of the test under the null hypothesis. Consider a taper only if the spectra have a large dynamic range and leakage is a concern.}

  \item{seed}{if not \code{NULL}, \code{set.seed(seed)} is called before the bootstrap.}

  \item{dependent}{if \code{TRUE}, the two series may be dependent, with unspecified cross-dependence. This requires series of equal length observed at the same time points. See \sQuote{Details}. The default \code{FALSE} assumes independent series.}

  \item{max_coh}{used only if \code{dependent = TRUE}. An upper bound in \eqn{[0, 1)} for the estimated coherency at each frequency, which keeps the joint bootstrap distribution non-degenerate.}

  \item{coh_correct}{used only if \code{dependent = TRUE}. If \code{TRUE} (the default), the upward bias of the smoothed squared coherency estimate is reduced before it is used in the bootstrap. See \sQuote{Details}.}
}
\details{
The spectral densities are estimated with \code{\link{mvspec}} (no padding, linear detrending) and interpolated onto a common grid of frequencies in \eqn{(0, 0.5)}. Under the null hypothesis the common spectrum is estimated by the sample-size-weighted average of the two estimates.

The bootstrap reproduces the estimation pipeline. For each series, periodogram ordinates \eqn{I(\omega_j) = f_0(\omega_j) E_j} are drawn at the Fourier frequencies of that series, with \eqn{E_j} standard exponential (chi-squared with one degree of freedom at the Nyquist frequency). The full symmetric periodogram is formed, the zero frequency is handled as in \code{spec.pgram}, and the result is smoothed circularly with the same kernel and interpolated onto the common grid. The p-value is \eqn{(1 + \#\{T^* \ge T\})/(B + 1)}.

Because unequal smoothing bandwidths induce different biases in the two estimators when the spectra are not flat, the default smoothing uses the same bandwidth, in cycles per observation, for both series. A warning is given if the bandwidths of the two kernels differ by more than 25\%.

\emph{Dependent series.} If the series are correlated, the periodograms of the two series are correlated as well, and a bootstrap that draws them independently has the wrong null distribution; the test is then typically far too conservative. With \code{dependent = TRUE} the two periodograms are drawn jointly. At each Fourier frequency the pair of Fourier coefficients is generated as \eqn{Z_1 = \sqrt{f_0}\,e_1}{Z1 = sqrt(f0) e1} and \eqn{Z_2 = \sqrt{f_0}\,(\rho e_1 + \sqrt{1 - \rho^2}\,e_2)}{Z2 = sqrt(f0) (rho e1 + sqrt(1 - rho^2) e2)}, with \eqn{e_1, e_2} independent standard complex normal variables, so that the marginal distributions are the same as in the independent case and the periodograms have correlation \eqn{\rho^2}. Here \eqn{\rho(\omega)} is the magnitude of the coherency between the series, estimated from the smoothed cross-spectrum with \code{spec.pgram} and the kernel of \code{x1}, and capped at \code{max_coh}. Only the magnitude of the coherency matters, because the statistic depends on the two auto-spectra only. No parametric model for the dependence is needed.

The smoothed squared coherency is biased upward, by roughly \eqn{1/L}, where \eqn{L} is the effective number of averaged periodogram ordinates. Overstating the dependence makes the bootstrap distribution too narrow and the test too liberal. With \code{coh_correct = TRUE} the squared coherency is replaced by \eqn{(L \hat\gamma^2 - 1)/(L - 1)}{(L g2 - 1)/(L - 1)}, truncated at zero. In simulations with \eqn{n = 500}, this brought the rejection rate under the null hypothesis from about 0.075 to about 0.05. The estimated coherency is treated as known, so some size distortion may remain when the smoothing averages few ordinates.
}
\value{
An object of class \code{"htest"} with the usual components \code{statistic}, \code{p.value}, \code{alternative}, \code{method} and \code{data.name}, and the additional components

  \item{boot_dist}{the \code{B} bootstrap values of the statistic.}
  \item{freq_grid}{the common frequency grid.}
  \item{f1_hat, f2_hat}{the estimated spectra of the two series on the grid.}
  \item{f0_hat}{the pooled spectrum used in the bootstrap.}
  \item{coherency}{the estimated coherency magnitude on the grid, after any correction and capping, used in the bootstrap; \code{NULL} unless \code{dependent = TRUE}.}
  \item{dependent}{the value of the argument \code{dependent}.}
  \item{n1, n2}{the sample sizes.}
  \item{m1, m2}{the total kernel half-widths, in Fourier frequencies.}
  \item{bandwidth}{the kernel bandwidths of the two estimators, in cycles per observation.}
  \item{kernel}{the kernel name.}
}
\seealso{\code{\link{mvspec}}, \code{\link{bart}}, \code{\link[stats]{kernel}}, \code{\link[stats]{spec.pgram}}}
\examples{
set.seed(90210)
x1 <- sarima.sim(ar = 0.7, n = 400)
x2 <- sarima.sim(ar = 0.7, n = 250)   # same spectrum, different n
x3 <- sarima.sim(ar = -0.5, n = 250)  # different spectrum

test2spec(x1, x2)
test2spec(x1, x3)

# other smoothing choices
test2spec(x1, x3, kernel = "bartlett", B = 500, seed = 1)
test2spec(x1, x3, spans1 = c(7, 7), spans2 = c(5, 5), B = 500, seed = 1)

# dependent series: a shared component induces cross-dependence
n <- 500
z  <- sarima.sim(ar = 0.7, n = n)
y1 <- z + rnorm(n)
y2 <- z + rnorm(n)                    # same spectrum as y1, but dependent
y3 <- z + rnorm(n, sd = 1.5)          # different spectrum, dependent

test2spec(y1, y2, dependent = TRUE, B = 500, seed = 1)
test2spec(y1, y3, dependent = TRUE, B = 500, seed = 1)
}
\keyword{ts}
\keyword{htest}
