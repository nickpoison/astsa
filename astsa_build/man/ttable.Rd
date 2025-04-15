\name{ttable}
\alias{ttable}
\title{
t-table summary for an \code{lm} object
}
\description{
Works like \code{summary} for an \code{lm} object but adds AIC, AICc, and BIC to the output with the option to display VIF.
}
\usage{
ttable(obj, digits = 4, vif = FALSE, ...)
}
\arguments{
  \item{obj}{an object of class "lm" as a result of a call to \code{\link{lm}}.
}
  \item{digits}{
the (approximate) number of significant digits to use when printing. 
}
  \item{vif}{
if TRUE, variance inflation factors are printed if applicable; default is FALSE.
}
  \item{\dots}{
further arguments passed to or from other methods.
}
}
\details{
Produces a t-table for an \code{lm} object much like \code{\link{print.summary.lm}} 
with added information including AIC, AICc, BIC, and VIF (if requested and if applicable), to the output. 
The output is rounded and there are no significance stars. In fact, there are no stars at all.
}
\value{
Prints a typical t-table with additional information as mentioned in the details.
Also silently returns the same values as described in \code{\link{summary.lm}}.
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
\source{
Built from \code{print.summary.lm}, \code{AIC}, and \code{BIC}, from the "stats" package,
and \code{vif.default} from the "cars" package.
}
\seealso{
\code{\link{summary.lm}}, \code{\link{print.summary.lm}}, \code{\link{lm}}
}
\examples{

fit1 = lm(cmort~ time(cmort) + tempr + I(tempr^2))
ttable(fit1, vif=TRUE)
# if you center `tempr`, the squared term doesn't change
temp = tempr - mean(tempr)
fit2 = lm(cmort~ time(cmort) + temp + I(temp^2)) 
ttable(fit2, vif=TRUE)

}

\keyword{ print }

