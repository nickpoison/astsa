\name{astsa.col}
\alias{astsa.col}
\title{
astsa color palette with transparency or a color wheel
} 
\description{
The script does one of two things.
[1] Easily modify the opacity level of the astsa colors.
[2] Create a color wheel of a chosen number of colors from a base color.
}
\usage{
astsa.col(col=1, alpha=1, wheel=FALSE, pie=FALSE, num)
}
\arguments{
  \item{col}{
[1] a numerical vector representing the colors to change transparency level or
[2] a color used as a base (if a vector, the first color is chosen) 
- see Examples
}  
  \item{alpha}{
factor in [0, 1] setting the opacity of all colors. Smaller values are more transparent. 
}
  \item{wheel}{
if TRUE, produces a color wheel of \code{num} colors from a base color. 
}
  \item{pie}{
if TRUE, produces a pie chart of the chosen colors 
}
  \item{num}{
an integer specifying the number of desired colors in the wheel.  If missing, the user is 
prompted to enter a number
}
}
\value{
[1] a \emph{color vector} using the astsa color palette at the chosen transparency level
- OR -
[2] a \emph{color wheel} of a chosen number \code{num} of colors from a base color
}
\note{The astsa color palette is attached when the package is attached. 
The colors follow the R pattern of shades of: (1) black, (2) red, (3) green, (4) blue, 
(5) cyan, (6) magenta, (7) gold, (8) gray.  The opacity of these colors can be
changed easily using this script.  Values are recycled, e.g., \code{col=9} is
the same as \code{col=1}.

Additionally, a color wheel can be generated by specifying a base color and inputting 
the number of desired colors.  A pie chart can be displayed to help in choosing
the desired color scheme.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\author{
D.S.Stoffer
}
\examples{

# View the astsa palette
astsa.col(1:8, pie=TRUE)
legend('topright', legend=astsa.col(1:8), fill=1:8, title='Hex Color Code')

# plotting 2 series that touch (but in a nice way)
tsplot(cbind(gtemp_land, gtemp_ocean), col=astsa.col(c(4,2), .5), lwd=2, spaghetti=TRUE, 
     type='o', pch=20, ylab="Temperature Deviations", addLegend=TRUE, location='topleft',
     legend=c("Land Only", "Ocean Only"), gg=TRUE)  

# Wheel of fortune
astsa.col(4, wheel=TRUE, num=8, pie=TRUE)

# Solve the puzzle
x = replicate(6, sarima.sim(ar=c(1.5,-.75), n=120))
tsplot(x, spag=TRUE, col=astsa.col(4, alpha=.7, wheel=TRUE, num=6), lwd=12)

}
\keyword{ color }
