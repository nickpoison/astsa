\name{astsa.col}
\alias{astsa.col}
\title{
astsa color palette with transparency
}
\description{
Modifies the opacity level of the astsa color palette.
}
\usage{
astsa.col(col = 1, alpha = 1)
}
\arguments{
  \item{col}{numerical vector representing colors (default is 1 or 'black') 
             - see Examples
}  
  \item{alpha}{
factor in [0,1] setting the opacity (default is 1) 
}
}
\value{
a color vector using the astsa color palette at the chosen transparency level 
}
\note{The astsa color palette is attached when the package is attached. 
The colors follow the R pattern of shades of: (1) black, (2) red, (3) green, (4) blue, 
(5) cyan, (6) magenta, (7) gold, (8) gray.  The opacity of these colors can be
changed easily using this script.  Values are recycled, e.g., \code{col=9} is
the same as \code{col=1}.


The astsa palette was developed from two basic ideas.  The first is the general idea that
time series should be plotted using dark colors. The second is personal in that we
prefer to anchor plots with  the best blue,  \kbd{dodgerblue3}. 
From there, we used the website \kbd{https://www.color-hex.com/} to pick colors of type 2 to 7
that complement \kbd{dodgerblue3}.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts are \url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}.  
}
\author{
D.S.Stoffer
}
\examples{
# View the astsa palette
par(mfrow=c(3,1))
barplot(rep(1,8), col=1:8, main='astsa palette', names=1:8)
barplot(rep(1,8), col=astsa.col(1:8, .7), main='transparency', names=1:8)
barplot(rep(1,8), col=astsa.col(3:6, .5), main='pastelity', names=rep(3:6, 2))


# plotting 2 series that touch (but in a nice way)
tsplot(cbind(gtemp_land, gtemp_ocean), col=astsa.col(c(4,2), .5), lwd=2, spaghetti=TRUE, 
         type='o', pch=20, ylab="Temperature Deviations")
legend('topleft', legend=c("Land Only", "Ocean Only"), col=c(4,2), lwd=2, pch=20, bty='n')  
}
\keyword{ color }
