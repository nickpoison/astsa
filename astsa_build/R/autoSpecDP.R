#########################################################################################
##-- autoSpecDP
##
## Detection of narrowband frequency changes in a time series by minimum description
## length (MDL) with the Whittle likelihood, optimized EXACTLY over a grid of candidate
## breakpoints by dynamic programming (DP). Within each segment the spectrum is estimated
## nonparametrically; MDL chooses the number of segments, the breakpoints, and, in each
## segment, the smoothing kernel and bandwidth.
##
## Requires astsa (mvspec, bart); stats::kernel() supplies the other kernel shapes.
## Contents: Section 1 offline DP (the main function); Section 2 growing-stream DP
## (.dp.stream.*); Section 3 sliding-window DP (.dp.wstream.*); Section 4 targeted monitor
## (.tg.*, tg_*). The simulation harnesses and regression tests used for the write-up are in
## autoSpecDP_research.R, not needed for ordinary use.
##
## ---------------------------------------------------------------------------------------
## Criterion.  For m segments with breakpoints xi_0 = 0 < xi_1 < ... < xi_m = n,
##   MDL = log(m) + m*log(n) + sum_j C(xi_{j-1}, xi_j),
## where the segment cost C is minimized over kernel type K in the library (r kernels) and
## bandwidth order k:
##   C = log(r) + .5*log(n_j*Bw^2) + num*log(2*pi) + sum_w [log f_hat(w) + I(w)/f_hat(w)],
## Bw = 2k+1, I the raw periodogram of the segment (target), f_hat the tapered periodogram
## smoothed with kernel K at order k, and the sum over the Fourier ordinates in the band
## (num of them). Because C depends only on the data between its two endpoints, the
## criterion is additive over segments, and optimal-partitioning DP finds the best
## partition among candidates exactly. Tractability: (i) candidate breakpoints lie on a
## coarse grid, (ii) the selected breakpoints are then refined at full resolution.
##
## ---------------------------------------------------------------------------------------
## Arguments
##   xdata       : univariate time series (length >= 100)
##   m0          : maximum kernel order per segment; bandwidth Bw = 2*order+1,
##                 order = 0, ..., min(m0, floor(segment length/2)). Capped at 20.
##   taper       : proportion of each end of a segment tapered by a cosine bell (.5 = full
##                 bell). Applied to the smoothed candidate spectrum only; the Whittle target
##                 I(w) is always the raw (untapered) periodogram, because tapering both
##                 makes "no smoothing" a degenerate minimum of the fit term. MDL values are
##                 therefore NOT comparable across taper settings: fix the taper before
##                 comparing models.
##   min.freq,
##   max.freq    : restrict the Whittle likelihood to frequencies in (min.freq, max.freq), in
##                 cycles per OBSERVATION, within [0, .5] (2 cycles per year with 12
##                 observations per year is max.freq = 2/12). Choose the band from the
##                 physics or a periodogram of the whole series before fitting, never by
##                 MDL; MDL values are not comparable across bands. Band indices are computed
##                 from the segment length but the spectrum lies on the zero-padded grid
##                 j/nextn(n.seg), so band edges are approximate.
##   kernels     : kernel library MDL selects from, in addition to bandwidth: any of
##                 "bartlett" (astsa::bart), "daniell", "modified.daniell", "dirichlet",
##                 "fejer" (base R stats::kernel).
##   M           : maximum number of segments. Default 10, or max(10, expected.breaks + 6).
##   min.span    : minimum segment length. Default max(20, 4*(2*m0+1)). Too small allows
##                 short noisy segments that fit well by chance; too large hides short
##                 regimes. Raise it along with m0.
##   grid.step   : spacing of candidate breakpoints. Default about n/400, capped at min.span.
##                 No two breakpoints can be closer than grid.step, and refinement cannot
##                 recover a break the grid skipped. Set to 1 to search at full resolution.
##   refine      : if TRUE (default), each interior breakpoint is polished at full
##                 resolution within +/- refine.window of its grid location, never leaving
##                 either neighbouring segment shorter than min.span.
##   refine.window: half-width of the refinement window; default grid.step.
##   expected.breaks: optional guess at the number of interior breakpoints; used only to set
##                 defaults for M and grid.step and to warn if it conflicts with min.span.
##   verbose     : print progress and summary messages.
##   n.cores     : cores for building the segment-cost table (parallel::mclapply on
##                 Unix-like systems, a PSOCK cluster on Windows). Default 1.
##   prune       : strength of backward pruning, a number in [0, 1]; 0 (default) = no pruning, 1 =
##                 merge every interior break (single segment).  What it measures depends on
##                 prune.method.
##   prune.method: "spectral" (default) or "mdl".
##                 "spectral": each interior break is tested against its two neighbours with the
##                   segments compared at a COMMON frequency resolution (block periodograms of the
##                   same length from both sides, F ratios, see .dp.breakP), so a short segment of
##                   the same spectrum is not mistaken for a different one.  prune is a confidence
##                   level: every surviving break must have p <= 1 - prune (prune = .95: p <= .05).
##                   Breaks with the largest p are removed first and the rest re-tested.  With
##                   null.reps > 0 the level is instead the (1 - prune) quantile, over no-change surrogates,
##                   of the best bottleneck T along the pruning path (T = min over steps of the
##                   largest break p-value), which corrects for the search over break locations
##                   and matches the pruning decision exactly.
##                 "mdl": the earlier rule.  The SUPPORT of a partition is min(weakest drop-one
##                   MDL worth, gain over no split), in nats, penalty included; W is the largest
##                   support along the pruning path.  Relative scale (null.reps = 0): survivors
##                   need support >= prune * W.  Calibrated (null.reps > 0): the threshold is the
##                   prune quantile of W over surrogates.
##   null.reps   : number of null surrogates for calibration (default 0 = none). Each replicate is
##                 a full fit, so cost is null.reps x one serial fit, spread over n.cores. Use 40
##                 to 100; the resolution of the quantile is 1/null.reps.
##   null.surrogate: "phase" (default; phase-randomised copy of the series, keeps its average
##                 spectrum) or "ar" (AR fitted by AIC, Gaussian innovations).
##   null.W      : null values from an earlier call (returned as `null.W`); reuse them to try
##                 other prune levels without re-simulating. Same data and settings only.
##   seed        : random seed for the surrogates.
##   min.gain    : minimum number of nats by which the final partition must beat NO SPLIT (same
##                 penalty convention); otherwise a single segment is returned. Default 0 = no
##                 rule. Applied last, after refinement and pruning. Not calibrated: choose it by
##                 simulation (the write-up's Section 14 found it adds little once pruning is
##                 used). The gain of the returned fit is reported as `gain`.
##   fast        : if TRUE (default), use the cached segment cost, which gives the same
##                 costs, kernels and orders as the reference path (fast = FALSE) to
##                 floating-point precision at 3-7 times lower cost.
##
## Returns a list:
##   breakpoints            : segment start positions, with n appended
##   number_of_segments     : m*
##   segment_kernel_orders_m: chosen bandwidth order per segment
##   segment_kernel_type    : chosen kernel per segment; "none" if the order is 0 (no
##                            smoothing, so all kernels coincide)
##   mdl                    : total MDL of the returned model
##   gain                   : MDL of NO SPLIT minus mdl, in nats (0 for a single segment); how far
##                            the fit beats not splitting, under the same penalty convention
##   prune.method           : "spectral" or "mdl"
##   prune.alpha            : spectral pruning: the p-value level the breaks had to meet (NA if unused)
##   break.p                : spectral pruning: p-values of the breaks that remain (NULL if unused)
##   prune.nats             : "mdl" pruning: the nats threshold that `prune` implied (0 if unused)
##   prune.p                : calibrated mode only: share of null surrogates at least as extreme as the
##                            observed fit (smaller p, or larger W for "mdl"; +1 correction); NA otherwise
##   null.W                 : calibrated mode only: the null values of W (reusable via null.W =)
##   elapsed.sec            : wall-clock time of the search
#########################################################################################

## ---------------------------------------------------------------------------------------
## ENTRY POINT.  autoSpecDP(x, ..., mode = ) dispatches to the parts of this file.  `mode` must be
## given BY NAME and every other argument is passed on, so autoSpecDP(x, m0 = 10, max.freq = .1)
## runs the offline DP.
##   mode = "offline" (default)  exact DP segmentation of the whole series (.dp.offline, below)
##   mode = "stream"   growing stream (Section 2).  First call:
##                       o <- autoSpecDP(x1, mode = "stream", max.n = 1000, grid.step = 10,
##                                       min.span = 100, max.freq = .1, kernels = "bartlett")
##                     (settings: m0, taper, min.freq, max.freq, kernels, M, min.span, grid.step);
##                     later calls:  o <- autoSpecDP(newx, mode = "stream", state = o$state).
##                     Returns list(state, fit); fit$breakpoints is the provisional segmentation.
##                     refine = FALSE, refine.window = NULL as in .dp.stream.update().
##   mode = "window"   sliding window (Section 3): same pattern, first call with window = 600.
##   mode = "monitor"  targeted monitor (Section 4): autoSpecDP(x, mode = "monitor", Bcal = 300,
##                     alpha = .05, ...) calibrates on x[1:Wref] (arguments of tg_calibrate) and
##                     monitors x; pass cal = r$cal to reuse a calibration.  Returns list(cal, monitor).
## ---------------------------------------------------------------------------------------
autoSpecDP <- function(xdata, ..., mode = c("offline", "stream", "window", "monitor")){
  mode <- match.arg(mode)
  switch(mode,
         offline = .dp.offline(xdata, ...),
         stream  = .dp.entry.stream(xdata, ...),
         window  = .dp.entry.window(xdata, ...),
         monitor = .dp.entry.monitor(xdata, ...))
}

.dp.entry.stream <- function(xdata, state = NULL, max.n = NULL, refine = FALSE, refine.window = NULL, ...){
  if (is.null(state)){
    if (is.null(max.n)) stop("starting a stream needs max.n, the largest stream length you will feed")
    state <- .dp.stream.init(max.n = max.n, ...)
  } else if (length(list(...)))
    warning("arguments ", paste(names(list(...)), collapse = ", "),
            " are ignored: the settings are stored in `state`", call. = FALSE)
  .dp.stream.update(state, c(xdata), refine = refine, refine.window = refine.window)
}

