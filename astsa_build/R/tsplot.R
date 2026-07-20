tsplot <- function(x, y = NULL, main = NULL, ylab = NULL, xlab = NULL, title = NULL,
                   type = NULL, margins = .25, omargins = 0, ncolm = 1, byrow = TRUE,
                   nx = NULL, ny = nx, minor = TRUE, nxm = 2, nym = 1,
                   xm.grid = TRUE, ym.grid = TRUE, col = 1,
                   gg = FALSE, spaghetti = FALSE, pch = NULL, lty = 1, lwd = 1,
                   mgpp = 0, topper = NULL, addLegend = FALSE, location = 'topright',
                   boxit = TRUE, horiz = FALSE, legend = NULL, llwd = NULL,
                   scale = 1, reset.par = TRUE, ...) {

  old.par <- par(no.readonly = TRUE)

  # --- Derived constants ---
  nser  <- max(NCOL(x), NCOL(y))
  type0 <- 'n'
  type1 <- if (is.null(type)) 'l' else type

  if (is.null(topper)) topper <- if (is.null(main)) 0 else .5
  if (is.null(xlab))   xlab   <- 'Time'
  if (is.na(any(nx)))  nxm    <- 0
  if (is.na(any(ny)))  nym    <- 0

  # Recycle aesthetics to nser length
  pch <- rep(pch, ceiling(nser / max(length(pch), 1)))
  lty <- rep(lty, ceiling(nser / length(lty)))
  lwd <- rep(lwd, ceiling(nser / length(lwd)))

  # --- Helper: shared par() settings for single-series panels ---
  .set_par_single <- function() {
  # calculate adjusted 'mar' and 'mgp'
   c_mar <- c(2.5, 2.5, 1 + topper, .5) + margins
   c_mgp <- c(1.6, .3, 0) + mgpp
  # adjust any negative values and set other values
   par(mar      = pmax(c_mar, 0),
       mgp      = pmax(c_mgp, 0),
       cex.main = 1.2,
       tcl      = -.2,
       cex.axis = if (gg) .8 else .9)
}

  # --- Helper: shared Grid() call ---
  .draw_grid <- function(grid_col = NULL) {
    args <- list(nx = nx, ny = ny, minor = minor,
                 nxm = nxm, nym = nym,
                 xm.grid = xm.grid, ym.grid = ym.grid)
    if (!is.null(grid_col)) args$col <- grid_col
    do.call(Grid, args)
  }

  # --- Helper: shared multi-series par() setup ---
  .set_par_multi <- function() {
    dims <- c(ceiling(nser / ncolm), ncolm)
    if (byrow) par(mfrow = dims) else par(mfcol = dims)
    extra <- if (gg) list(tcl = -.2, cex.axis = .9) else list()
    c_oma <- c(0, 0, 3 * topper, 0) + omargins  # to check outer margins
    do.call(par, c(list(cex.lab = 1.1,
                        oma     = pmax(c_oma, 0),
                        cex     = .85 * scale),
                   extra))
  }

  # --- Helper: resolve ylab for multi-series ---
  .resolve_ylab_multi <- function() {
    if (!is.null(ylab)) return(rep(ylab, ceiling(nser / length(ylab))))
    src <- if (is.null(y)) x else y
    colnames(as.matrix(src), do.NULL = FALSE, prefix = "Series ")
  }

  # ---------------------------------------------------------------
  # SPAGHETTI (nser > 1 only)
  # ---------------------------------------------------------------
  if (spaghetti && nser > 1) {
    culer <- rep(col, ceiling(nser / length(col)))
    if (is.null(ylab)) ylab <- NA

    if (is.null(y)) {
      u       <- x[, 1]
      u[1:2]  <- c(min(x, na.rm = TRUE), max(x, na.rm = TRUE))
      tsplot(u, ylab = ylab[1], type = type0, xlab = xlab, gg = gg,
             nx = nx, ny = ny, minor = minor, nxm = nxm, nym = nym,
             main = main, pch = pch[1], margins = margins, ...)
      for (h in seq_len(nser))
        lines(x[, h], col = culer[h], type = type1,
              pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
    } else {
      u       <- y[, 1]
      u[1:2]  <- c(min(y, na.rm = TRUE), max(y, na.rm = TRUE))
      tsplot(x, u, ylab = ylab[1], type = type0, xlab = xlab, gg = gg,
             minor = minor, nxm = nxm, nym = nym,
             main = main, pch = pch[1], margins = margins, ...)
      for (h in seq_len(nser))
        lines(x, y[, h], col = culer[h], type = type1,
              pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
    }

    if (addLegend) {
      namez <- if (!is.null(legend)) legend else {
        colnames(as.matrix(if (is.null(y)) x else y))
      }
      box.col <- if (gg) gray(1, .7)  else gray(.62, .3)
      bg      <- if (gg) gray(.92, .8) else gray(1,  .8)
      bty     <- if (boxit) 'o' else 'n'
      if (!is.null(llwd)) lwd <- llwd
      legend(location, legend = namez, lty = lty, col = col, bty = bty,
             box.col = box.col, bg = bg, lwd = lwd, pch = pch,
             horiz = horiz, cex = .9)
    }

    box(col = if (gg) gray(1) else gray(.62))
    return(invisible(recordPlot()))
  }

  # ---------------------------------------------------------------
  # NON-SPAGHETTI
  # ---------------------------------------------------------------
  if (!gg) {
    # --- plain (no gg) ---
    if (nser == 1) {
      if (is.null(ylab))
        ylab <- if (is.null(y)) deparse(substitute(x)) else deparse(substitute(y))
      .set_par_single()
      plot(x, y, type = type0, ann = FALSE, main = NULL, ...)
      .draw_grid()
      par(new = TRUE)
      plot(x, y, type = type1, main = main, ylab = ylab, xlab = xlab,
           col = col, pch = pch, lty = lty, lwd = lwd, ...)
      box(col = 'gray62')
    } else {
      ylab  <- .resolve_ylab_multi()
      xlab  <- rep(xlab, ceiling(nser / length(xlab)))
      culer <- rep(col, nser)
      .set_par_multi()
      for (h in seq_len(nser)) {
        if (is.null(y))
          tsplot(x[, h], ylab = ylab[h], col = culer[h], type = type,
                 xlab = xlab[h], main = title[h],
                 nx = nx, ny = ny, minor = minor, nxm = nxm, nym = nym,
                 pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
        else
          tsplot(x, y[, h], ylab = ylab[h], col = culer[h], type = type,
                 xlab = xlab[h], main = title[h], minor = minor,
                 nx = nx, ny = ny, nxm = nxm, nym = nym,
                 pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
      }
      mtext(text = main, line = -.5, outer = TRUE, font = 2)
      if (reset.par) par(old.par)
    }

  } else {
    # --- gg style ---
    if (nser == 1) {
      if (is.null(ylab))
        ylab <- if (is.null(y)) deparse(substitute(x)) else deparse(substitute(y))
      .set_par_single()
      plot(x, y, type = type0, ann = FALSE, main = NULL, ...)
      brdr <- par("usr")
      rect(brdr[1], brdr[3], brdr[2], brdr[4], col = gray(.92), border = 'white')
      .draw_grid(grid_col = 'white')
      par(new = TRUE)
      plot(x, y, type = type1, main = main, ylab = ylab, xlab = xlab,
           col = col, pch = pch, lty = lty, lwd = lwd, ...)
      box(col = 'white', lwd = 2)
    } else {
      ylab  <- .resolve_ylab_multi()
      xlab  <- rep(xlab, ceiling(nser / length(xlab)))
      culer <- rep(col, nser)
      .set_par_multi()
      for (h in seq_len(nser)) {
        if (is.null(y))
          tsplot(x[, h], ylab = ylab[h], col = culer[h], type = type,
                 xlab = xlab[h], main = title[h], gg = TRUE,
                 nx = nx, ny = ny, minor = minor, nxm = nxm, nym = nym,
                 pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
        else
          tsplot(x, y[, h], ylab = ylab[h], col = culer[h], type = type,
                 xlab = xlab[h], main = title[h], gg = TRUE, minor = minor,
                 nx = nx, ny = ny, nxm = nxm, nym = nym,
                 pch = pch[h], lty = lty[h], lwd = lwd[h], ...)
      }
      mtext(text = main, line = -.5, outer = TRUE, font = 2)
      if (reset.par) par(old.par)
    }
  }

  return(invisible(recordPlot()))
}
