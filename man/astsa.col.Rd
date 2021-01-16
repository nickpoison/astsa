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
\note{\code{palette(astsa.col(1))} is loaded with astsa
}
\references{\url{https://www.stat.pitt.edu/stoffer/tsa4/} and \url{https://www.stat.pitt.edu/stoffer/tsda/}
}
\author{
D.S.Stoffer
}
\examples{
par(mfrow=c(1,3))
pie(rep(1,8), col=1:8, main='astsa palette')
pie(rep(1,8), col=astsa.col(.7), main='transparency')
pie(rep(1,9), col=astsa.col(.5)[2:4], main='redundancy', labels=rep(c('2','3','4'),3))


# plotting 2 series that touch (in a nice way)
palette(astsa.col(.6))
tsplot(cbind(gtemp_land, gtemp_ocean), col=c(4,2), lwd=2, spaghetti=TRUE, type='o', pch=20, ylab="Global Temperature Deviations")
palette(astsa.col(1))  # reset to original palette
legend('topleft', legend=c("Land Only", "Ocean Only"), col=c(4,2), lwd=2, pch=20, bty='n')  




}
\keyword{ color }
