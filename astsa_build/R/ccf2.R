ccf2 <-  
function (x, y, max.lag = NULL, main = NULL, ylab = "CCF", plot = TRUE,
          na.action = na.pass, type = c("correlation", "covariance"), ...)
{
  par = graphics::par
  acf = stats::acf
  abline = graphics::abline
  frequency = stats::frequency
  ts.intersect = stats::ts.intersect
  as.ts = stats::as.ts
  lag.max = max.lag
  type =  match.arg(type)
  if (is.matrix(x) || is.matrix(y)) { stop("univariate time series only") }
  X <- ts.intersect(as.ts(x), as.ts(y))
  num = nrow(X)
  if (num > 49 & is.null(lag.max))  lag.max= max(ceiling(10+sqrt(num)), 3*frequency(X))
  if (num < 50 & is.null(lag.max))  lag.max=floor(5*log10(num))
  if (lag.max > (num-1)) lag.max=floor(5*log10(num))
  colnames(X) <- c(deparse(substitute(x))[1L], deparse(substitute(y))[1L])
  acf.out <- acf(X, lag.max = lag.max, plot = FALSE, type =  type, na.action = na.action)
  lag <- c(rev(acf.out$lag[-1, 2, 1]), acf.out$lag[, 1, 2])
  y <- c(rev(acf.out$acf[-1, 2, 1]), acf.out$acf[, 1, 2])
  acf.out$CCF <- array(y, dim = c(length(y), 1L, 1L))
  acf.out$LAG <- array(lag, dim = c(length(y), 1L, 1L))
  acf.out$snames <- paste(acf.out$snames, collapse = " & ") 
  if (is.null(main)){main=acf.out$snames}
  #  better graphic
  if (plot){ 
   xfreq = frequency(X)  
   Xlab = ifelse(xfreq>1, paste('LAG \u00F7', xfreq), 'LAG')
    U = 2/sqrt(num)
    tsplot(acf.out$LAG, acf.out$CCF, type='h', ylab=ylab, xlab=Xlab, main=main, ...) 
    if (type == "correlation") { abline(h=c(0,-U,U), lty=c(1,2,2), col=c(8,4,4))
    } else { abline(h=0, col=8)
    }
    abline(v=0, lty=2, col=astsa.col(8,.6))
    LAG = -lag.max:lag.max
    CCF = round(acf.out$CCF,3)
    return(invisible(cbind(LAG, CCF)))
  } else {
  return(cbind(LAG=-lag.max:lag.max, CCF=acf.out$CCF)) 
  }
}        