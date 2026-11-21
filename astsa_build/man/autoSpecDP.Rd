\name{autoSpecDP}
\alias{autoSpecDP}
\title{Detection of Narrowband Frequency Changes by Dynamic Programming}
\description{
Finds the number and locations of breakpoints in a time series whose spectrum changes, using minimum description length (MDL) with the Whittle likelihood. Within each segment the spectrum is a kernel-smoothed periodogram, and MDL chooses the kernel and bandwidth as well as the segmentation. The search over breakpoints is done exactly, by dynamic programming, on a grid of candidate breakpoints, so repeated runs give identical results.
}
\usage{
autoSpecDP(xdata, ..., mode = c("offline", "stream", "window", "monitor"))
}
\arguments{
  \item{xdata}{univariate time series, length at least 100.}
  \item{mode}{\code{"offline"} (default) segments the whole series. \code{"stream"}, \code{"window"} and \code{"monitor"} process data as they arrive; they are for sequential monitoring and are not described here.}
  \item{...}{further arguments. For \code{mode = "offline"}:
    \describe{
      \item{\code{m0}}{maximum bandwidth order per segment; bandwidth is \eqn{2k+1} for order \eqn{k = 0, \dots, m0}. Default 10, maximum 20.}
      \item{\code{taper}}{proportion of each end of a segment tapered by a cosine bell; default 0.5 (full bell). MDL values from different tapers are not comparable.}
      \item{\code{min.freq, max.freq}}{restrict the likelihood to this band, in cycles per observation, within \eqn{[0, 0.5]}. Defaults 0 and 0.5. Choose the band before fitting, not by MDL; MDL values from different bands are not comparable.}
      \item{\code{kernels}}{kernel library MDL selects from: any of \code{"bartlett"}, \code{"daniell"}, \code{"modified.daniell"}, \code{"dirichlet"}, \code{"fejer"}. Default is the first four.}
      \item{\code{M}}{maximum number of segments. Default 10.}
      \item{\code{min.span}}{minimum segment length. Default \eqn{\max(20, 4(2m0+1))}.}
      \item{\code{grid.step}}{spacing of candidate breakpoints. Default about \eqn{n/400}, at most \code{min.span}. Use 1 to search every observation.}
      \item{\code{refine}}{if \code{TRUE} (default), polish each breakpoint at full resolution within \code{refine.window} (default \code{grid.step}) of its grid location.}
      \item{\code{expected.breaks}}{optional guess at the number of breakpoints; only adjusts the defaults for \code{M} and \code{grid.step}.}
      \item{\code{verbose}}{print progress messages; default \code{TRUE}.}
      \item{\code{n.cores}}{number of cores used to build the segment-cost table; default 1.}
      \item{\code{prune}}{strength of backward pruning, a number between 0 and 1; default 0 (no pruning); 1 removes every breakpoint. See \code{prune.method} and Details.}
      \item{\code{prune.method}}{\code{"spectral"} (default): each breakpoint is tested against its two neighboring segments, compared at a common frequency resolution, and \code{prune} is a confidence level (\code{prune = .95} keeps breakpoints with p-value at most .05). \code{"mdl"}: breakpoints are scored by the MDL increase from merging them away (in nats); the threshold is \code{prune} times the largest support on the pruning path, or, with \code{null.reps > 0}, its \code{prune} quantile over no-change surrogates.}
      \item{\code{null.reps}}{number of no-change surrogate series used to calibrate \code{prune}; default 0 (no simulation: nominal level for \code{"spectral"}, relative scale for \code{"mdl"}). Each surrogate costs a full serial fit, spread over \code{n.cores}; 40 to 100 is typical.}
      \item{\code{null.surrogate}}{\code{"phase"} (default), a phase-randomized copy of the series that keeps its average spectrum, or \code{"ar"}, an AR model chosen by AIC with Gaussian innovations.}
      \item{\code{null.W}}{null values returned by an earlier call (component \code{null.W}); lets you try other \code{prune} levels without re-simulating. Valid only for the same data and settings.}
      \item{\code{seed}}{random seed for the surrogates.}
      \item{\code{min.gain}}{minimum amount, in MDL units (nats; see Details), by which the final partition must beat no split; otherwise a single segment is returned. Default 0 (no rule). Applied after refinement and pruning.}
      \item{\code{fast}}{if \code{TRUE} (default), use the cached segment cost, which gives the same results more quickly.}
    }}
}
\details{
For a partition into \eqn{m} segments of a series of length \eqn{n}, the criterion is
\deqn{\log m + m \log n + \sum_{j=1}^{m} C_j,}
where each segment cost \eqn{C_j} contains the code length of the chosen kernel (\eqn{\log r} for a library of \eqn{r} kernels), the code length of the bandwidth, and the Whittle fit term, minimized over kernel and bandwidth. Because the criterion is additive over segments, dynamic programming finds the best partition among all those whose breakpoints lie on the candidate grid. A breakpoint between grid points cannot be found, which is why \code{grid.step} should be small relative to the shortest segment expected.

The criterion uses natural logarithms, so MDL values, and differences between them, are measured in units called nats. A difference of \eqn{d} nats corresponds to a likelihood ratio of about \eqn{e^d}: 1 nat is a factor of about 2.7, 6 nats about 400, and 10 nats about 22,000. Values from different tapers, bands or kernel libraries are not comparable.

An exact search does not make the criterion more reliable. On narrowband series the criterion can favor spurious breakpoints, and a small \code{min.span} makes this worse. Set \code{min.span} conservatively, check each breakpoint separately (for example by comparing the MDL with and without it), and calibrate any large MDL gain by simulation from a no-change model.

\code{prune} automates that check. With \code{prune.method = "spectral"}, each interior breakpoint is compared with its two neighboring segments. The neighbors are cut into blocks of a common length (a fraction of the shorter segment), the block periodograms are averaged on the same Fourier frequencies, and their ratio is compared with an F distribution at each frequency in the band; p-values are corrected for the number of frequencies and the three block lengths used. Because both sides are seen at the same resolution, a short segment of the same spectrum is not taken for a different one, which the per-segment kernel and order costs cannot guarantee. The breakpoint with the largest p-value is removed while that p-value exceeds \code{1 - prune}, and the rest are re-tested. In one simulated line-spectrum scenario, with the break location given, the false-alarm rate was 1 to 3 percent at a 5 percent level and the power for a clear change was near 99 percent; with the location found by the search and the level calibrated by \code{null.reps}, 24 of 30 changes were detected and none of 50 no-change series raised an alarm. The weaker the change, the lower the power, and these figures come from a single scenario. This p-value is for a break at a location chosen in advance. The DP picks the location from the data, which favors rejection, so for a firm statement of the level use \code{null.reps > 0}: the whole procedure is run on no-change surrogates, and the \code{prune} level is applied to the null distribution of the best bottleneck along the pruning path (the smallest, over pruning steps, of the largest breakpoint p-value), which accounts for the search and matches the pruning decision. \code{prune.p} then reports the null p-value of the observed bottleneck. The \code{"phase"} surrogate keeps the average spectrum of the whole series, so the null is a stationary series with that spectrum.

\code{prune.method = "mdl"} uses the support of a partition, the smaller of the weakest breakpoint's worth (MDL increase in nats when it is merged away, penalty included) and the gain over no split. On line spectra the per-segment kernel and order costs make this statistic erratic, and null values of 10 to 20 nats were seen, so it is kept mainly for comparison. Neither method moves the breakpoints that remain. \code{min.gain} adds little once \code{prune} is used.
}
\value{
A list with components
  \item{breakpoints}{segment start positions, with \eqn{n} appended.}
  \item{number_of_segments}{number of segments chosen.}
  \item{segment_kernel_orders_m}{bandwidth order chosen in each segment.}
  \item{segment_kernel_type}{kernel chosen in each segment; \code{"none"} when the order is 0 (no smoothing).}
  \item{mdl}{total MDL of the returned model.}
  \item{gain}{MDL of no split minus \code{mdl}, in nats (see Details); 0 for a single segment. Positive values favor the returned segmentation.}
  \item{prune.method}{\code{"spectral"} or \code{"mdl"}.}
  \item{prune.alpha}{spectral pruning: the p-value level the breakpoints had to meet; \code{NA} otherwise.}
  \item{break.p}{spectral pruning: p-values of the breakpoints that remain; \code{NULL} otherwise.}
  \item{prune.nats}{"mdl" pruning: the threshold, in nats, that \code{prune} implied; 0 otherwise.}
  \item{prune.p}{calibrated mode only: null p-value of the observed bottleneck (of the largest support for \code{"mdl"}); \code{NA} otherwise.}
  \item{null.W}{calibrated mode only: the null statistics (best bottleneck p-value, or largest support), reusable through the \code{null.W} argument with the same \code{prune.method}.}
  \item{elapsed.sec}{run time of the search in seconds.}
}
\references{Cover, T. M. and Thomas, J. A. (2006). \emph{Elements of Information Theory}, 2nd ed. Wiley-Interscience, Hoboken, NJ. (Chapter 2 defines the nat, the unit used for MDL values here.)

You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{D.S. Stoffer}
\seealso{\code{\link{autoSpec}}, \code{\link{mvspec}}}
\examples{
\dontrun{
set.seed(3)
t = 1:500
x = c(2*cos(2*pi*t/25)*cos(2*pi*t/150) + rnorm(500),   # twin peaks
      cos(2*pi*t/25) + rnorm(500))                     # single peak
tsplot(x, col=4)
par(mfrow=2:1)
mvspec(x[1:500]); mvspec(x[501:1000])
fit = autoSpecDP(x, max.freq = .1, kernels = "bartlett",
                 grid.step = 5, min.span = 100)
fit

# prune on a 0-1 scale: keep only breakpoints significant at the 5% level
# (add null.reps = 100 to calibrate that level on no-change surrogates)
fitp = autoSpecDP(x, max.freq = .1, kernels = "bartlett",
                  grid.step = 5, min.span = 100, prune = 0.95)
fitp$breakpoints
fitp$break.p
}
}
\keyword{ts}
