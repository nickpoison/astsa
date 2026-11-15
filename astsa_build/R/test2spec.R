test2spec <- function(x1, x2, kernel = "modified.daniell", r = NULL,
                      bandwidth = NULL, spans1 = NULL, spans2 = NULL,
                      B = 1000, n_grid = NULL, divergence = c("is", "log"),
                      normalize = FALSE, taper = 0, seed = NULL,
                      dependent = FALSE, max_coh = 0.99, coh_correct = TRUE) {

  # dependent = TRUE: the two series are observed at the same time points and
  #   may be correlated (unspecified cross-dependence). The bootstrap then
  #   draws the two periodograms jointly, with the frequency-wise squared
  #   coherency estimated from the data. Requires length(x1) == length(x2).
  # coh_correct (default TRUE, used only when dependent = TRUE): remove the approximate upward bias of the smoothed
  #   squared coherency, (L * coh2 - 1) / (L - 1), L = effective number of
  #   averaged periodogram ordinates (spec.pgram's df / 2).
  # max_coh: upper cap on the estimated coherency (in [0, 1)), which keeps the
  #   joint bootstrap distribution non-degenerate.

  dname <- paste(paste(deparse(substitute(x1)), collapse = ""), "and",
                 paste(deparse(substitute(x2)), collapse = ""))
  divergence <- match.arg(divergence)

  # ---- input checks ---------------------------------------------------------
  x1 <- as.numeric(x1)   # drops ts attributes so that frequency = 1
  x2 <- as.numeric(x2)
  if (anyNA(x1) || anyNA(x2)) stop("missing values are not allowed")
  n1 <- length(x1); n2 <- length(x2)
  n_min <- min(n1, n2)
  if (n_min < 20) stop("each series needs at least 20 observations")
  B <- as.integer(B)
  if (is.na(B) || B < 1) stop("'B' must be a positive integer")
  if (!is.numeric(taper) || length(taper) != 1 || taper < 0 || taper > 0.5)
    stop("'taper' must be in [0, 0.5]")
  if (dependent) {
    if (n1 != n2)
      stop("'dependent = TRUE' requires series of equal length observed at the same time points")
    if (!is.numeric(max_coh) || length(max_coh) != 1 || max_coh < 0 || max_coh >= 1)
      stop("'max_coh' must be in [0, 1)")
  }

  # ---- smoothing kernels ----------------------------------------------------
  if (inherits(kernel, "tskernel")) {                      # one kernel for both
    kern1 <- kern2 <- kernel
    kernel_name <- "user-supplied"
  } else if (is.list(kernel) && length(kernel) == 2 &&
             all(vapply(kernel, inherits, logical(1), what = "tskernel"))) {
    kern1 <- kernel[[1]]; kern2 <- kernel[[2]]             # one kernel per series
    kernel_name <- "user-supplied"
  } else {                                                 # build from a name
    kernel_name <- match.arg(kernel, c("modified.daniell", "daniell",
                                       "bartlett", "dirichlet", "fejer"))
    # common bandwidth in frequency units unless spans are given
    if (is.null(bandwidth)) bandwidth <- max(2, round(n_min^(1/3))) / n_min
    m1 <- if (is.null(spans1)) round(bandwidth * n1) else spans1 %/% 2
    m2 <- if (is.null(spans2)) round(bandwidth * n2) else spans2 %/% 2
    if (any(m1 < 1) || any(m2 < 1))
      stop("smoothing half-width is < 1; increase 'bandwidth' or 'spans'")
    kern1 <- .make_kernel(kernel_name, as.integer(m1), r)
    kern2 <- .make_kernel(kernel_name, as.integer(m2), r)
  }
  if (2 * kern1$m + 1 >= n1 %/% 2 || 2 * kern2$m + 1 >= n2 %/% 2)
    stop("smoothing kernel is too wide for the series length")
  # compare bandwidths of the two estimators, in cycles per observation
  bw <- c(stats::bandwidth.kernel(kern1) / n1, stats::bandwidth.kernel(kern2) / n2)
  if (max(bw) / min(bw) > 1.25)
    warning(sprintf(paste("smoothing bandwidths differ (%.4f vs %.4f cycles/obs);",
                          "unequal bandwidths can distort the size of the test"),
                    bw[1], bw[2]))

  # ---- common interior frequency grid on (0, 0.5) (midpoint rule) -----------
  if (is.null(n_grid)) n_grid <- min(n_min %/% 2, 500L)
  n_grid <- as.integer(n_grid)
  if (n_grid < 10) stop("'n_grid' must be at least 10")
  freq_grid <- (seq_len(n_grid) - 0.5) / (2 * n_grid)
  d_omega   <- 0.5 / n_grid

  if (!is.null(seed)) set.seed(seed)

  # ---- 1. observed spectral estimates on the grid ---------------------------
  f1_hat <- .est_spec_grid(x1, freq_grid, kern1, taper)
  f2_hat <- .est_spec_grid(x2, freq_grid, kern2, taper)
  if (normalize) {
    f1_hat <- f1_hat / mean(f1_hat)
    f2_hat <- f2_hat / mean(f2_hat)
  }

  # ---- 1b. coherency between the series (only if dependence is allowed) ----------
  # Only |coherency| matters for the joint law of the two periodograms, so the
  # phase of the cross-spectrum is not needed. The estimate uses the kernel of x1.
  coh_hat <- NULL
  if (dependent) {
    sp_x <- stats::spec.pgram(cbind(x1, x2), kernel = kern1, taper = taper,
                              fast = FALSE, detrend = TRUE, plot = FALSE)
    coh2 <- stats::approx(sp_x$freq, sp_x$coh[, 1], xout = freq_grid, rule = 2)$y
    if (coh_correct) {
      L <- sp_x$df / 2
      if (L > 1) coh2 <- (L * coh2 - 1) / (L - 1)
    }
    coh_hat <- pmin(sqrt(pmax(coh2, 0)), max_coh)   # |coherency|, capped
  }

  # ---- 2. pooled spectrum under H0 and numerical floor ----------------------
  f0_hat <- (n1 * f1_hat + n2 * f2_hat) / (n1 + n2)
  floor_val <- 1e-8 * max(f0_hat)

  # ---- 3. observed statistic ------------------------------------------------
  T_obs <- .sym_spectral_div(f1_hat, f2_hat, d_omega, divergence, normalize, floor_val)

  # ---- 4. frequency-domain bootstrap under H0 -------------------------------
  setup <- function(N, kern) {
    nat_freq <- seq_len(N %/% 2) / N                 # Fourier freqs in (0, 0.5]
    list(N  = N,
         w  = c(rev(kern$coef[-1L]), kern$coef),     # full symmetric kernel weights
         f0 = stats::approx(freq_grid, f0_hat, xout = nat_freq, rule = 2)$y,
         cc = if (dependent)
                stats::approx(freq_grid, coh_hat, xout = nat_freq, rule = 2)$y,
         ip = .interp_setup(nat_freq, freq_grid))
  }
  s1 <- setup(n1, kern1)
  s2 <- setup(n2, kern2)

  T_boot <- numeric(B)
  chunk  <- max(1L, floor(2e6 / max(n1, n2)))        # limit memory use
  if (dependent) chunk <- max(1L, chunk %/% 3L)      # joint draw needs more memory
  done   <- 0L
  while (done < B) {
    bb  <- min(chunk, B - done)
    if (dependent) {
      pg  <- .boot_pgram_pair(s1, bb)                # correlated periodograms
      f1s <- .boot_spec(s1, bb, pg$I1, pg$nyq1)
      f2s <- .boot_spec(s2, bb, pg$I2, pg$nyq2)
    } else {
      f1s <- .boot_spec(s1, bb)
      f2s <- .boot_spec(s2, bb)
    }
    T_boot[done + seq_len(bb)] <-
      .sym_spectral_div(f1s, f2s, d_omega, divergence, normalize, floor_val)
    done <- done + bb
  }

  p_val <- (1 + sum(T_boot >= T_obs)) / (B + 1)

  structure(list(
    statistic   = c(T = T_obs),
    p.value     = p_val,
    alternative = "the spectral densities differ",
    method      = sprintf("Two-sample spectral density test (%s divergence, %s kernel, %s series, B = %d)",
                          divergence, kernel_name,
                          if (dependent) "dependent" else "independent", B),
    data.name   = dname,
    boot_dist   = T_boot,
    freq_grid   = freq_grid,
    f1_hat      = f1_hat,
    f2_hat      = f2_hat,
    f0_hat      = f0_hat,
    coherency   = coh_hat,               # NULL unless dependent = TRUE
    dependent   = dependent,
    n1 = n1, n2 = n2,
    m1 = kern1$m, m2 = kern2$m,          # total kernel half-widths (Fourier freqs)
    bandwidth = bw,                      # kernel bandwidths in cycles/observation
    kernel      = kernel_name
  ), class = "htest")
}


