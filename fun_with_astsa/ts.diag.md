Diagnostic Plots for Time Series
--------------------------------

### Description

Diagnostic plots of the residuals from a time series fit.

### Usage

    ts.diag(resids, col = 1, fitdf = 0, nlag = 20, ...)
    

### Arguments

`resids` 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; residuals from a time series fit (univariate only)

`col`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; color used in the plots (default is black)

`fitdf`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; number of degrees of freedom to be subtracted for the portmanteau goodness-of-fit test

`nlag`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; the maximum number of lags for a portmanteau goodness-of-fit test (unless it is small relative to `fitdf`)

`...`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; additional graphical arguments

### Details

This is essentially the diagnostic plot from `sarima` that can be used for other types of model fitting aside from ARMA. This is not needed for ARMA models because `sarima` includes this diagnostic of the residuals from the fit (unless it has been shut off).

The script may be used for a generic residual analysis or to check if a series is white noise. In this case, it may be necessary to specify `fitdf` to get the correct degrees of freedom such as in fitting a state space model.

### Value

A graphic is produced showing a plot of the residuals, the sample ACF, a normal QQ plot, and and the p-values of a portmanteau test for all lags up to `nlag`.

### Author(s)

D.S. Stoffer

### References

You can find demonstrations of astsa capabilities at [FUN WITH ASTSA](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md).

The most recent version of the package can be found at [https://github.com/nickpoison/astsa/](https://github.com/nickpoison/astsa/).

In addition, the News and ChangeLog files are at [https://github.com/nickpoison/astsa/blob/master/NEWS.md](https://github.com/nickpoison/astsa/blob/master/NEWS.md).

The webpages for the texts and some help on using R for time series analysis can be found at [https://nickpoison.github.io/](https://nickpoison.github.io/).

### See Also

[`sarima`](https://cran.r-project.org/web/packages/astsa/refman/astsa.html#sarima)

### Examples

[Run examples](../Example/ts.diag)

    
    # fit state space model to global temps
    u = ssm(gtemp_both, A=1, alpha=0, phi=1, sigw=.05, sigv=.15)
    
    # get resids (obs - pred)
    resids = gtemp_both - u$Xp
    
    # check fit [the model is essentially an explosive ARMA(1,1)]
    ts.diag(resids, fitdf=2, col=4, gg=TRUE)
    
    

* * *

\[ Package _astsa_ version 2.5.1  \]