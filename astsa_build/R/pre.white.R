pre.white = function(series1, series2, diff=FALSE, max.lag=NULL, main=NULL, 
                      order.max=NULL, plot=TRUE, ...){

 if ( NCOL(series1) > 1 | NCOL(series2) > 1 ) stop('univariate series only')

 nam1 = paste(deparse(substitute(series1)), '.w', sep='')
 nam2 = paste(deparse(substitute(series2)), '.f', sep='')

 if (diff > 0) {    # diff can be a number also 
      series1 = diff(series1, differences=diff)
      series2 = diff(series2, differences=diff)
 } 

 if (is.null(order.max)) order.max = min(30, ceiling(.15*length(series1)))
 if (is.null(max.lag)) max.lag = min(50, floor(.2*length(series1))) 

 u = ar(series1, aic=TRUE, order.max=order.max)
 x1 = u$resid
 x2 = stats::filter(series2, filter=c(1, -u$ar), sides=1)

 both = ts.intersect(as.ts(x1), as.ts(x2))   # line them up

 if (is.null(main)) main=paste(nam1, " & ", nam2)

 if (plot) ccf2(both[,1], both[,2], max.lag=max.lag, main=main, ...)

 invisible(both)
}
