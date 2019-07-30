\name{Kfilter0}
\alias{Kfilter0}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Kalman Filter - Time Invariant Model 
%%  ~~function to do ... ~~
}
\description{Returns the filtered values for the basic time invariant state-space model; inputs are not allowed.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Kfilter0(num, y, A, mu0, Sigma0, Phi, cQ, cR)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{num}{number of observations
%%     ~~Describe \code{num} here~~
}
  \item{y}{data matrix, vector or time series
%%     ~~Describe \code{y} here~~
}
  \item{A}{time-invariant observation matrix
%%     ~~Describe \code{A} here~~
}
  \item{mu0}{initial state mean vector
%%     ~~Describe \code{mu0} here~~
}
  \item{Sigma0}{initial state covariance matrix
%%     ~~Describe \code{Sigma0} here~~
}
  \item{Phi}{state transition matrix
%%     ~~Describe \code{Phi} here~~
}
  \item{cQ}{Cholesky-type decomposition of state error covariance matrix Q -- see details below
%%     ~~Describe \code{cQ} here~~
}
  \item{cR}{Cholesky-type decomposition of observation error covariance matrix R -- see details below
%%     ~~Describe \code{cR} here~~
}
}
\details{Practically, the script only requires that Q or R may be reconstructed as \code{t(cQ)\%*\%(cQ)} or \code{t(cR)\%*\%(cR)}, respectively.
%%  ~~ If necessary, more details than the description above ~~
}
\value{
\item{xp }{one-step-ahead state prediction}
\item{Pp }{mean square prediction error}
\item{xf }{filter value of the state}
\item{Pf }{mean square filter error}
\item{like }{the negative of the log likelihood}
\item{innov }{innovation series}
\item{sig }{innovation covariances}
\item{Kn }{last value of the gain, needed for smoothing}
}
\references{\url{http://www.stat.pitt.edu/stoffer/tsa4/}\cr

See also \url{http://www.stat.pitt.edu/stoffer/tsa4/chap6.htm} for an explanation of the difference between levels 0, 1, and 2.
%% ~put references to the literature/web site here ~
}
\author{D.S. Stoffer
%%  ~~who you are~~
}
%\note{
%%  ~~further notes~~
%}
\keyword{ ts }
%%  %\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
%%  