.dp.entry.window <- function(xdata, state = NULL, window = NULL, refine = FALSE, refine.window = NULL, ...){
  if (is.null(state)){
    if (is.null(window)) stop("starting a sliding-window stream needs window, the number of recent observations analysed")
    state <- .dp.wstream.init(window = window, ...)
  } else if (length(list(...)))
    warning("arguments ", paste(names(list(...)), collapse = ", "),
            " are ignored: the settings are stored in `state`", call. = FALSE)
  .dp.wstream.update(state, c(xdata), refine = refine, refine.window = refine.window)
}

.dp.entry.monitor <- function(xdata, cal = NULL, ...){
  x <- c(xdata)
  if (is.null(cal)) cal <- tg_calibrate(x, ...)
  else if (length(list(...)))
    warning("arguments ", paste(names(list(...)), collapse = ", "),
            " are ignored: the calibration `cal` was supplied", call. = FALSE)
  list(cal = cal, monitor = tg_monitor(x, cal))
}

## The offline DP.
.dp.offline <-
function(xdata, m0 = 10, taper = .5, min.freq = 0, max.freq = .5,
         kernels = c("bartlett", "daniell", "modified.daniell", "dirichlet"),
         M = NULL, min.span = NULL, grid.step = NULL, refine = TRUE,
         refine.window = NULL, expected.breaks = NULL, verbose = TRUE, n.cores = 1, fast = TRUE,
         prune = 0, min.gain = 0,
         null.reps = 0, null.surrogate = c("phase", "ar"), null.W = NULL, seed = NULL,
         prune.method = c("spectral", "mdl"), .W.only = FALSE){

  null.surrogate = match.arg(null.surrogate)
  prune.method   = match.arg(prune.method)
  if (NCOL(xdata) > 1) stop("univariate time series only")
  xdata = c(xdata)                       # remove ts attributes if there
  n     = length(xdata)
  if (n < 100) stop('sample size should be at least 100')
  .dp.check.band(min.freq, max.freq)
  if (m0 > 20) {m0 = 20; cat("m0 has been reset to 20 \n")}

  if (!is.null(expected.breaks)){
    if (expected.breaks < 0) stop("expected.breaks must be >= 0")
    expected.segments = expected.breaks + 1
    avg.span          = n / expected.segments
    if (verbose) cat("expected.breaks = ", expected.breaks, " -> targeting ",
                      expected.segments, " segment(s), average length ~",
                      round(avg.span), " points\n", sep = "")
  }

  # min.span matters a lot: a segment needs several multiples of its own
  # bandwidth (Bw = 2*m0+1) worth of data for the smoothed periodogram to be
  # remotely stable. Too small and the DP is free to carve out short, noisy
  # segments that look good under the fit term even though they're overfit;
  # too large and real short-lived regime changes become undetectable. As a
  # default (only used if the user doesn't supply one), require at least
  # ~4x the widest bandwidth m0 allows, floored at 20 so small-m0 fits don't
  # get an unreasonably short minimum. If you raise m0 well above its
  # default, raise min.span to match -- don't leave it at 20.
  #
  # NOTE: this default is NOT auto-shrunk to fit expected.breaks, even though
  # expected.breaks does drive M and grid.step below. min.span's floor exists
  # for estimation quality, not search convenience -- silently relaxing it
  # just to make a guessed break count reachable would trade away estimate
  # quality without you ever deciding to. Instead, if the two are in
  # tension, you get a warning telling you what to change.
  if (is.null(min.span)) min.span = max(20, 4*(2*m0 + 1))

  if (!is.null(expected.breaks) && avg.span < 2*min.span)
    warning("expected.breaks = ", expected.breaks, " implies an average segment ",
            "length of ", round(avg.span), " points, which is less than twice ",
            "min.span (", min.span, "). The search is unlikely to find that many ",
            "segments. Consider a smaller m0 (lowers the stability floor on ",
            "min.span), a smaller expected.breaks, or an explicit, smaller ",
            "min.span if you're prepared to accept noisier per-segment spectral ",
            "estimates.", call. = FALSE)

  # grid.step is resolved AFTER min.span for a reason: no two breakpoints can
  # ever be closer together than grid.step (every candidate cut is a
  # multiple of it), so grid.step silently imposes its OWN floor on segment
  # length -- on top of min.span, and refine() cannot fix this after the
  # fact, since it only nudges a breakpoint the coarse DP already chose; it
  # never introduces one the coarse grid skipped past. The default below is
  # bounded by min.span so a long series doesn't silently end up with a
  # coarse grid step above min.span, which would defeat the point of
  # min.span, and -- if expected.breaks was supplied -- additionally bounded
  # so there are at least ~4 grid cells per expected average segment, giving
  # the coarse search a decent shot at landing near each expected boundary.
  # If you pass grid.step explicitly larger than min.span, you'll get a
  # warning, since segments shorter than grid.step but still allowed by
  # min.span become undiscoverable regardless of refine.
  user.grid.step = !is.null(grid.step)
  if (is.null(grid.step)){
    # cap at min.span (not min.span/2): grid.step <= min.span is all that's
    # actually required to avoid the undiscoverable-segment problem above --
    # an extra safety margin here directly roughly quadruples runtime for
    # long series (K ~ n/grid.step, cost ~ O(K^2)), right in the regime
    # where this cap is the binding constraint, so it isn't worth it as a
    # blind default. If you want finer resolution than this, set grid.step
    # explicitly.
    grid.step = max(1, min(round(n/400), min.span))
    if (!is.null(expected.breaks))
      grid.step = max(1, min(grid.step, floor(avg.span/4)))
  }
  if (user.grid.step && grid.step > min.span)
    warning("grid.step (", grid.step, ") is larger than min.span (", min.span,
            ") -- segments shorter than grid.step but allowed by min.span will ",
            "not be discoverable by the coarse search, and refine() cannot ",
            "recover them. Consider grid.step <= min.span (ideally a fraction ",
            "of it, e.g. min.span/2 or smaller).", call. = FALSE)
  if (is.null(refine.window)) refine.window = grid.step

  # M (the max number of segments the search considers) defaults to a flat
  # 10 when no expectation is given, as before. If expected.breaks IS given,
  # a flat 10 could silently cap the search below your own stated
  # expectation (e.g. expected.breaks = 30), so default M to comfortably
  # above expected.segments instead -- enough headroom (+5 segments) for the
  # MDL criterion to still choose more or fewer than you guessed, without
  # being capped at exactly your guess.
  if (is.null(M))
    M = if (!is.null(expected.breaks)) max(10, expected.segments + 5) else 10
  if (!is.null(expected.breaks) && M < expected.segments)
    warning("M (", M, ") is smaller than expected.breaks + 1 (", expected.segments,
            ") -- the search can never return more segments than M, so it can ",
            "never reach your expected count. Raise M.", call. = FALSE)

  # coarse cut points c_0 = 0 < c_1 < ... < c_K = n
  cuts = sort(unique(c(seq(0, n, by = grid.step), n)))
  K    = length(cuts) - 1

  if (verbose) cat("DP grid: ", K, " coarse cut points (step = ", grid.step,
                    "); building segment-cost table...\n", sep = "")
  if (verbose && (min.freq > 0 || max.freq < .5)){
    NewN = nextn(n); mf.n = min(max.freq, .5); nf.n = max(min.freq, 0)
    hi.f = floor(n*mf.n)/NewN
    lo.f = if (nf.n > 0) max(1, ceiling(n*nf.n))/NewN else 0
    if (abs(hi.f - mf.n) > .002 || (nf.n > 0 && abs(lo.f - nf.n) > .002))
      cat("band: requested ", nf.n, " to ", mf.n, " cycles/obs; on the padded grid of the full series (n = ",
          n, " padded to ", NewN, ") it covers about ", round(lo.f, 4), " to ", round(hi.f, 4),
          "; other segment lengths differ slightly\n", sep = "")
  }

  t0     = Sys.time()
  tables = .dp.buildTables(xdata, n, cuts, m0, taper, min.freq, max.freq,
                            kernels, min.span, verbose, n.cores, fast)
  dp     = .dp.optimalPartition(tables, n, M)
  chosen = .dp.chooseM(dp, n, M, length(kernels))

  if (!is.finite(chosen$mdl))
    stop("no feasible partition found -- try a smaller grid.step or min.span")

  cutpath = .dp.backtrack(dp, chosen$m)
  starts  = cutpath[1:chosen$m] + 1     # segment start positions (coarse)

  if (refine && chosen$m > 1){
    if (verbose) cat("refining", chosen$m - 1, "interior breakpoint(s) at full resolution...\n")
    starts = .dp.refine(xdata, n, starts, m0, taper, min.freq, max.freq,
                         kernels, refine.window,
                         cache = if (fast) .dp.newCache() else NULL, min.span = min.span)
  }

  # backward pruning, strength `prune` in [0, 1]
  if (!is.numeric(prune) || length(prune) != 1 || is.na(prune) || prune < 0 || prune > 1)
    stop("prune must be a single number in [0, 1]")
  prune.nats = 0; prune.alpha = NA_real_; prune.p = NA_real_; break.p = NULL
  if (prune > 0 && length(starts) > 1){
    spectral   = prune.method == "spectral"
    calibrated = null.reps > 0 || !is.null(null.W)
    if (calibrated && !is.null(null.W)){
      nm = attr(null.W, "method"); if (is.null(nm)) nm = "mdl"    # older null.W had no label
      if (nm != prune.method)
        stop("null.W was built with prune.method = \"", nm, "\"; use prune.method = \"", nm, "\" or recompute it")
      if (prune.method == "spectral" && is.null(attr(null.W, "stat")))
        stop("this null.W used an earlier, inconsistent statistic; recompute it with null.reps")
    }
    if (calibrated && is.null(null.W)){
      settings = list(m0 = m0, taper = taper, min.freq = min.freq, max.freq = max.freq,
                      kernels = kernels, M = M, min.span = min.span, grid.step = grid.step,
                      refine = refine, refine.window = refine.window, fast = fast)
      null.W = .dp.nullW(xdata, null.reps, null.surrogate, seed, settings, n.cores, verbose,
                         prune.method)
    }
    if (spectral){
      # level every break must meet: 1 - prune, or the (1 - prune) quantile of the null
      # distribution of the smallest break p-value when calibrated (corrects for the search)
      alpha = if (prune >= 1) -1
              else if (calibrated) as.numeric(quantile(null.W, 1 - prune, type = 1, names = FALSE))
              else 1 - prune
      pr = .dp.pruneSpectral(xdata, n, starts, min.freq, max.freq, alpha)
      prune.alpha = alpha; break.p = pr$p
      if (calibrated) prune.p = (1 + sum(null.W <= pr$T)) / (length(null.W) + 1)
      if (verbose){
        cat("break p-values before pruning (neighbours compared at common resolution): ",
            paste(starts[-1], " p=", signif(pr$p0, 3), collapse = "; "), "\n", sep = "")
        if (calibrated)
          cat("prune = ", prune, " (calibrated on ", length(null.W), " surrogates): each break must have p <= ",
              signif(alpha, 3), "; bottleneck statistic ", signif(pr$T, 3), ", null p-value ", round(prune.p, 3), "\n", sep = "")
        else
          cat("prune = ", prune, ": each break must have p <= ", signif(alpha, 3), "\n", sep = "")
        if (length(pr$dropped)) cat("pruned break(s) at ", paste(pr$dropped, collapse = ", "), "\n", sep = "")
      }
      starts = pr$starts
    } else {
      pr = .dp.prune(xdata, n, starts, m0, taper, min.freq, max.freq, kernels, prune,
                     null.W = if (calibrated) null.W else NULL,
                     cache = if (fast) .dp.newCache() else NULL)
      prune.nats = pr$tol
      if (calibrated) prune.p = (1 + sum(null.W >= pr$W)) / (length(null.W) + 1)
      if (verbose){
        if (calibrated)
          cat("prune = ", prune, " (null quantile of ", length(null.W), " surrogates): threshold ",
              round(pr$tol, 2), " nats; observed support ", round(pr$W, 2),
              " nats; null p-value ", round(prune.p, 3), "\n", sep = "")
        else
          cat("prune = ", prune, ": threshold ", round(pr$tol, 2), " nats (", round(prune, 2), " x ",
              round(pr$W, 2), ", the largest support on the pruning path)\n", sep = "")
        if (length(pr$dropped)) cat("pruned break(s) at ", paste(pr$dropped, collapse = ", "), "\n", sep = "")
      }
      starts = pr$starts
    }
  }

  # recompute the final per-segment kernel/order/MDL on the (possibly refined) partition
  u    = c(starts, n)
  npts = length(starts)
  fcache = if (fast) .dp.newCache() else NULL
  kord = integer(npts); ktype = character(npts); kmdl = numeric(npts)
  for (i in 1:npts){
    strt = u[i]
    endd = if (i < npts) u[i+1] - 1 else n
    res  = .dp.segCostAny(xdata[strt:endd], m0, taper, min.freq, max.freq, kernels, fcache)
    kmdl[i]  = res$mdl
    ktype[i] = res$kernel
    kord[i]  = res$order
  }
  pen       = .dp.pen(npts, n, length(kernels))
  total.mdl = sum(kmdl) + pen
  # gain over NO SPLIT, and the optional minimum-gain rule
  ns       = .dp.segCostAny(xdata, m0, taper, min.freq, max.freq, kernels, fcache)
  ns.mdl   = ns$mdl + .dp.pen(1, n, length(kernels))
  gain     = ns.mdl - total.mdl
  if (min.gain > 0 && npts > 1 && gain < min.gain){
    if (verbose) cat("best partition beats no split by ", round(gain, 2), " nats (< min.gain = ",
                     min.gain, "); returning a single segment\n", sep = "")
    u = c(1, n); npts = 1; kord = ns$order; ktype = ns$kernel
    total.mdl = ns.mdl; gain = 0
  }
  elapsed   = as.numeric(difftime(Sys.time(), t0, units = "secs"))

  if (verbose) cat("returned breakpoints include the endpoints", "\n")

  return(list(breakpoints = u, number_of_segments = npts,
              segment_kernel_orders_m = kord, segment_kernel_type = ktype,
              mdl = total.mdl, gain = gain, prune.method = prune.method, prune.alpha = prune.alpha,
              break.p = break.p, prune.nats = prune.nats, prune.p = prune.p,
              null.W = null.W, elapsed.sec = elapsed))
}