# ---- helpers ----------------------------------------------------------------

# Build a tskernel from a name; m may be a vector (convolution) for the
# Daniell-type and Bartlett kernels, but must be a single value for
# dirichlet / fejer.
.make_kernel <- function(name, m, r = NULL) {
  if (name == "bartlett") {
    bart(m)                       # astsa::bart, triangular kernel of width 2m + 1
  } else if (name %in% c("dirichlet", "fejer")) {
    if (is.null(r)) stop("the '", name, "' kernel requires the parameter 'r'")
    if (length(m) != 1) stop("the '", name, "' kernel cannot be convolved; use a single span")
    stats::kernel(name, m = m, r = r)
  } else {
    stats::kernel(name, m = m)
  }
}

# Smoothed periodogram (mvspec, no padding) interpolated onto the common grid
.est_spec_grid <- function(x, freq_grid, kern, taper = 0) {
  sp <- mvspec(x, kernel = kern, taper = taper, fast = FALSE,
               detrend = TRUE, plot = FALSE)
  stats::approx(sp$freq, sp$spec, xout = freq_grid, rule = 2)$y
}

# Linear interpolation set-up (constant extrapolation, same as approx(rule = 2))
.interp_setup <- function(xk, xout) {
  pos <- findInterval(xout, xk, all.inside = TRUE)
  t   <- pmin(pmax((xout - xk[pos]) / (xk[pos + 1] - xk[pos]), 0), 1)
  list(pos = pos, t = t)
}
.interp_apply <- function(Fm, ip) {   # Fm: (native freqs) x B matrix
  Fm[ip$pos, , drop = FALSE] * (1 - ip$t) + Fm[ip$pos + 1L, , drop = FALSE] * ip$t
}

