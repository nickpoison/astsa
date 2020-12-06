\name{Grid}
\alias{Grid}
\title{A Better Add Grid to a Plot 
}
\description{Adds a grid to an existing plot with major and minor ticks.  Works like R graphics grid() but the grid lines are are solid and gray and minor ticks are produced by default.
}
\usage{
Grid(nx = NULL, ny = nx, col = gray(0.9), lty = 1, lwd = par("lwd"), equilogs = TRUE, 
     minor = TRUE, nxm = 2, nym = 2, tick.ratio = 0.5, ...)
}
\arguments{
  \item{nx, ny}{
number of cells of the grid in x and y direction. When NULL, as per default, the grid aligns with the tick marks on the corresponding default axis (i.e., tickmarks as computed by axTicks).  When NA, no grid lines are drawn in the corresponding direction.
}
  \item{col}{
color of the grid lines.
}
  \item{lty}{
 line type of the grid lines.
}
  \item{lwd}{
 line width of the grid lines.
}
  \item{equilogs}{
logical, only used when log coordinates and alignment with the axis tick marks are active.  Setting equilogs = FALSE in that case gives non equidistant tick aligned grid lines.
}
  \item{minor}{
logical with TRUE (default) adding minor ticks.
}
  \item{nxm, nym}{
number of intervals in which to divide the area between major tick marks on the x-axis (y-axis). If minor=TRUE, should be > 1 or no minor ticks will be drawn. 
}
  \item{tick.ratio}{
ratio of lengths of minor tick marks to major tick marks. The length of major tick marks is retrieved from par("tck").
}
 \item{\dots}{
other graphical parameters; 
}
}
\details{
I combined the code for \code{grid()} in the graphics package and \code{minor.tick()} from the Hmisc package, and changed the default grid line type and color.     
}
\references{
The code for \code{grid()} in R graphics and \code{minor.tick()} from the Hmisc package were combined.
}
\author{
D.S. Stoffer
}
\seealso{
\code{\link{grid}}
}

