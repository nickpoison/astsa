\name{SV.mle}
\alias{SV.mle}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SV.mle(returns, phi1 = 0.95, sQ = 0.1, alpha = NULL, sR0 = 1, mu1 = -3, sR1 = 2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{returns}{
%%     ~~Describe \code{returns} here~~
}
  \item{phi1}{
%%     ~~Describe \code{phi1} here~~
}
  \item{sQ}{
%%     ~~Describe \code{sQ} here~~
}
  \item{alpha}{
%%     ~~Describe \code{alpha} here~~
}
  \item{sR0}{
%%     ~~Describe \code{sR0} here~~
}
  \item{mu1}{
%%     ~~Describe \code{mu1} here~~
}
  \item{sR1}{
%%     ~~Describe \code{sR1} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (returns, phi1 = 0.95, sQ = 0.1, alpha = NULL, sR0 = 1, 
    mu1 = -3, sR1 = 2) 
{
    if (any(returns < 10^-8)) 
        returns = jitter(returns)
    y = log(returns^2)
    num = length(y)
    if (is.null(alpha)) 
        alpha = mean(y)
    init.par = c(phi1, sQ, alpha, sR0, mu1, sR1)
    pb = txtProgressBar(min = 0, max = 100, initial = 0, style = 2, 
        char = " ")
    k = 0
    Linn = function(para) {
        phi1 = para[1]
        sQ = para[2]
        alpha = para[3]
        sR0 = para[4]
        mu1 = para[5]
        sR1 = para[6]
        sv = SVfilter(num, y, phi0 = 0, phi1, sQ, alpha, sR0, 
            mu1, sR1)
        k = k + 1
        setTxtProgressBar(pb, k)
        return(sv$like)
    }
    (est = optim(init.par, Linn, NULL, method = "BFGS", hessian = TRUE, 
        control = list(trace = 1, REPORT = 5)))
    close(pb)
    SE = sqrt(diag(solve(est$hessian)))
    u = cbind(estimates = est$par, SE)
    rownames(u) = c("phi1", "sQ", "alpha", "sigv0", "mu1", "sigv1")
    cat("<><><><><><><><><><><><><><>")
    cat("\n", "\n")
    cat("Coefficients:", "\n")
    print(round(u, 4))
    cat("\n")
    phi0 = 0
    phi1 = est$par[1]
    sQ = est$par[2]
    alpha = est$par[3]
    sR0 = est$par[4]
    mu1 = est$par[5]
    sR1 = est$par[6]
    sv = SVfilter(num, y, phi0, phi1, sQ, alpha, sR0, mu1, sR1)
    layout(matrix(1:2, 2), height = c(3, 2))
    tapp = tsp(y)
    tsxp = ts(sv$xp, start = tapp[1], frequency = tapp[3])
    tsPp = ts(sv$Pp, start = tapp[1], frequency = tapp[3])
    Low = min(10 * returns, tsxp - 2 * sqrt(tsPp))
    Upp = max(10 * returns, tsxp + 2 * sqrt(tsPp))
    tsplot(cbind(10 * returns, tsxp), col = c(astsa.col(2, 0.4), 
        4), spag = TRUE, ylim = c(Low, Upp))
    xx = c(time(y), rev(time(y)))
    yy = c(tsxp - 2 * sqrt(tsPp), rev(tsxp + 2 * sqrt(tsPp)))
    polygon(xx, yy, border = NA, col = astsa.col(4, alpha = 0.2))
    legend("topright", legend = c("log-volatility", "Returns (× 10)"), 
        lty = 1, col = c(4, astsa.col(2, 0.6)), bty = "n")
    x = seq(-15, 6, by = 0.01)
    f = exp(-0.5 * (exp(x) - x))/(sqrt(2 * pi))
    f0 = exp(-0.5 * (x^2)/sR0^2)/(sR0 * sqrt(2 * pi))
    f1 = exp(-0.5 * (x - mu1)^2/sR1^2)/(sR1 * sqrt(2 * pi))
    fm = 0.5 * f0 + 0.5 * f1
    tsplot(x, f, ylab = "density", col = 4)
    lines(x, fm, lty = 5, lwd = 2, col = 5)
    cs = expression(log ~ chi[1]^2)
    legend("topleft", legend = c(cs, "normal mixture"), lty = c(1, 
        5), lwd = 1:2, col = 4)
    invisible(cbind(PredLogVol = tsxp, RMSPE = sqrt(tsPp)))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
