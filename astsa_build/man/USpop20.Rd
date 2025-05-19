\name{USpop20}
\alias{USpop20}
\docType{data}
\title{
U.S. Population - 1900 to 2020
}
\description{
U.S. Population by official census, every ten years from 1900 to 2020, in millions.
}
\format{
The format is:
Time-Series [1:13] from 1900 to 2020: 76.2 92.2 106 122.8 132.2 ...
}
\details{
The census from 2020 is included in this data set, but the results from 2020 are questionable. By many accounts, it was a nightmare (\kbd{https://www.npr.org/2022/01/15/1073338121/2020-census-interference-trump}) due to the COVID-19 pandemic coupled with the fact that the Census Bureau is in the Department of Commerce, and its head is appointed by and reports directly to the POTUS, who at the time was DJ tRump: "Historians rank Trump among worst presidents in US history ... " (\kbd{https://www.businessinsider.com/historians-rank-trump-among-worst-presidents-us-history-c-span-2021-6}).  

The data without the 2020 census is in \code{\link{USpop}}.  Note that the two data files differ a bit, presumably because they are revised ad infinitum.  Both data sets were obtained from the Census Bureau's website. 
}
\source{
\kbd{https://www.census.gov/}
}
\references{You can find demonstrations of  astsa capabilities at
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}. 
}
\examples{
\dontrun{

# This is from the 2nd edition of Time Series: A Data Analysis Approach ...
t   = time(USpop20) - 1960
reg = lm( USpop20~ poly(t, 10, raw=TRUE) )
b   = as.vector(coef(reg))
g   = function(s){b[1] + b[2]*s + b[3]*s^2 + b[4]*s^3 + b[5]*s^4 + b[6]*s^5 + b[7]*s^6 + 
                   b[8]*s^7 + b[9]*s^8 +b[10]*s^9 + b[11]*s^10 }
t   = 1900:2044
tsplot(t, g(t-1960), ylab="Population", xlab='Year',cex.main=1, col=4,
        main="U.S. Population by Official Census")
points(time(USpop20), USpop20, pch=21, bg=rainbow(13), cex=1.25)
mtext(bquote('\u00D7'~10^6), side=2, line=1.5, adj=1, cex=.8)
}
}
\seealso{\code{\link{USpop}} }
\keyword{datasets}