#########################################################################################
##-- internal helpers (prefixed .dp.)
#########################################################################################

## Shared check of the frequency band (min.freq, max.freq), in cycles per OBSERVATION.
## Used by autoSpecDP() and by the stream/window initialisers; warnings are immediate.
.dp.check.band = function(min.freq, max.freq){
  if (max.freq > .5)
    warning("max.freq (", max.freq, ") is above .5 and is treated as .5, i.e. the FULL band. ",
            "max.freq is in cycles per OBSERVATION (time-series attributes are removed), ",
            "not cycles per year or per second: with 12 observations per year, 2 cycles ",
            "per year is max.freq = 2/12.", call. = FALSE, immediate. = TRUE)
  if (min.freq < 0)
    warning("min.freq (", min.freq, ") is below 0 and is treated as 0.", call. = FALSE, immediate. = TRUE)
  if (max(min.freq, 0) >= min(max.freq, .5))
    stop("min.freq (", min.freq, ") must be smaller than max.freq (", max.freq,
         ") and than .5, both in cycles per observation")
  invisible(TRUE)
}

## build a kernel object of the requested type/order, matching the astsa convention
## that bandwidth Bw = 2*order+1. At order 0 every kernel in the library reduces to
## "no smoothing" (weight 1 at lag 0), so .dp.segCost only evaluates one kernel there.
## NOTE: base R's "dirichlet" and "fejer" kernel types take a second, required
## parameter r (the kernel order; see ?kernel) with no default -- we use r = order,
## i.e. the standard Dirichlet(m,m)/Fejer(m,m) kernel of that dimension, matching how
## they are most commonly used for spectral smoothing.
.dp.make.kernel = function(type, order){
  switch(type,
    bartlett         = bart(order),
    daniell          = kernel("daniell", order),
    modified.daniell = kernel("modified.daniell", order),
    dirichlet        = kernel("dirichlet", order, r = order),
    fejer            = kernel("fejer", order, r = order),
    stop("unknown kernel type: ", type)
  )
}

## MDL contribution of ONE segment for a GIVEN kernel type and order.
## Wrapped in tryCatch: a kernel wider than mvspec can smooth for this segment length
## (e.g. a large order on a short segment) returns Inf rather than propagating the
## error, so .dp.segCost treats that (order, kernel) combination as infeasible and
## falls back to smaller orders.
.dp.MDL.individual = function(data.piece, order, type, taper, min.freq, max.freq, per = NULL){
  if (max.freq > .5) max.freq = .5
  if (min.freq < 0)  min.freq = 0
  Bw          = 2*order + 1
  code.orders = .5*log(length(data.piece) * Bw^2)
  strt = max(1, ceiling(length(data.piece)*min.freq))
  endd = floor(length(data.piece)*max.freq)
  num  = endd - strt + 1
  if (is.null(per)){
    # The Whittle target is deliberately the raw periodogram, computed at mvspec()'s default
    # taper rather than the taper used for the candidate curve. If both used the same taper
    # they would be identical at order 0 (no smoothing), making "no smoothing" a degenerate
    # global minimum of the fit term that the complexity penalty cannot outweigh. Changing
    # this requires a different complexity penalty (e.g. one tied to the kernel's effective
    # degrees of freedom) and its own validation.
    u   = mvspec(c(data.piece), plot = FALSE, demean = TRUE, detrend = FALSE)
    per = u$spec[strt:endd]
  }
  out = tryCatch({
    ker  = .dp.make.kernel(type, order)
    v    = mvspec(c(data.piece), plot = FALSE, taper = taper, kernel = ker,
                   demean = TRUE, detrend = FALSE)
    spec = v$spec[strt:endd]
    loglikelihood = num*log(2*pi) + sum(log(spec) + per/spec)
    code.orders + loglikelihood
  }, error = function(e) Inf)
  out
}

## Segment cost C(.,.): minimize the MDL contribution of one candidate segment jointly
## over kernel type (in `kernels`) and bandwidth order (0..m00).
.dp.segCost = function(data.piece, m0, taper, min.freq, max.freq, kernels){
  n.seg = length(data.piece)
  m00   = if ((n.seg - 1) < 2*m0) floor(n.seg/2) else m0   # order limited by segment length
  strt.f = max(1, ceiling(n.seg*max(min.freq, 0)))
  endd.f = floor(n.seg*min(max.freq, .5))
  # The target is deliberately untapered; see .dp.MDL.individual for why.
  per0   = mvspec(c(data.piece), plot = FALSE, demean = TRUE, detrend = FALSE)$spec[strt.f:endd.f]

  best.mdl = Inf; best.type = kernels[1]; best.order = 0
  for (k in 0:m00){
    if (k == 0){
      # Every kernel reduces to "no smoothing" at order 0, so there is nothing to choose
      # between types: evaluate once and label the result "none".
      val = .dp.MDL.individual(data.piece, 0, kernels[1], taper, min.freq, max.freq, per = per0)
      if (!is.finite(val)) break   # not even "no smoothing" is finite: nothing further to try
      if (val < best.mdl){ best.mdl = val; best.type = "none"; best.order = 0 }
      next
    }
    # NOTE: "dirichlet"/"fejer" require m>=1 internally and are not valid at k=0 at
    # all -- rather than special-case which kernels tolerate k=0 (moot now that k=0
    # is handled above without looping over types), we just try all of them here for
    # k>=1 and let tryCatch (inside .dp.MDL.individual) skip whichever fail.
    any.finite.at.k = FALSE
    for (type in kernels){
      val = .dp.MDL.individual(data.piece, k, type, taper, min.freq, max.freq, per = per0)
      if (is.finite(val)) any.finite.at.k = TRUE
      if (val < best.mdl){ best.mdl = val; best.type = type; best.order = k }
    }
    # a wider kernel (larger k) can only make the fit error more often, not less, so once
    # every kernel type fails at this order there is nothing left to gain from trying
    # larger orders on this segment
    if (!any.finite.at.k) break
  }
  list(mdl = best.mdl, kernel = best.type, order = best.order)
}

