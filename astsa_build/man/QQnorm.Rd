\name{QQnorm}
\alias{QQnorm}
\title{
Normal Quantile-Quantile Plot
}
\description{
Produces a normal QQ plot with a line of equality and a confidence band (by default) of the input data. This is basically a prettier version of \code{qqnorm} from the \code{stats} package. 
}
\usage{
QQnorm(xdata, col = c(4, 6), ylab = "Sample Quantiles", xlab = "Theoretical Quantiles", 
        main = "Normal Q-Q Plot", ylim = NULL, ci = TRUE, qqlwd = 1, ...)
}
\arguments{
  \item{xdata}{
the data. If a matrix, the data are collapsed.
}
  \item{col}{
vector of 2, first is point color, second is line color (default is blue-4 and magenta-6).
}
  \item{ylab}{
y-axis label (default is 'Sample Quantiles').
}
  \item{xlab}{
x-axis label (default is 'Theoretical Quantiles').
}
  \item{main}{
plot title (default is 'Normal Q-Q Plot')
}
  \item{ylim}{
limits on y-axis (default is the most beautiful limits ever).
}
  \item{ci}{
if TRUE (default) draws pointwise 99.99\% CIs as a band.
If FALSE or 0, no CI is drawn. Alternately, enter a percentage
(e.g., either \code{ci=95} or \code{ci=.95} will work).
}
  \item{qqlwd}{
line width of the qqline (default is 1).
}
  \item{\dots}{
other graphical parameters sent to \code{\link{tsplot}}.
}
}
\details{
If you want a graphic to check normality of your data in \code{xdata}, just enter \code{QQnorm(xdata)} and sit back and enjoy the beauty of this script (you may want to wear sunglasses).

For confidence levels, various values are allowed. For example, 95\% limits can be obtained as \code{ci=95} or \code{ci=.95}, both of which are conventional. However, \code{ci=5}, or \code{ci=.05} will also work for 95\% intervals (so you can not go below 50\%). If you ask for a confidence level of 100\% or larger, you will get the default without a warning and maybe you are unconventional.
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

QQnorm(log(varve))

}
\keyword{hplot}
\keyword{distribution}