# Simulate B smoothed periodograms under f0 for one sample; returns n_grid x B.
# Mimics spec.pgram: full symmetric periodogram, I(0) replaced by
# (I(1) + I(N-1)) / 2, circular smoothing, keep frequencies j/N, j = 1..N/2.
.boot_spec <- function(s, B, I_half = NULL, I_nyq = NULL) {
  N <- s$N
  K <- (N - 1) %/% 2
  if (is.null(I_half)) {                      # independent draw (default)
    I_half <- s$f0[seq_len(K)] * matrix(stats::rexp(K * B), K, B)
    if (N %% 2 == 0) I_nyq <- s$f0[K + 1] * stats::rchisq(B, df = 1)
  }
  full <- rbind(I_half[1, ],                                   # frequency 0
                I_half,                                        # 1..K
                if (N %% 2 == 0) I_nyq,                        # Nyquist
                I_half[K:1, , drop = FALSE])                   # mirror image
  sm <- stats::filter(full, s$w, sides = 2, circular = TRUE)
  sm <- matrix(as.numeric(sm), nrow = N)
  .interp_apply(sm[2:(N %/% 2 + 1), , drop = FALSE], s$ip)
}

# Jointly simulate periodograms of two series with a common spectrum f0 and
# frequency-wise coherency cc (both series have length s$N). At each Fourier
# frequency, Z1 = sqrt(f0) e1 and Z2 = sqrt(f0) (cc e1 + sqrt(1 - cc^2) e2),
# with e1, e2 independent standard complex normals; I_k = |Z_k|^2. The
# marginals are f0 * Exp(1) as in the independent case, with
# corr(I1, I2) = cc^2. At the Nyquist frequency the coefficients are real.
.boot_pgram_pair <- function(s, B) {
  N  <- s$N
  K  <- (N - 1) %/% 2
  cc <- s$cc[seq_len(K)]
  ss <- sqrt(1 - cc^2)
  f0 <- s$f0[seq_len(K)]
  rn <- function(n) matrix(stats::rnorm(n * B), n, B)
  a1 <- rn(K); b1 <- rn(K); a2 <- rn(K); b2 <- rn(K)
  out <- list(I1 = f0 * (a1^2 + b1^2) / 2,
              I2 = f0 * ((cc * a1 + ss * a2)^2 + (cc * b1 + ss * b2)^2) / 2,
              nyq1 = NULL, nyq2 = NULL)
  if (N %% 2 == 0) {
    cn <- s$cc[K + 1]
    z1 <- stats::rnorm(B); z2 <- stats::rnorm(B)
    out$nyq1 <- s$f0[K + 1] * z1^2
    out$nyq2 <- s$f0[K + 1] * (cn * z1 + sqrt(1 - cn^2) * z2)^2
  }
  out
}

# Symmetric divergence between spectra (vectors or n_grid x B matrices);
# returns one value per column.
.sym_spectral_div <- function(f1, f2, d_omega, divergence = "is",
                              normalize = FALSE, floor_val = 0) {
  f1 <- pmax(as.matrix(f1), floor_val)
  f2 <- pmax(as.matrix(f2), floor_val)
  if (normalize) {
    f1 <- sweep(f1, 2, colMeans(f1), "/")
    f2 <- sweep(f2, 2, colMeans(f2), "/")
  }
  integrand <- if (divergence == "is") f1 / f2 + f2 / f1 - 2
               else (log(f1) - log(f2))^2
  colSums(integrand) * d_omega
}