## ---------------------------------------------------------------------------------------
## Cached segment cost (fast = TRUE, the default).  Returns the same (mdl, kernel, order)
## triple as .dp.segCost() -- verified to agree to ~1e-13 in mdl and exactly in kernel and
## order on full cost tables -- but avoids redundant work: mvspec() redoes demeaning,
## tapering and a padded FFT for every (order, kernel) candidate on identical data, whereas
## here those are done once per segment and each candidate costs one kernapply().
## Taper weights / padded length are cached per segment LENGTH; kernel objects per
## (type, order). NOTE: mvspec(fast = TRUE) zero-pads to nextn(n.seg), so the frequency
## grid is j/nextn(n.seg), not j/n.seg; the strt/endd band indices below deliberately
## follow .dp.MDL.individual() (computed from n.seg) so the two paths agree.
## ---------------------------------------------------------------------------------------
.dp.newCache = function() list(len = new.env(parent = emptyenv()),
                               ker = new.env(parent = emptyenv()))

.dp.getKernel = function(cache, type, k){
  key = paste(type, k)
  if (!exists(key, envir = cache$ker, inherits = FALSE)){
    ker = tryCatch(.dp.make.kernel(type, k), error = function(e) NULL)
    assign(key, ker, envir = cache$ker)           # NULL cached too: known-infeasible
  }
  get(key, envir = cache$ker, inherits = FALSE)
}

.dp.getLen = function(cache, n.seg, taper){
  key = as.character(n.seg)
  if (!exists(key, envir = cache$len, inherits = FALSE)){
    NewN = nextn(n.seg)                           # mvspec(fast = TRUE) default
    assign(key, list(w = spec.taper(rep(1, n.seg), taper),
                     u2 = 1 - (5/8)*taper*2,
                     NewN = NewN, Nspec = floor(NewN/2)),
           envir = cache$len)
  }
  get(key, envir = cache$len, inherits = FALSE)
}

## raw periodogram on the padded grid, with mvspec's fix-up of the zero frequency
.dp.rawPgram = function(x, n.seg, NewN){
  xf = fft(c(x, rep(0, NewN - n.seg)))
  pg = xf * Conj(xf) / n.seg
  pg[1] = 0.5 * (pg[2] + pg[NewN])
  pg
}

.dp.segCostFast = function(data.piece, m0, taper, min.freq, max.freq, kernels, cache){
  x     = c(data.piece)
  n.seg = length(x)
  m00   = if ((n.seg - 1) < 2*m0) floor(n.seg/2) else m0
  mf = max.freq; if (mf > .5) mf = .5
  nf = min.freq; if (nf < 0)  nf = 0
  strt = max(1, ceiling(n.seg*nf))
  endd = floor(n.seg*mf)
  num  = endd - strt + 1

  li  = .dp.getLen(cache, n.seg, taper)
  idx = 2:(li$Nspec + 1)
  xc  = x - mean(x)
  per0 = Re(.dp.rawPgram(xc, n.seg, li$NewN)[idx])[strt:endd]     # untapered target
  pgT  = .dp.rawPgram(xc * li$w, n.seg, li$NewN)                  # tapered, unsmoothed

  fit = function(k, type){
    ker = .dp.getKernel(cache, type, k)
    if (is.null(ker)) return(Inf)
    tryCatch({
      sm   = kernapply(pgT, ker, circular = TRUE)
      spec = (Re(sm[idx]) / li$u2)[strt:endd]
      .5*log(n.seg * (2*k + 1)^2) + num*log(2*pi) + sum(log(spec) + per0/spec)
    }, error = function(e) Inf)
  }

  ## search loop: identical control flow / tie-breaking to .dp.segCost()
  best.mdl = Inf; best.type = kernels[1]; best.order = 0
  for (k in 0:m00){
    if (k == 0){
      val = fit(0, kernels[1])
      if (!is.finite(val)) break
      if (val < best.mdl){ best.mdl = val; best.type = "none"; best.order = 0 }
      next
    }
    any.finite.at.k = FALSE
    for (type in kernels){
      val = fit(k, type)
      if (is.finite(val)) any.finite.at.k = TRUE
      if (val < best.mdl){ best.mdl = val; best.type = type; best.order = k }
    }
    if (!any.finite.at.k) break
  }
  list(mdl = best.mdl, kernel = best.type, order = best.order)
}

## dispatcher: reference path when no cache is supplied, cached path otherwise.
.dp.segCostAny = function(piece, m0, taper, min.freq, max.freq, kernels, cache = NULL){
  if (is.null(cache)) .dp.segCost(piece, m0, taper, min.freq, max.freq, kernels)
  else .dp.segCostFast(piece, m0, taper, min.freq, max.freq, kernels, cache)
}

## build the segment-cost table C(i,j) for every pair of coarse cut points i<j with
## (cuts[j]-cuts[i]) >= min.span. cost/kernel/order are (K+1)x(K+1) matrices indexed by
## cut-point position (1-based). Every pair is an independent computation, so with
## n.cores > 1 this is parallelized: via parallel::mclapply (forking) on Unix-like
## systems (Mac/Linux), or via a parallel::makeCluster PSOCK cluster on Windows, since
## Windows has no fork(). Work is split into n.cores CHUNKS (not one task per pair) --
## with potentially tens of thousands of small segment evaluations, dispatching one at
## a time means communication/scheduling overhead can rival or exceed the actual
## computation, especially over PSOCK sockets; chunking cuts that overhead from
## O(#pairs) round trips to O(n.cores).
.dp.buildTables = function(xdata, n, cuts, m0, taper, min.freq, max.freq, kernels,
                               min.span, verbose = TRUE, n.cores = 1, fast = TRUE){
  K    = length(cuts) - 1
  cost = matrix(Inf, K + 1, K + 1)
  kty  = matrix(NA_character_, K + 1, K + 1)
  kord = matrix(NA_integer_,   K + 1, K + 1)

  pairs = vector("list", 0)
  for (j in 2:(K+1)) for (i in 1:(j-1)) if ((cuts[j]-cuts[i]) >= min.span) pairs[[length(pairs)+1]] = c(i,j)
  if (verbose) cat(length(pairs), "candidate segments to evaluate",
                   if (fast) "(fast path)\n" else "(reference path)\n")

  ## one cache per chunk: chunks are contiguous slices of `pairs`, so lengths
  ## repeat heavily within a chunk and the cache stays small
  eval_chunk = function(chunk_pairs){
    cache = if (fast) .dp.newCache() else NULL
    lapply(chunk_pairs, function(p){
      piece = xdata[(cuts[p[1]]+1):cuts[p[2]]]
      if (fast) .dp.segCostFast(piece, m0, taper, min.freq, max.freq, kernels, cache)
      else      .dp.segCost(piece, m0, taper, min.freq, max.freq, kernels)
    })
  }

  .dp.splitContig = function(plist, n){
    nn = min(n, length(plist))
    idx = sort(rep(1:nn, length.out = length(plist)))
    split(plist, idx)
  }

  results = NULL

  if (n.cores > 1 && length(pairs) > 0){
    nch = min(n.cores, length(pairs))
    target.updates = 40
    round.size = max(nch, ceiling(length(pairs) / target.updates))
    round.starts = seq(1, length(pairs), by = round.size)
    rounds = lapply(round.starts,
                    function(s) pairs[s:min(s + round.size - 1, length(pairs))])

    if (.Platform$OS.type == "unix"){
      if (verbose) cat("using", n.cores, "cores (mclapply,", length(rounds), "rounds)...\n")
      if (verbose) pb = txtProgressBar(min = 0, max = length(pairs), style = 2)
      chunk.results = vector("list", 0); done = 0
      for (r in seq_along(rounds)){
        sub.chunks = .dp.splitContig(rounds[[r]], n.cores)
        chunk.results = c(chunk.results,
                          parallel::mclapply(sub.chunks, eval_chunk, mc.cores = n.cores))
        done = done + length(rounds[[r]])
        if (verbose) setTxtProgressBar(pb, done)
      }
      if (verbose) close(pb)

    } else {
      if (verbose) cat("using", n.cores, "cores (PSOCK,", length(rounds), "rounds)...\n")
      cl = parallel::makeCluster(n.cores)
      on.exit(parallel::stopCluster(cl), add = TRUE)
      parallel::clusterEvalQ(cl, library(astsa))
      ## functions may live in the astsa namespace OR the global env depending on
      ## how things were loaded, so look each one up (inherits = TRUE) and export
      ## from a scratch environment rather than assuming where they are defined
      fn.names = c(".dp.segCost", ".dp.MDL.individual", ".dp.make.kernel",
                   ".dp.segCostFast", ".dp.newCache", ".dp.getKernel",
                   ".dp.getLen", ".dp.rawPgram")
      here = environment(sys.function())
      fe = new.env()
      for (nm in fn.names){
        obj = if (exists(nm, envir = here, inherits = TRUE)) get(nm, envir = here, inherits = TRUE)
              else get(nm, envir = asNamespace("astsa"), inherits = FALSE)  # unexported internal
        assign(nm, obj, envir = fe)
      }
      parallel::clusterExport(cl, varlist = fn.names, envir = fe)
      parallel::clusterExport(cl,
        varlist = c("xdata", "cuts", "m0", "taper", "min.freq", "max.freq", "kernels", "fast"),
        envir = environment())

      if (verbose) pb = txtProgressBar(min = 0, max = length(pairs), style = 2)
      chunk.results = vector("list", 0); done = 0
      for (r in seq_along(rounds)){
        sub.chunks = .dp.splitContig(rounds[[r]], n.cores)
        chunk.results = c(chunk.results, parallel::parLapply(cl, sub.chunks, eval_chunk))
        done = done + length(rounds[[r]])
        if (verbose) setTxtProgressBar(pb, done)
      }
      if (verbose) close(pb)
    }
    results = unlist(chunk.results, recursive = FALSE)

  } else {
    ## serial: a single cache for the whole table (maximum reuse)
    cache = if (fast) .dp.newCache() else NULL
    if (verbose) pb = txtProgressBar(min = 0, max = length(pairs), style = 2)
    results = vector("list", length(pairs))
    for (p in seq_along(pairs)){
      i = pairs[[p]][1]; j = pairs[[p]][2]
      piece = xdata[(cuts[i]+1):cuts[j]]
      results[[p]] = if (fast) .dp.segCostFast(piece, m0, taper, min.freq, max.freq, kernels, cache)
                     else      .dp.segCost(piece, m0, taper, min.freq, max.freq, kernels)
      if (verbose) setTxtProgressBar(pb, p)
    }
    if (verbose) close(pb)
  }

  for (p in seq_along(pairs)){
    i = pairs[[p]][1]; j = pairs[[p]][2]
    cost[i,j] = results[[p]]$mdl; kty[i,j] = results[[p]]$kernel; kord[i,j] = results[[p]]$order
  }
  list(cost = cost, kernel = kty, order = kord, cuts = cuts)
}

