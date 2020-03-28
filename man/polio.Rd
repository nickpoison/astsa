\name{polio}
\alias{polio}
\docType{data}
\title{
Poliomyelitis cases in US 
}
\description{
Poliomyelitis cases reported to the U.S. Centers for Disease Control for the years 1970 to 1983, that is, 168 observations. }
\usage{data(polio)}
\format{
  The format is:
 Time-Series [1:168] from 1970 to 1984: 0 1 0 0 1 3 9 2 3 5 ...
}
\details{
The data were originally modelled by Zeger (1988) who used a parameter driven approach, in which a first order autoregressive model was used for the latent process, to conclude that there is evidence of a decrease in the polio infection rate.    The data were analysed also by  Li (1994),  Zeger and Qaqish (1988), Davis et al. (1999), and by Benjamin et al (2003). 
}
\source{
Zeger (1988) 
}
\references{

Benjamin M. A., Rigby R. A. and Stasinopoulos D.M. (2003) Generalised Autoregressive Moving  Average Models.  \emph{J. Am. Statist. Ass.}, 98, 214-223.

Davis, R. A., Dunsmuir, W. T. M. and Wang, Y. (1999), ``Modelling
Time Series of Count Data,'' \emph{in Asymptotics, Nonparametrics
and Time Series (ed Subir Ghosh)}: Marcel Dekker

Zeger, S. L. (1988), ``A Regression Model for Time Series of
Counts,'' \emph{Biometrika}, 75, 822-835.

Zeger, S. L. and Qaqish, B.  (1988), ``Markov Regression Models
for Time Series: A Quasi-likelihood Approach,'' \emph{Biometrics},
44, 1019-1032.

}
\examples{
tsplot(polio, type='s')
}
\keyword{datasets}
