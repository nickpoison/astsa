\name{astsa.col}
\alias{astsa.col}
\title{
astsa color palette with transparency
}
\description{
Modifies the opacity level of the astsa color palette.
}
\usage{
astsa.col(alpha = 1)
}
\arguments{
  \item{alpha}{
factor in [0,1] setting the opacity (default is 1) 
}
}
\value{
a color vector of length 8 with the astsa color palette at the chosen transparency level 
}
\note{The astsa color palette is attached when the package is attached. 
The colors follow the R pattern of shades of: (1) black, (2) red, (3) green, (4) blue, 
(5) cyan, (6) magenta, (7) gold, (8) gray.  The opacity of these colors can be
changed easily using this script.


The astsa palette was developed from two basic ideas.  The first is the general idea that
time series should be plotted using dark colors. The second is personal in that we
prefer to anchor plots with  the best blue,  \kbd{dodgerblue3}. 
From there, we used the website \kbd{https://www.color-hex.com/} to pick colors of type 2 to 7
that complement \kbd{dodgerblue3}.
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}
}
\author{
D.S.Stoffer
}
\examples{
# View the astsa palette
par(mfrow=c(3,1))
barplot(rep(1,8), col=1:8, main='astsa palette', names=1:8)
barplot(rep(1,8), col=astsa.col(.7), main='transparency', names=1:8)
barplot(rep(1,8), col=astsa.col(.5)[3:6], main='pastelity', names=rep(3:6,2))


# plotting 2 series that touch (but in a nice way)
tsplot(cbind(gtemp_land, gtemp_ocean), col=astsa.col(.6)[c(4,2)], lwd=2, spaghetti=TRUE, 
         type='o', pch=20, ylab="Temperature Deviations")
legend('topleft', legend=c("Land Only", "Ocean Only"), col=c(4,2), lwd=2, pch=20, bty='n')  




}
\keyword{ color }