## DP recursion -- G[k+1,j] = min cost of partitioning cuts[1..j] into k segments.
## Rows are indexed 1..(M+1) for k = 0..M segments; columns 1..(K+1) for cut points.
.dp.optimalPartition = function(tables, n, M){
  cost = tables$cost; cuts = tables$cuts; K = length(cuts) - 1
  G    = matrix(Inf, M + 1, K + 1)
  back = matrix(NA_integer_, M + 1, K + 1)
  G[1,1] = 0   # zero segments, at cut point 0

  for (k in 1:M){
    for (j in 2:(K+1)){
      finite.i = which(is.finite(cost[1:(j-1), j]) & is.finite(G[k, 1:(j-1)]))
      if (length(finite.i) == 0) next
      vals = G[k, finite.i] + cost[finite.i, j]
      best = which.min(vals)
      G[k+1, j]    = vals[best]
      back[k+1, j] = finite.i[best]
    }
  }
  list(G = G, back = back, cuts = cuts)
}

## Model-complexity penalty for a partition with m segments of a series of length n:
## log(m) + m*log(n) + m*log(r), r = number of kernels in the library. The m*log(r) term
## is the code length for naming each segment's kernel; it is constant across kernels
## within a segment, so adding it here equals adding log(r) to every segment cost.
.dp.pen = function(m, n, r = 1) log(m) + m*log(n) + m*log(max(r, 1))

## choose m* by adding the model-complexity penalty (.dp.pen) to G[m, end] for each m,
## and minimizing over m = 1,...,M.
.dp.chooseM = function(dp, n, M, r = 1){
  Kp1   = ncol(dp$G)
  total = rep(Inf, M)
  for (m in 1:M){
    g = dp$G[m+1, Kp1]
    if (!is.finite(g)) next
    pen = .dp.pen(m, n, r)
    total[m] = g + pen
  }
  m.star = which.min(total)
  list(m = m.star, mdl = total[m.star], total = total)
}

## backtrack from (m, last cut point) to recover the chain of cut-point indices,
## then map back to actual positions in 1..n via dp$cuts.
.dp.backtrack = function(dp, m){
  Kp1  = ncol(dp$G)
  path = integer(m + 1)
  j    = Kp1
  for (k in m:1){
    i = dp$back[k+1, j]
    path[k] = i
    j = i
  }
  path[m+1] = Kp1
  dp$cuts[path]
}

## Backward (drop-one) pruning.  For each interior break, MDL(partition without it) -
## MDL(partition) is the number of nats that break buys (the merged piece is re-optimised over
## kernel and order; the penalty change from m to m-1 segments is included).  The SUPPORT of a
## partition is min(weakest drop-one worth, gain over NO SPLIT): the second term catches
## breaks that are each strong only because the other is still in place (a pair that jointly
## beats no split by less than either break seems worth alone).  The weakest break is removed,
## everything is re-scored, and so on down to one segment, giving the "pruning path".
## W = the largest support on the path.  A partition survives a threshold `tol` if its support
## is >= tol; the largest surviving partition is returned.  tol is either prune * W (relative)
## or a quantile of W over null surrogates (calibrated).
.dp.prune.path = function(xdata, n, starts, m0, taper, min.freq, max.freq, kernels, cache = NULL){
  r = length(kernels)
  seg.cost = function(a, b) .dp.segCostAny(xdata[a:b], m0, taper, min.freq, max.freq, kernels, cache)$mdl
  ns.mdl = seg.cost(starts[1], n) + .dp.pen(1, n, r)
  steps = list(); cur = starts
  while (length(cur) > 1){
    m = length(cur); u = c(cur, n + 1)
    cst = vapply(1:m, function(i) seg.cost(u[i], u[i+1] - 1), 0)
    tot = sum(cst) + .dp.pen(m, n, r)
    worth = rep(Inf, m)
    for (i in 2:m){
      merged = seg.cost(u[i-1], u[i+1] - 1)
      worth[i] = (merged + (sum(cst) - cst[i-1] - cst[i]) + .dp.pen(m - 1, n, r)) - tot
    }
    w = which.min(worth)
    steps[[length(steps) + 1]] = list(starts = cur, min.worth = worth[w], drop = cur[w],
                                      total = tot, gain = ns.mdl - tot,
                                      support = min(worth[w], ns.mdl - tot))
    cur = cur[-w]
  }
  steps   # step k: the partition BEFORE the k-th removal, with its support
}

.dp.prune = function(xdata, n, starts, m0, taper, min.freq, max.freq, kernels, prune,
                     null.W = NULL, cache = NULL){
  steps = .dp.prune.path(xdata, n, starts, m0, taper, min.freq, max.freq, kernels, cache)
  W     = max(vapply(steps, function(st) st$support, 0))
  tol   = if (is.null(null.W)) prune * max(W, 0)
          else as.numeric(quantile(null.W, prune, type = 1, names = FALSE))
  single = function() list(starts = starts[1], dropped = setdiff(starts, starts[1]), tol = tol, W = W)
  if (prune >= 1 || W <= 0) return(single())                 # nothing can survive
  for (st in steps) if (st$support >= tol && st$support > 0)  # first (largest) partition that passes
    return(list(starts = st$starts, dropped = setdiff(starts, st$starts), tol = tol, W = W))
  single()
}

## Spectral test of ONE break against its two neighbouring segments xa | xb.  The segments are
## compared at a COMMON resolution: with m = the shorter length, blocks of length L (a fraction of m)
## are cut from both segments (50% overlap, split-cosine taper) and the block periodograms are
## averaged on the same Fourier frequencies in (min.freq, max.freq].  At each frequency the ratio
## of the two averaged periodograms is compared with an F distribution (df reduced for the
## overlap); the smallest p-value over frequencies is Sidak-corrected.  The result is
## min over three block lengths L = .5, .33, .25 * m (again Sidak): one block length alone is
## erratic because lines fall on or between Fourier frequencies depending on L.  A short segment of
## the same spectrum is NOT flagged (this is what the per-segment kernel/order costs get wrong): a
## 105-point piece of a line seen at 389 points is compared with 105-point blocks of the 389.
## Validated by simulation on line spectra (false alarm 1-3% at nominal 5%, power ~99% for a
## two-lines -> one-line change at SNR of about 100 in the line); weaker for weak changes.
.dp.breakP = function(xa, xb, min.freq, max.freq, fr = c(.5, .33, .25)){
  m  = min(length(xa), length(xb))
  sid = function(p, J) -expm1(J * log1p(-min(p, 1)))
  welch = function(x, L){
    w  = stats::spec.taper(rep(1, L), p = .25)
    lo = max(1, ceiling(min.freq * L)); hi = floor(min(max.freq, .5) * L)
    if (hi < lo) return(NULL)
    st = seq(1, length(x) - L + 1, by = max(1, floor(L / 2)))
    P  = vapply(st, function(s){
           z = x[s:(s + L - 1)]; z = (z - mean(z)) * w
           (Mod(fft(z))^2 / sum(w^2))[(lo + 1):(hi + 1)] }, numeric(hi - lo + 1))
    P  = matrix(P, nrow = hi - lo + 1)
    list(P = rowMeans(P), K = length(st))
  }
  ps = vapply(fr, function(f){
    L = min(max(floor(m * f), 32), m)
    A = welch(xa, L); B = welch(xb, L)
    if (is.null(A) || is.null(B)) return(1)
    R  = A$P / pmax(B$P, 1e-300)
    cc = stats::pf(R, 2 * A$K * .85, 2 * B$K * .85)
    sid(2 * pmin(cc, 1 - cc), length(R))
  }, 0)
  sid(ps, length(fr))
}

## Backward pruning by the spectral test: test every interior break against its two neighbours,
## remove the one with the LARGEST p-value, re-test (neighbours changed), and continue down to a
## single segment.  Step k of this path has a "worst p" (largest p among its breaks).  The partition
## returned is the first (largest) one whose worst p is <= alpha, or a single segment if none is.
## T = min over the path of the worst p is the statistic of the whole procedure: a break survives
## at level alpha exactly when T <= alpha, so the null distribution of T (from surrogates)
## calibrates alpha, searched locations and all.  p = p-values of the returned breaks, p0 = of the
## partition handed in.  alpha < 0 returns a single segment.
.dp.pruneSpectral = function(xdata, n, starts, min.freq, max.freq, alpha){
  breakp = function(cur){
    if (length(cur) < 2) return(numeric(0))
    u = c(cur, n + 1)
    vapply(2:length(cur), function(i)
      .dp.breakP(xdata[u[i-1]:(u[i]-1)], xdata[u[i]:(u[i+1]-1)], min.freq, max.freq), 0)
  }
  cur = starts; p = breakp(cur); p0 = p; hist = list()
  while (length(cur) > 1){
    hist[[length(hist) + 1]] = list(starts = cur, p = p, worst = max(p))
    cur = cur[-(which.max(p) + 1)]; p = breakp(cur)
  }
  worst = vapply(hist, function(h) h$worst, 0)
  T     = if (length(worst)) min(worst) else 1
  pick  = which(worst <= alpha)[1]
  if (is.na(pick))
    return(list(starts = starts[1], dropped = setdiff(starts, starts[1]), p = numeric(0), p0 = p0, T = T))
  list(starts = hist[[pick]]$starts, dropped = setdiff(starts, hist[[pick]]$starts),
       p = hist[[pick]]$p, p0 = p0, T = T)
}

## Null surrogate of the whole series: same mean, no change over time.
##   "phase": phase-randomised Fourier transform (keeps the periodogram of the full series, so
##            the average spectrum, but any change over time is scrambled away; Gaussian-like)
##   "ar"   : AR(p) fitted by AIC to the full series, simulated with Gaussian innovations
.dp.surrogate = function(x, type){
  n = length(x); mu = mean(x)
  if (type == "phase"){
    z = fft(x - mu); h = floor((n - 1) / 2); idx = 2:(h + 1)
    z[idx] = abs(z[idx]) * complex(modulus = 1, argument = runif(h, 0, 2*pi))
    z[n - idx + 2] = Conj(z[idx])
    return(Re(fft(z, inverse = TRUE)) / n + mu)
  }
  fit = ar(x, aic = TRUE, order.max = min(20, floor(n / 10)))
  burn = 200; e = rnorm(n + burn, sd = sqrt(fit$var.pred))
  y = if (length(fit$ar)) as.numeric(stats::filter(e, fit$ar, method = "recursive")) else e
  y[(burn + 1):(burn + n)] + mu
}

