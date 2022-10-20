\name{tsplot}
\alias{tsplot}
\title{Time Series Plot
}
\description{
Produces a nice plot of univariate or multiple time series in one easy line.
}
\usage{
tsplot(x, y=NULL, main=NULL, ylab=NULL, xlab='Time', type=NULL,
        margins=.25, ncolm=1, byrow=TRUE, minor=TRUE, nxm=2, nym=1,
        xm.grid=TRUE, ym.grid =TRUE, col=1, gg=FALSE, spaghetti=FALSE,
        pch=NULL, lty=1, lwd=1, mgpp=0, ...)
}
\arguments{
  \item{x, y}{
time series to be plotted; if both present, x will be the time index.
}
  \item{main}{
add a plot title - the default is no title.
}
  \item{ylab}{
y-axis label - the default is the name of the ts object.
}
  \item{xlab}{
x-axis label - the default is 'Time'.
}
  \item{type}{
type of plot - the default is line.
}
  \item{margins}{
inches to add (or subtract) to the margins. Input one value to apply to all margins or a vector of length 4 to add (or subtract) to the (bottom, left, top, right) margins.
}
 \item{ncolm}{
for multiple time series, the number of columns to plot.
}
 \item{byrow}{
for multiple time series - if TRUE (default), plot series row wise; if FALSE, plot series column wise.
}
  \item{minor, nxm, nym}{
if minor=TRUE, the number of minor tick marks on x-axis, y-axis.  minor=FALSE removes both or set either to 0 or 1 to remove.
The default is one minor tick on the x-axis and none on the y-axis.
}
  \item{xm.grid, ym.grid}{
if TRUE (default), adds grid lines at minor x-axis, y-axis ticks.
}
 \item{col}{
line color(s), can be a vector for multiple time series.
}
 \item{gg}{
if TRUE, will produce a gris-gris plot (gray graphic interior with white grid lines); the default is FALSE.
The grammar of astsa is voodoo; \cr
 see \kbd{https://musicaficionado.blog/2017/11/08/gris-gris-by-dr-john/}
}
  \item{spaghetti}{
if TRUE, will produce a spaghetti plot (all series on same plot).
}
 \item{pch}{
plot symbols (default is 1, circle); can be a vector for multiple plots.
}
 \item{lty}{
line type (default is 1, solid line); can be a vector for multiple plots.
}
 \item{lwd}{
line width (default is 1); can be a vector for multiple plots.
}
 \item{mgpp}{
this is used to adjust (add to) the \code{mgp} graphics parameters settings (\code{?par}), which are \code{c(1.6,.6,0)} here; the R default is \code{c(3,1,0)}.  This will be helpful in moving an axis label farther from the axis if necessary.  
}
  \item{\dots}{
other graphical parameteres; see \link[graphics]{par}.
}
}
\value{
Produces a graphic and returns it invisibly so it can be saved in an R variable with the ability to replay it;
see \code{\link{recordPlot}}.
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\author{
D.S. Stoffer
}
\examples{
\dontrun{

# minimal
tsplot(soi)
# prettified
tsplot(soi, col=4, main="Southern Oscillation Index")

# compare these
par(mfrow=2:1)
tsplot(1:453, soi, ylab='SOI', xlab='Month')
# now recklessly add to the margins and add to mgp to get to the default
tsplot(1:453, soi, ylab='SOI', xlab='Month', margins=c(2,3,4,5), las=1, mgpp=c(1.4,.4,0))

# gris-gris multiple plot 
tsplot(climhyd, ncolm=2, gg=TRUE, col=2:7, lwd=2)  

# spaghetti (and store it in an object - ?recordPlot for details)
x <- replicate(100, cumsum(rcauchy(1000))/1:1000)
u <- tsplot(x, col=1:8, main='No LLN For You', spaghetti=TRUE)
u   #  plot on demand
}
}
\keyword{ ts }