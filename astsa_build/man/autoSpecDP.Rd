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
      \item{\code{fast}}{if \code{TRUE} (default), use the cached segment cost, which gives the same results more quickly.}
    }}
}
\details{
For a partition into \eqn{m} segments of a series of length \eqn{n}, the criterion is
\deqn{\log m + m \log n + \sum_{j=1}^{m} C_j,}
where each segment cost \eqn{C_j} contains the code length of the chosen kernel (\eqn{\log r} for a library of \eqn{r} kernels), the code length of the bandwidth, and the Whittle fit term, minimized over kernel and bandwidth. Because the criterion is additive over segments, dynamic programming finds the best partition among all those whose breakpoints lie on the candidate grid. A breakpoint between grid points cannot be found, which is why \code{grid.step} should be small relative to the shortest segment expected.

An exact search does not make the criterion more reliable. On narrowband series the criterion can favour spurious breakpoints, and a small \code{min.span} makes this worse. Set \code{min.span} conservatively, check each breakpoint separately (for example by comparing the MDL with and without it), and calibrate any large MDL gain by simulation from a no-change model.
}
\value{
A list with components
  \item{breakpoints}{segment start positions, with \eqn{n} appended.}
  \item{number_of_segments}{number of segments chosen.}
  \item{segment_kernel_orders_m}{bandwidth order chosen in each segment.}
  \item{segment_kernel_type}{kernel chosen in each segment; \code{"none"} when the order is 0 (no smoothing).}
  \item{mdl}{total MDL of the returned model.}
  \item{elapsed.sec}{run time of the search in seconds.}
}
\references{You can find demonstrations of  astsa capabilities at
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
}
}
\keyword{ts}