## Null distribution of W: run the WHOLE procedure (same settings, no pruning) on B surrogates.
## Surrogates are drawn here (so `seed` makes it reproducible whatever the core count) and the
## replicates run in parallel, one serial fit per core (mclapply on Unix, PSOCK on Windows).
.dp.nullW = function(xdata, B, surrogate, seed, settings, n.cores, verbose, prune.method){
  if (!is.null(seed)) set.seed(seed)
  Z = lapply(seq_len(B), function(b) .dp.surrogate(xdata, surrogate))
  rep.fun = function(z)
    suppressWarnings(do.call(.dp.offline, c(list(z), settings,
      list(verbose = FALSE, n.cores = 1, prune = 0, null.reps = 0, prune.method = prune.method,
           .W.only = TRUE))))
  if (verbose) cat("null calibration: ", B, " ", surrogate, " surrogates",
                   if (n.cores > 1) paste0(" on ", n.cores, " cores") else "", "\n", sep = "")
  cl = NULL
  if (n.cores > 1 && .Platform$OS.type != "unix"){
    cl = parallel::makeCluster(n.cores)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    parallel::clusterEvalQ(cl, library(astsa))
    here = environment(sys.function())
    fn.names = ls(here, all.names = TRUE, pattern = "^\\.dp\\.")
    fe = new.env()
    for (nm in fn.names) assign(nm, get(nm, envir = here, inherits = TRUE), envir = fe)
    parallel::clusterExport(cl, varlist = fn.names, envir = fe)
  }
  W = numeric(B); step = max(1, n.cores)
  for (s0 in seq(1, B, by = step)){
    ids = s0:min(B, s0 + step - 1)
    r = if (!is.null(cl)) parallel::parLapply(cl, Z[ids], rep.fun)
        else if (n.cores > 1) parallel::mclapply(Z[ids], rep.fun, mc.cores = n.cores)
        else lapply(Z[ids], rep.fun)
    if (!all(vapply(r, is.numeric, TRUE))) stop("a null replicate failed: ", r[[which(!vapply(r, is.numeric, TRUE))[1]]])
    W[ids] = unlist(r)
    if (verbose) cat("  ", max(ids), "/", B, "\r", sep = "")
  }
  if (verbose) cat("\n")
  attr(W, "method") = prune.method
  if (prune.method == "spectral") attr(W, "stat") = "path"
  W
}

## local, full-resolution polish of the interior breakpoints found by the coarse DP.
## For each interior breakpoint in turn (left to right, a couple of sweeps), search
## +/- window around its coarse location, holding the neighboring breakpoints fixed,
## and move it to wherever the SUM of the two adjacent segment costs is smallest.
.dp.refine = function(xdata, n, starts, m0, taper, min.freq, max.freq, kernels,
                       window, sweeps = 2, cache = NULL, min.span = 10){
  m = length(starts)
  if (m <= 1 || window <= 0) return(starts)

  for (sweep in 1:sweeps){
    moved = FALSE
    for (idx in 2:m){
      lo = starts[idx-1] + 1
      hi = if (idx < m) starts[idx+1] - 1 else n
      cand.lo = max(lo, starts[idx] - window)
      cand.hi = min(hi, starts[idx] + window)
      if (cand.lo > cand.hi) next

      best.cost = Inf; best.pos = starts[idx]
      right.end = if (idx < m) starts[idx+1] - 1 else n
      for (cand in cand.lo:cand.hi){
        left.piece  = xdata[starts[idx-1]:(cand-1)]
        right.piece = xdata[cand:right.end]
        if (length(left.piece) < max(10, min.span) || length(right.piece) < max(10, min.span)) next
        tot = .dp.segCostAny(left.piece,  m0, taper, min.freq, max.freq, kernels, cache)$mdl +
              .dp.segCostAny(right.piece, m0, taper, min.freq, max.freq, kernels, cache)$mdl
        if (tot < best.cost){ best.cost = tot; best.pos = cand }
      }
      if (best.pos != starts[idx]) moved = TRUE
      starts[idx] = best.pos
    }
    if (!moved) break
  }
  starts
}





#########################################################################################
##-- SECTION 2: growing-stream (incremental) autoSpecDP
##
## Feed it data in blocks; after each block it returns the optimal segmentation of everything seen so
## far (on the grid), updating the cost table and DP matrices by ONE COLUMN per new cut point instead
## of rebuilding them. Uses Section 1 (.dp.segCostFast, .dp.newCache, .dp.chooseM, .dp.backtrack,
## .dp.refine). Its recursion is a COPY of .dp.optimalPartition: the regression test
## .dp.stream.test() (in autoSpecDP_research.R) must print STREAM == BATCH after any change.
##
## What it does NOT do: decide when a break is real.  The returned segmentation is
## provisional (breaks can move or disappear as data arrive), repeated looks inflate
## false alarms, and a change cannot appear before min.span observations have
## elapsed.  Alarm rules must be calibrated by simulation before use.
##
## Usage:
##   st <- .dp.stream.init(max.n = 2000, grid.step = 10, min.span = 100,
##                         max.freq = .1, kernels = "bartlett", M = 6)
##   o  <- .dp.stream.update(st, x[1:200])      # or any block size
##   st <- o$state; o$fit$breakpoints
## ---------------------------------------------------------------------------

.dp.stream.init = function(max.n, m0 = 10, taper = .5, min.freq = 0, max.freq = .5,
                           kernels = "bartlett", M = 6, min.span = NULL, grid.step = 10){
  .dp.check.band(min.freq, max.freq)
  if (is.null(min.span)) min.span = max(20, 4*(2*m0 + 1))
  cap = ceiling(max.n / grid.step) + 1            # max number of cut points (incl. 0)
  G = matrix(Inf, M + 1, cap); G[1, 1] = 0
  list(x = numeric(0), cuts = c(0, rep(NA_real_, cap - 1)), K1 = 1, cap = cap,
       cost = matrix(Inf, cap, cap),
       kty  = matrix(NA_character_, cap, cap),
       kord = matrix(NA_integer_,   cap, cap),
       G = G, back = matrix(NA_integer_, M + 1, cap),
       m0 = m0, taper = taper, min.freq = min.freq, max.freq = max.freq,
       kernels = kernels, M = M, min.span = min.span, grid.step = grid.step,
       cache = .dp.newCache())
}

## Append `newx`; return list(state = updated state, fit = segmentation or NULL).
## The analysis runs through the last grid point, so up to grid.step - 1 trailing
## observations are held back until the next cut point is reached.
.dp.stream.update = function(st, newx, refine = FALSE, refine.window = NULL){
  st$x = c(st$x, newx)
  n    = length(st$x)
  last = st$cuts[st$K1]
  new.cuts = if (n >= last + st$grid.step) seq(last + st$grid.step, n, by = st$grid.step)
             else numeric(0)
  if (st$K1 + length(new.cuts) > st$cap)
    stop("capacity exceeded: re-initialize with a larger max.n (or restart from a confirmed break)")

  for (cj in new.cuts){
    j = st$K1 + 1
    st$cuts[j] = cj
    ## new column of the cost table: every segment ending at cj
    for (i in 1:(j - 1)){
      if (cj - st$cuts[i] >= st$min.span){
        r = .dp.segCostFast(st$x[(st$cuts[i] + 1):cj], st$m0, st$taper, st$min.freq,
                            st$max.freq, st$kernels, st$cache)
        st$cost[i, j] = r$mdl; st$kty[i, j] = r$kernel; st$kord[i, j] = r$order
      }
    }
    ## new column of the DP matrices (same recursion as .dp.optimalPartition)
    for (k in 1:st$M){
      fi = which(is.finite(st$cost[1:(j - 1), j]) & is.finite(st$G[k, 1:(j - 1)]))
      if (length(fi) == 0) next
      v = st$G[k, fi] + st$cost[fi, j]
      b = which.min(v)
      st$G[k + 1, j]    = v[b]
      st$back[k + 1, j] = fi[b]
    }
    st$K1 = j
  }

  K1 = st$K1; ne = st$cuts[K1]
  if (K1 < 2) return(list(state = st, fit = NULL))
  dp = list(G = st$G[, 1:K1, drop = FALSE], back = st$back[, 1:K1, drop = FALSE],
            cuts = st$cuts[1:K1])
  ch = .dp.chooseM(dp, ne, st$M, length(st$kernels))
  if (!is.finite(ch$mdl)) return(list(state = st, fit = NULL))    # not enough data yet

  starts = .dp.backtrack(dp, ch$m)[1:ch$m] + 1
  if (refine && ch$m > 1){
    if (is.null(refine.window)) refine.window = st$grid.step
    starts = .dp.refine(st$x[1:ne], ne, starts, st$m0, st$taper, st$min.freq, st$max.freq,
                        st$kernels, refine.window, cache = st$cache, min.span = st$min.span)
  }
  u = c(starts, ne); npts = length(starts)
  kmdl = numeric(npts); kord = integer(npts); kty = character(npts)
  for (i in 1:npts){
    endd = if (i < npts) u[i + 1] - 1 else ne
    r = .dp.segCostFast(st$x[starts[i]:endd], st$m0, st$taper, st$min.freq,
                        st$max.freq, st$kernels, st$cache)
    kmdl[i] = r$mdl; kord[i] = r$order; kty[i] = r$kernel
  }
  pen = .dp.pen(npts, ne, length(st$kernels))
  list(state = st,
       fit = list(breakpoints = u, number_of_segments = npts, n.used = ne,
                  segment_kernel_orders_m = kord, segment_kernel_type = kty,
                  mdl = sum(kmdl) + pen,
                  gain.vs.nosplit = (st$cost[1, K1] + .dp.pen(1, ne, length(st$kernels))) - (sum(kmdl) + pen)))
}


#########################################################################################
##-- SECTION 3: sliding-window streaming autoSpecDP
##
## Only the most recent `window` observations are analysed, so (a) the cost per update stays bounded
## (it no longer grows with the length of the stream) and (b) the false-alarm rate per unit time should
## settle to a constant once the window has filled. Uses Sections 1 and 2.
##
## Mechanics.  Cut points stay on the absolute grid (multiples of grid.step from
## the start of the stream).  The segment-cost table is kept for the cuts inside
## the window; when the window is full, the oldest cut is dropped and the table
## is shifted by one row/column (no cost is recomputed).  The DP matrices depend
## on where the window starts, so they are rebuilt from the stored costs on every
## update (pure arithmetic, a few ms).  The MDL penalty uses the WINDOW length.
## Breakpoints are reported in absolute observation numbers.
##
## Usage:
##   st <- .dp.wstream.init(window = 600, grid.step = 10, min.span = 100,
##                          max.freq = .1, kernels = "bartlett", M = 6)
##   o  <- .dp.wstream.update(st, newx); st <- o$state; o$fit$breakpoints
## ---------------------------------------------------------------------------

