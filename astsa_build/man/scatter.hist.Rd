\name{scatter.hist}
\alias{scatter.hist}
\title{
Scatterplot with Marginal Histograms
} 
\description{
Draws a scatterplot with histograms in the margins.
}
\usage{
scatter.hist(x, y, xlab = NULL, ylab = NULL, title = NULL, pt.size = 1, 
              hist.col = gray(0.82), pt.col = gray(0.1, 0.25), pch = 19, 
              reset.par = TRUE, ...)
}
\arguments{
  \item{x}{
vector of x-values
}
  \item{y}{
corresponding vector of y-values
}
  \item{xlab}{
x-axis label (defaults to name of x)
}
  \item{ylab}{
y-axis label (defaults to name of y)
} 
  \item{title}{
plot title (optional)
}
  \item{pt.size}{
size of points in scatterplot
}
  \item{hist.col}{
color for histograms
}
  \item{pt.col}{
color of points in scatterplot
}
  \item{pch}{
scatterplot point character
}
  \item{reset.par}{
reset graphics - default is TRUE; set to FALSE to add on to scatterplot
}
  \item{\dots}{
addtional graphical parameters sent to \code{Grid}
}
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.   
}
\author{D.S. Stoffer
}
\examples{
scatter.hist(tempr, cmort, hist.col=astsa.col(5,.4), pt.col=5, pt.size=1.5, reset=FALSE)
lines(lowess(tempr, cmort), col=6)


scatter.hist(diff(log(econ5[,'gnp'])), diff(log(econ5[,'unemp'])), nxm=5, pt.size=2, 
    col=astsa.col(6,.1), pt.col=astsa.col(4, alpha=.6, wheel=TRUE, num=25), hist='green3')

}
 