.dp.wstream.init = function(window, m0 = 10, taper = .5, min.freq = 0, max.freq = .5,
                            kernels = "bartlett", M = 6, min.span = NULL, grid.step = 10){
  .dp.check.band(min.freq, max.freq)
  if (is.null(min.span)) min.span = max(20, 4*(2*m0 + 1))
  cap = floor(window / grid.step) + 1               # cut points kept (incl. window start)
  if ((cap - 1)*grid.step < 2*min.span)
    warning("window shorter than 2*min.span: a break can never be resolved")
  list(x = numeric(0), x0 = 0,                       # x[1] is absolute observation x0 + 1
       cuts = c(0, rep(NA_real_, cap - 1)), K1 = 1, cap = cap,
       cost = matrix(Inf, cap, cap),
       kty  = matrix(NA_character_, cap, cap),
       kord = matrix(NA_integer_,   cap, cap),
       m0 = m0, taper = taper, min.freq = min.freq, max.freq = max.freq,
       kernels = kernels, M = M, min.span = min.span, grid.step = grid.step,
       window = window, cache = .dp.newCache())
}

## drop the oldest cut point; shift the cost table by one row and column
.dp.wstream.slide = function(st){
  K = st$K1
  st$cost[1:(K-1), 1:(K-1)] = st$cost[2:K, 2:K]
  st$kty [1:(K-1), 1:(K-1)] = st$kty [2:K, 2:K]
  st$kord[1:(K-1), 1:(K-1)] = st$kord[2:K, 2:K]
  st$cost[K, ] = Inf;            st$cost[, K] = Inf
  st$kty [K, ] = NA_character_;  st$kty [, K] = NA_character_
  st$kord[K, ] = NA_integer_;    st$kord[, K] = NA_integer_
  st$cuts[1:(K-1)] = st$cuts[2:K]; st$cuts[K] = NA_real_
  st$K1 = K - 1
  st
}

## DP over the cuts currently in the window (same recursion as .dp.optimalPartition)
.dp.wstream.dp = function(st){
  K1 = st$K1; M = st$M
  G = matrix(Inf, M + 1, K1); G[1, 1] = 0
  back = matrix(NA_integer_, M + 1, K1)
  if (K1 >= 2) for (j in 2:K1) for (k in 1:M){
    fi = which(is.finite(st$cost[1:(j - 1), j]) & is.finite(G[k, 1:(j - 1)]))
    if (length(fi) == 0) next
    v = G[k, fi] + st$cost[fi, j]
    b = which.min(v)
    G[k + 1, j] = v[b]; back[k + 1, j] = fi[b]
  }
  list(G = G, back = back, cuts = st$cuts[1:K1])
}

.dp.wstream.update = function(st, newx, refine = FALSE, refine.window = NULL){
  st$x = c(st$x, newx)
  n    = st$x0 + length(st$x)                        # absolute number of observations so far
  last = st$cuts[st$K1]
  new.cuts = if (n >= last + st$grid.step) seq(last + st$grid.step, n, by = st$grid.step)
             else numeric(0)

  for (cj in new.cuts){
    if (st$K1 == st$cap) st = .dp.wstream.slide(st)
    j = st$K1 + 1
    st$cuts[j] = cj
    for (i in 1:(j - 1)){
      if (cj - st$cuts[i] >= st$min.span){
        piece = st$x[(st$cuts[i] + 1 - st$x0):(cj - st$x0)]
        r = .dp.segCostFast(piece, st$m0, st$taper, st$min.freq, st$max.freq,
                            st$kernels, st$cache)
        st$cost[i, j] = r$mdl; st$kty[i, j] = r$kernel; st$kord[i, j] = r$order
      }
    }
    st$K1 = j
  }

  ## forget observations before the window start
  drop = st$cuts[1] - st$x0
  if (drop > 0){ st$x = st$x[-seq_len(drop)]; st$x0 = st$cuts[1] }

  K1 = st$K1; ne = st$cuts[K1]; nw = ne - st$cuts[1]       # nw = window length actually used
  if (K1 < 2) return(list(state = st, fit = NULL))
  dp = .dp.wstream.dp(st)
  ch = .dp.chooseM(dp, nw, st$M, length(st$kernels))
  if (!is.finite(ch$mdl)) return(list(state = st, fit = NULL))

  starts = .dp.backtrack(dp, ch$m)[1:ch$m] + 1             # absolute observation numbers
  if (refine && ch$m > 1){
    if (is.null(refine.window)) refine.window = st$grid.step
    xw = st$x[(st$cuts[1] + 1 - st$x0):(ne - st$x0)]
    s2 = .dp.refine(xw, nw, starts - st$cuts[1], st$m0, st$taper, st$min.freq, st$max.freq,
                    st$kernels, refine.window, cache = st$cache, min.span = st$min.span)
    starts = s2 + st$cuts[1]
  }
  u = c(starts, ne); npts = length(starts)
  kmdl = numeric(npts); kord = integer(npts); kty = character(npts)
  for (i in 1:npts){
    endd = if (i < npts) u[i + 1] - 1 else ne
    r = .dp.segCostFast(st$x[(starts[i] - st$x0):(endd - st$x0)], st$m0, st$taper,
                        st$min.freq, st$max.freq, st$kernels, st$cache)
    kmdl[i] = r$mdl; kord[i] = r$order; kty[i] = r$kernel
  }
  pen = .dp.pen(npts, nw, length(st$kernels))
  list(state = st,
       fit = list(breakpoints = u, number_of_segments = npts, n.used = ne, window.start = st$cuts[1],
                  segment_kernel_orders_m = kord, segment_kernel_type = kty,
                  mdl = sum(kmdl) + pen,
                  gain.vs.nosplit = (st$cost[1, K1] + .dp.pen(1, nw, length(st$kernels))) - (sum(kmdl) + pen)))
}


#########################################################################################
##-- SECTION 4: targeted spectral-change monitor
##   Standalone: base R + stats only; does not call the DP code above. Public: tg_calibrate(),
##   tg_monitor(), tg_reference_check(). Internal: .tg.*  Source this whole file into the global
##   environment (PSOCK workers need the functions there).
#########################################################################################

# ===========================================================================
# Targeted spectral-change monitor (core): the monitor itself, no simulation harness.
# Standalone: base R + stats only; does not use the DP code.
#
# IDEA. Compare the spectrum of the most recent Wc observations with a reference
# spectrum estimated from the first Wref observations (a stretch you believe is in the
# "known" regime). No change-point search, so nothing depends on where break locations land.
#
# STATISTIC. With r_k = (recent spectrum)/(reference spectrum) at Fourier frequencies k/Wc,
#   D(n) = sum_k phi(r_k) over a band of frequencies,
#   phi = r - log r - 1   ("whittle", default)        r + 1/r - 2 ("sym")
#         (log r)^2       ("logsq")                   directional shift score ("score")
# Spectra: split-cosine-bell tapered periodograms, 3-bin smoothed (m = 1); the reference is a
# Welch-type average over windows of length Wc that start every Wc/4 within the first Wref obs.
# BAND. `bw` = keep frequencies within +-bw cycles/obs of the largest peak of the REFERENCE
# spectrum (or give `band = c(lo, hi)` in cycles/obs). Restricting the sum matters a lot in
# simulation ; bw is a prior on how far a change can spread.
# ALARM. D is evaluated every `stride` obs once the recent window no longer overlaps the
# reference (n >= Wref + Wc); an alarm needs D > thr at L consecutive evaluations.
# THRESHOLD. tg_calibrate() simulates Gaussian series with the estimated reference spectrum,
# runs the identical procedure on each (each estimates its own reference), and takes the
# (1 - alpha) quantile of the largest L-run minimum over the monitored span. In simulation
# this "estimated null" was CONSERVATIVE (realised false alarms 0.5-4.5% at nominal 5%).
#
# PUBLIC FUNCTIONS:  tg_calibrate(x, ...)  -> "tg_cal" object (threshold + settings)
#                    tg_monitor(x, cal)    -> D trace, alarm flag and first alarm time
#                    tg_reference_check(x) -> is the reference peak strong enough for the reference band?
# INTERNAL (dot-prefixed, also used by the simulation harness in autoSpecDP_research.R):
#   .tg.pgram .tg.ref .tg.fref .tg.trace .tg.runmin .tg.synth
#
# SCOPE. Built for and tested on tone / modulated-tone data with Gaussian noise and on one real
# bearing-vibration series; it is not a general-purpose detector (a smooth shift of an AR(2)
# resonance by 5-10% of its frequency was not detected).
# ===========================================================================

# ---------------------------------------------------------------------------
# Spectral estimates
# ---------------------------------------------------------------------------
# tapered periodogram at Fourier frequencies k/n, k = 1..floor(n/2)-1
.tg.pgram <- function(x, taper = 0.2) {
  n <- length(x); x <- x - mean(x)
  h <- stats::spec.taper(rep(1, n), p = taper)
  I <- Mod(fft(x*h))^2 / sum(h^2)
  I[2:(n %/% 2)]
}

# Welch-type reference: average periodogram of overlapping length-Wc windows
.tg.ref <- function(xr, Wc, taper) {
  starts <- seq(1, length(xr) - Wc + 1, by = max(1, Wc %/% 4))
  Reduce(`+`, lapply(starts, function(s) .tg.pgram(xr[s:(s + Wc - 1)], taper))) / length(starts)
}

.tg.fref <- function(x1, Wc, taper, m) {
  f <- .tg.ref(x1, Wc, taper)
  if (m <= 0) return(f)
  s <- as.numeric(stats::filter(f, rep(1/(2*m + 1), 2*m + 1), sides = 2))
  ok <- !is.na(s); f[ok] <- s[ok]; f
}

# ---------------------------------------------------------------------------
# Statistic trace and alarm rule
# ---------------------------------------------------------------------------

# Argument check for the frequency restriction. band and bw are in cycles per OBSERVATION (0 to .5),
# not Hz or cycles per year. An empty band would make D = 0 for every window, the calibrated
# threshold 0, and the monitor could never alarm, with no warning; so it is an error.
.tg.check.band <- function(Wc, bw = NULL, band = NULL) {
  if (!is.null(bw) && (!is.numeric(bw) || length(bw) != 1 || !is.finite(bw) || bw <= 0 || bw > .5))
    stop("bw must be a single number in (0, .5], in cycles per observation")
  if (!is.null(band)) {
    if (!is.numeric(band) || length(band) != 2 || any(!is.finite(band)) ||
        band[1] < 0 || band[2] > .5 || band[1] >= band[2])
      stop("band must be c(lo, hi) with 0 <= lo < hi <= .5, in cycles per OBSERVATION (not Hz or cycles per year)")
    fr <- (1:(Wc %/% 2 - 1)) / Wc
    if (!any(fr >= band[1] & fr <= band[2]))
      stop("band selects no Fourier frequencies: the grid spacing is 1/Wc = ", signif(1/Wc, 3),
           " cycles per observation")
  }
  invisible(TRUE)
}

# D(n) trace on the grid ends = Wref+Wc, Wref+Wc+stride, ...  (recent window disjoint from reference)
.tg.trace <- function(x, Wref = 1200, Wc = 600, stride = 25, m = 1, taper = 0.2, band = NULL, stat = c("whittle", "sym", "logsq", "score"), bw = NULL) {
  stat <- match.arg(stat)
  stopifnot(is.null(bw) || is.null(band))
  stopifnot(Wref >= Wc)
  sm <- function(I) {
    if (m <= 0) return(I)
    s <- as.numeric(stats::filter(I, rep(1/(2*m + 1), 2*m + 1), sides = 2))
    ok <- !is.na(s); I[ok] <- s[ok]; I
  }
  fref <- sm(.tg.ref(x[1:Wref], Wc, taper))
  fr <- (1:(Wc %/% 2 - 1)) / Wc                          # cycles per observation
  idx <- if (!is.null(bw)) {
    # data-derived band: +-bw cycles/obs around the largest peak of the REFERENCE spectrum
    # (centre estimated from the series; bw is the prior on how far a change may spread)
    which(abs(fr - fr[which.max(fref)]) <= bw)
  } else if (is.null(band)) seq_along(fr) else which(fr >= band[1] & fr <= band[2])
  if (length(idx) == 0)
    stop("the frequency band selects no Fourier frequencies (grid spacing 1/Wc = ", signif(1/Wc, 3),
         " cycles per observation); band and bw are in cycles per OBSERVATION")
  g <- NULL
  if (stat == "score") {
    # directional (frequency-shift) score: weights g_k = d log fref / d(bin), from the 7-bin-smoothed log reference.
    # D = |sum g_k (r_k - 1)| / sqrt(sum g_k^2) over the band; targets a rigid shift of the spectrum (two-sided).
    lf <- log(fref); mw <- 3
    lfs <- as.numeric(stats::filter(lf, rep(1/(2*mw + 1), 2*mw + 1), sides = 2))
    ok <- !is.na(lfs); lf[ok] <- lfs[ok]
    K <- length(lf); g <- c(0, (lf[3:K] - lf[1:(K - 2)])/2, 0)
  }
  ends <- seq(Wref + Wc, length(x), by = stride)
  D <- vapply(ends, function(e) {
    r <- sm(.tg.pgram(x[(e - Wc + 1):e], taper))[idx] / fref[idx]
    switch(stat, whittle = sum(r - log(r) - 1),
                 sym     = sum(r + 1/r - 2),        # symmetric in r <-> 1/r
                 logsq   = sum(log(r)^2),
                 score   = abs(sum(g[idx]*(r - 1))) / sqrt(sum(g[idx]^2)))           # symmetric, tails grow only logarithmically
  }, 0)
  list(ends = ends, D = D)
}

# running minimum over L consecutive evaluations: exceeds thr iff D > thr L times in a row
.tg.runmin <- function(D, L) {
  if (L == 1) return(D)
  c(rep(-Inf, L - 1), vapply(L:length(D), function(j) min(D[(j - L + 1):j]), 0))
}

# ---------------------------------------------------------------------------
# Null simulation (spectral synthesis)
# ---------------------------------------------------------------------------
# Gaussian stationary series (length N, N even) with E|fft(x)_k|^2 / N = fhat(k/N), mean zero
.tg.synth <- function(fhat, Wc, N) {
  stopifnot(N %% 2 == 0)
  fr <- (1:(Wc %/% 2 - 1)) / Wc
  K <- N %/% 2; k <- 1:(K - 1)
  fk <- stats::approx(fr, fhat, xout = c(k, K) / N, rule = 2)$y
  X <- complex(N)
  Z <- sqrt(N * fk[k] / 2) * complex(real = rnorm(K - 1), imaginary = rnorm(K - 1))
  X[k + 1] <- Z
  X[N - k + 1] <- Conj(Z)
  X[K + 1] <- complex(real = sqrt(N * fk[K]) * rnorm(1))
  Re(fft(X, inverse = TRUE)) / N
}

# ---------------------------------------------------------------------------
# User-facing entry points
# ---------------------------------------------------------------------------

# tg_calibrate: threshold from the stream's OWN first Wref observations (estimated null).
#   x       numeric series; only x[1:Wref] is used, and it should be in the regime you call "normal"
#   Wref    reference length;  Wc  recent-window length (Wref >= Wc; Wref >= 2*Wc is better)
#   stride  evaluation spacing;  L  consecutive exceedances needed;  alpha  nominal false-alarm
#           probability over the monitored span
#   span    number of monitored observations beyond n = Wref + Wc that the threshold must cover
#           (a longer span means a stricter threshold)
#   Bcal    number of simulated null series (at least ~10/alpha is advisable)
#   bw/band frequency restriction (see header); stat = "whittle" | "sym" | "logsq"
tg_calibrate <- function(x, Wref = 1200, Wc = 600, stride = 25, L = 1, alpha = 0.01,
                         span = 2000, Bcal = 1000, m = 1, taper = 0.2,
                         stat = "whittle", bw = 0.02, band = NULL, seed = NULL) {
  stopifnot(is.numeric(x), length(x) >= Wref, Wref >= Wc, Wc >= 8, L >= 1)
  if (!is.null(bw) && !is.null(band)) stop("give either bw or band, not both")
  .tg.check.band(Wc, bw, band)
  if (stat == "score") stop("stat = 'score' was an experiment and is not supported here")
  if (Bcal * alpha < 10) warning("Bcal * alpha < 10: the threshold rests on fewer than 10 simulated exceedances")
  if (!is.null(seed)) set.seed(seed)
  fhat <- .tg.fref(x[1:Wref], Wc, taper, m)
  N <- Wref + Wc + span; if (N %% 2 == 1) N <- N + 1
  sc <- vapply(seq_len(Bcal), function(j) {
    D <- .tg.trace(.tg.synth(fhat, Wc, N), Wref, Wc, stride, m, taper, band, stat, bw)$D
    max(.tg.runmin(D, L))
  }, 0)
  structure(list(thr = unname(quantile(sc, 1 - alpha)), L = L, alpha = alpha, span = span,
                 Bcal = Bcal, Wref = Wref, Wc = Wc, stride = stride, m = m, taper = taper,
                 stat = stat, bw = bw, band = band), class = "tg_cal")
}

print.tg_cal <- function(x, ...) {
  cat(sprintf("tg_cal: stat=%s, Wref=%d, Wc=%d, stride=%d, L=%d, alpha=%g, span=%d, Bcal=%d, thr=%.2f\n",
              x$stat, x$Wref, x$Wc, x$stride, x$L, x$alpha, x$span, x$Bcal, x$thr))
  invisible(x)
}

# tg_monitor: apply a calibration to a series (call it again on the growing series for real-time use;
# the reference is re-estimated from x[1:Wref], so x must start at the same point as the calibration series).
#   returns ends (n at each evaluation), D, runmin, thr, alarm (TRUE/FALSE), alarm_time (first n alarmed or NA),
#   monitored (observations beyond Wref + Wc)
tg_monitor <- function(x, cal) {
  stopifnot(inherits(cal, "tg_cal"), is.numeric(x))
  n0 <- cal$Wref + cal$Wc
  if (length(x) < n0)
    return(list(ends = numeric(0), D = numeric(0), runmin = numeric(0), thr = cal$thr, alarm = FALSE,
                alarm_time = NA_real_, monitored = 0, note = "series shorter than Wref + Wc"))
  tr <- .tg.trace(x, cal$Wref, cal$Wc, cal$stride, cal$m, cal$taper, cal$band, cal$stat, cal$bw)
  rm <- .tg.runmin(tr$D, cal$L)
  j <- which(rm > cal$thr)
  out <- list(ends = tr$ends, D = tr$D, runmin = rm, thr = cal$thr, alarm = length(j) > 0,
              alarm_time = if (length(j)) tr$ends[j[1]] else NA_real_, monitored = length(x) - n0)
  if (out$monitored > cal$span)
    warning("series monitored beyond the calibrated span; false-alarm probability is no longer alpha")
  out
}

# tg_reference_check: diagnostic for the reference band (bw). The band is centred on the largest peak of the smoothed
# reference spectrum; in simulation (tone / modulated-tone, white noise, Wref = 2*Wc) the band covered the signal in
# >= 99% of series when the peak-to-median ratio of that spectrum was >= 5.5, about 90-99% near 4.3-5, and only
# 36-82% at 3.0-3.7 (pure noise gives a ratio near 3, 99th percentile 4.3). Thresholds are indicative; other signals,
# noise colours or Wref/Wc ratios will differ. Returns peak frequency (cycles/obs), the ratio and a verdict.
tg_reference_check <- function(x, Wref = 1200, Wc = 600, m = 1, taper = 0.2) {
  stopifnot(is.numeric(x), length(x) >= Wref, Wref >= Wc)
  f <- .tg.fref(x[1:Wref], Wc, taper, m)
  ratio <- max(f) / median(f)
  list(peak_freq = which.max(f) / Wc, peak_to_median = ratio,
       verdict = if (ratio < 4) "weak: peak not clearly above noise, reference band likely misplaced"
                 else if (ratio < 5.5) "marginal: reference band covers the signal in roughly 90-99% of simulated series"
                 else "clear: reference band reliable in simulation")
}
