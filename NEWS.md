
## This is the changelog for 

<img src="fun_with_astsa/figs/astsa.gif" alt="astsa"  height="100">

**more than just data ... it's a palindrome**  

... `astsa` is the R package to accompany  [Time Series Analysis and Its Applications: With R Examples](https://link.springer.com/book/9783031705830)  and  [Time Series A Data Analysis Approach using R](https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9781041031642).

 &#128038; _Right now,  the 2 versions (GitHub and CRAN) are NOT  the same._

[![](https://www.r-pkg.org/badges/version/astsa)](https://www.r-pkg.org/badges/version/astsa) <sup>&#9664; current CRAN version</sup>&nbsp;&nbsp; ![](https://img.shields.io/badge/GitHub-2.4-ff69b4.svg?style=flat") <sup>&#9664; current GitHub version</sup>



---
&#x1F4A1; The GitHub version is updated before the CRAN version.  For installation, just follow the bouncing ball <sup>&#9917;</sup><sub>&#9917;</sub><sup>&#9917;</sup><sub>&#9917;</sub><sup>&#9917;</sup>: 

>  If `astsa` is loaded, then detach it first: `detach(package:astsa)`.  After successful installation, the best thing to do is to restart R and load the new `astsa`:

&#9917; Install the package `remotes`  and use this method:
```
install.packages("remotes")   # if you don't have the package already
remotes::install_github("nickpoison/astsa/astsa_build")
```

&#9917; Alternately, you can  install `astsa` from the archive  [astsa_2.4.tar.gz](https://github.com/nickpoison/astsa/blob/master/astsa_2.4.tar.gz). Download it (there's a download  &#8681;  button) and in R, use _Install package(s) from local files..._ from the Packages tab.  

&#9917; In Linux, I just do this: `sudo R CMD INSTALL -l /usr/lib/R/library astsa` but I think you can use `install.packages()` in R and just give the path to the `tar.gz` file.







---

&#128036; You can find a short guide to  `astsa` scripts right here at [**FUN WITH ASTSA**](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md) .

#### &#10024; Here is [A Road Map](https://nickpoison.github.io/) if you want a broad view of what is available. 

---
---

#### &#127514; Version 2.4 &ndash;  in the works (on GitHub only)

> We'll send this version to CRAN when the 2nd edition of [Time Series: A Data Analysis Approach ...](https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9781041031642) is published. The planned publication date is Jan/Feb 2026.


- added  &#127381;  `arma.check`  &#127381;  to check a given model (seasonal ok) for causality, invertibility, and parameter redundancy with option (`redundancy.tol`) to specify how close the inverse roots have to be to report a warning of parameter redundancy or over-parameterization (default is .1).

  - in `arma.spec`, using ideas from `arma.check`, added user option `redundancy.tol`.
  - redundancy is now reported in `sarima.sim` (it just reports it but it doesn't stop the script and the check can be turned off) ... previously, it only checked causality and invertibility.  

- removed asking if the user wants `xts` to be installed at startup ... _apologies_ for doing what we said we would never do - it's  why there is an update so soon 

- in the meantime,  added script &#127381;  `timex()`  &#127381; that, with or without `xts` being loaded, will convert the dates in an `xts` data file to decimal dates so the data can be plotted easily using `tsplot` ... `?timex` for details (of course)

- for `tsplot`, added logical option `reset.par`. For multiple plots, the graphic is reset by default (`TRUE`) unless this is set to `FALSE`.   For example, if there are 5 plots and `ncolm=2`, the layout will be 3 by 2 with an empty spot.  If you want to add something in the empty space, set this to `FALSE`, otherwise the graphic is finished.   

  - Also `las` (orientation of axis labels) is a user option for every kind of plot with the default being 0 - it used to be 1 for gris-gris plots by default.

  - And, for multiple series plots, added an individual `title` and `xlab` option, so these items can be a vectors. See the _missing data - try this with ggplot_ example in the `tsplot` man page.  This example is also going up on the graphics page eventually.

- `lag1.plot` and `lag2.plot` have additional arguments where you can change the name(s) of the series on the plots.  The defaults are the name of the series, but it can get messy if you do something like `lag1.plot(x <- diff(log(varve)), 4)`, so now you can do this: `lag1.plot(x <- diff(log(varve)), 4, xname='V')`.

- added &#127381; `MEI2` &#127381;, _Multivariate ENSO Index version 2_ (to complement `MEI`, which is version 1)

- we found it useful in Chapter 6 to get a nice residual analysis after fitting a state space model... so we added an option to specify `fitdf` in `sarima` to allow the user to keep track of the degrees of freedom. For example: `sarima(resids, fitdf=2)` will not fit a model to the `resids`, but will exhibit the residual analysis graphic... basically, `sarima` can be used as a residual diagnostic tool on its own.  

   - NOTE: you don't have to use `fitdf` when fitting ARMA models via `sarima` because that is taken care of automatically ... the argument works only if all orders are zero so that it's truly for an analysis of the residuals from another (i.e., not `sarima`) script  
<br/>


###  &#9654; v2.3 &ndash; Aug 2025 (on CRAN)) 

just in time for the new skool year ...       

-   not sure if this will stay, but if `xts` is not installed, the user is asked if they want to install it when `astsa` is loaded.  

- `lag1.plot` and `lag2.plot` now have an option to change the `location` of the correlation display.

- `astsa.col`  gets an expansion to include making a &#127381; color wheel  of arbitrary length... details in the help file (obviously).

- &#127381; `ttable`  is new (but it's not a time series thing) ... it works like `summmary` for an `lm` object but it's a little cleaner and includes AIC, AICc, and BIC.  There is also the option to get VIFs (if appropriate).

- &#127381; `tspairs` is new ... it's sort of `pairs` (scatterplot matrix) for time series... the diagonals can be a time plot or a histogram (default). Also, `ar.boot` and `ar.mcmc` now use `tspairs` instead of `pairs`. 

- `mvspec` can now handle coherency and phase plots in the multivariate (3 or more series) case without having to use `plot.spec` from the stats package.

- and after beautifying `mvspec`, the multivariate auto/cross- correlation matrix plot `acfm` is now more beautiful than ever.

- in `sarima` and `sarima.for`,  &#127381; the orders `p, d, q` _no longer have to be specified if they are zero_  ... so for example `sarima(x, p=2, q=1)` and `sarima.for(x, 10, p=2)`   will work now ... the original way still works: `sarima(x, 2,0,1)` and `sarima.for(x, 10, 2,0,0)`. Also, `sarima.for` now has an option to &#127381; change the color of the forecasts (default red) in the graphic.

    - in `sarima` residual diagnostics, the residual plot now has points if missing observations (otherwise, you can't see lone points)
    - also fixed `sarima.for` so the graphic works when there are missing observations (the plot failed because `ylim` had NAs). 


- `ar.boot` added more output ... the bootstrapped mean and noise variance values and the results of the initial estimation of the data.

- `QQnorm` argument change ... &#127381; the width of the CI is now controlled by `ci`, which can be `TRUE` (default width), `FALSE` (no CI band), or a percentage (e.g., `ci=99` or `ci=.99` both work the same)... and `width.ci` is gone.

- the correlation scripts `acf1` `acf2` `ccf2` and `acfm` no longer stop if the requested number of lags exceeds the number of observations ... now, the number of lags is reset to a small value and, without warning, a nonfatal electrical shock is sent to the keyboard.

- added &#127381; `USpop20` which is an update to `USpop` to include the 2020 census... it's used in the upcoming 2nd edition of _Time Series: A Data Analysis Approach..._ because it's not fun to forecast the past and time keeps on slippin' into the future.

- in `scatter.hist`, the &hellip; (optional settings) now work on the `Grid`  - like `scatter.hist(tempr, cmort, nxm=5)` adds more minor x-axis ticks/lines to the grid - other things still have their own setting  like point color and histogram color.

- in `ESS`, added an argument to control the number of `digits` printed by `round` (2 is now the default but -1, 0, or 1 might be better).

<br/>

---

####    Version 2.2 - Jan 2025 (on CRAN)  

- added `QQnorm` - a much nicer version of `qqnorm` from the `stats` package because the importance of appearance extends well beyond the pleasant experiences we have when we look at attractive plots. 
- `lag1.plot` and `lag2.plot` got little facelifts including increasing the character expansion (`cex`) a bit to prevent characters from getting too small.
- in `tsplot`,
    - if `spaghetti=TRUE`, added the ability to include a simple legend (so you don't have to use `legend`).   An example is in the help file.

    - added a multifigure scale factor so characters do not get too small - examples in the help file.  

- changed `sarima` so it works for tiny sample sizes (thought about including a "tiny" warning, but didn't ... maybe some other time) 
- added `pre.white` to do cross-correlation analysis with automatic prewhitening
- `arma.spec` gets better default title and `sarima.for` gets a `ylab` option.
- added `lap.xts` (an xts object), which contains the original daily observations from the LA Pollution-Mortality study.  How to easily get weekly averages is given in the examples section of the man page.
- for `trend`, if `results=TRUE` a summary of the regression (if used) results is printed  
- the scripts and data sets that were marked 'x' have been removed to [here](https://github.com/nickpoison/astsa/tree/master/xBox).
- `dna2vector` was updated (&#128545; due to change in a base R script) - previous versions might not work 
- in `mvspec` 

    - <s>set fxx to NULL in univariate case,</s> (reverted back) 
    - and in the call, if `demean=TRUE` (default is `FALSE`) `detrend` is set to `FALSE`,

    - and removed `taper` output from the graphic to the printout with bandwidth and df (if plot is TRUE and smoothing is used) and put them all on one line.
- added `gtemp.month` (monthly global data 1975-2023) -- rows are month, columns are year to make it easy to plot as monthly functional data

---


####   Version 2.1 - Jan 2024    

- added `SV.mle` to fit an SV model [with feedback (aka leverage) if desired] via quasi-MLE. Details are in the help file.  `SVfilter` is now part of `SV.mle` and the original script is now in the xBox as `xSVfilter`.

- `tsplot` becomes more kick-ass with full control of the `Grid`

- `sarima` - prettified the output 

- added `MEI` (Multivariate ENSO Index) data set 

- `SV.mcmc` moved ESS display to the ACFs 

- `test.linear` gets a title (`main`) control

- adjustment to `Kfilter(... , version=2)` - if the errors are _Q<sup>&half;</sup> w<sub>t</sub>_ and  _R<sup>&half;</sup>  v<sub>t</sub>_ then _S = cov(w<sub>t</sub>, v<sub>t</sub>)_, the _Q<sup>&half;</sup>_ and _R<sup>&half;</sup>_ are already included in the script.  Often in this case  _w<sub>t</sub> = v<sub>t</sub>_ and both are iid N(0, I) sequences, so `S = diag(1, q)`, the _q x q_ identity matrix.


- made `acf1` more flexible

- minor visual improvements to `SigExtract`

- increased the default max order and made detrend default on `spec.ic` 

- improvements to `mvspec` like allow detrending via lowess and some other visual improvements like a gris-gris option, enhancing the voodoo grammar of astsa

- updated `cardox` to 2023

- added `ar.boot` to get the bootstrapped distributions of the parameters of a specified (by the order) AR model.

-  added option in `trend` to plot (or not) the CIs - default is to plot (`ci=TRUE`).

- updated global temperature data sets and put all the old ones into the x box to be deleted (eventually) ... `gtemp_land`, `gtemp_ocean`, and `gtemp_both` are the updated/new sets

- updated `gnp` and `gdp` in sets `GNP` and `GDP`.

- added US population data (`USpop`) ... we thought it was in already, now it is 

####  Version 2.0 - Jan 2023  

 >  **Note**  There are a number of new scripts and some old ones are set to be retired eventually.  

- Added [`autoSpec`](https://dx.doi.org/10.4310/21-SII703) for changepoint detection using local nonparametric spectra.

    - Also added the data set `ENSO` which is the most recent update to SOI (an older version was used the paper that introduced autoSpec).  

    - The script uses the Bartlett kernel so it was made available for general use; see `bart`.

- Also added   [`autoParm`](https://doi.org/10.1198/016214505000000745) for changepoint detection using local AR models.

✄ &nbsp; Some examples are in  [FUN WITH ASTSA - structural breaks](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md#6-detecting-structural-breaks).

&#128312;&#128312;&#128312;&#128312;&#128312;

   - Added `Kfilter` and `Ksmooth` which are faster than the older `Kfilter0-1-2` and  `Ksmooth0-1-2`, are easier to work with, and removes the need for 3 different scripts.  

 

   - Added `EM` which supersedes `EM0` and `EM1` and uses the quicker `Kfilter` and `Ksmooth` scripts. **In addition, the script now accepts inputs in both the state and observations equations.** 


 > __Warning__  the old script names  `EM0-1`, `Kfilter0-1-2`, and `Ksmooth0-1-2` have an `x` in front of them now: `xEM0-1`, `xKfilter0-1-2`, and `xKsmooth0-1-2`.  The scripts haven't changed (old scripts will still work with the `x` name change), but they will be phased out eventually.  Converting code that used the old scripts to use the newer scripts should be easy with only a few minor changes in the call.  

&#128312;&#128312;&#128312;&#128312;&#128312;

   - Updated (to run with the new `Kfilter` and `Ksmooth` scripts): 
   
      + the Forward Filtering Backward Sampling script (`ffbs`) and 
      + the simple univariate state space model (`ssm`) script       

   - Updated data files `gtemp_land` and `gtemp_ocean` to 2021  

   - Made `lag1.plot` and `lag2.plot` look more purty. 

---



#### Version v1.16 - Sept 2022  

   - Added `Months` to use with `pch` for monthly data; see the help file `?Months`.
   
   - Tweaked `tsplot` by adding the ability to adjust the `mpg` graphics parameters settings (`?par`); see the help file `?tsplot`.

   - A `tsplot` plot  can now be stored by putting it in an object; e.g., `pl = tsplot(soi)`.  Later, entering `pl` will restore the graph and it's possible to add to it (made possible by `recordPlot`).

  - Added some Bayesian scripts (examples in [FUN WITH ASTSA](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md) - see the new section 9)
     - Added `ar.mcmc` to fit AR models via Gibbs sampling
     - Added `SV.mcmc` to fit stochastic volatility models 
     - ... and some financial data sets `sp500.gr` (S&P 500 daily returns) and `BCJ` (returns of 3 banks) 
     - Added `ffbs` (forward filter backward sample algorithm) for linear state space models
     - Added `ESS` to estimate the effective sample size 
     
    - Added a line to `detrend` to make sure the input series is univariate (already there in `trend`).  Also, in `trend`, forgot to add the span option for lowess (actually `stats::loess` with a robust option) - this has been corrected.  
    
    - Added the ability to change the legend text color in `lag1.plot` and `lag2.plot` and set the default to black - it makes the values easier to see, especially if the background of the legend is transparent.

    
---
#### Version 1.15 - May 2022

   + Added two new scripts `detrend()` and `trend()`.  The first one returns a detrended series using a polynomial regression (default is linear) or lowess (with the default span).  The second script fits a trend (same options as detrend) and produces a graphic of the series with the trend and error bounds superimposed.  The trend and error bounds are returned invisibly.

---
#### Version 1.14 - Sept 2021


   + Added sleep state and movement data (`sleep1` and `sleep2`) - more details in the help files. 

   + Added option to specify a kernel in `specenv` and if `spans` and `kernel` are both `NULL`, the spectral envelope will be based on the periodogram.  Also changed the way it checks if `section` is a proper sequence and added option to taper the data prior to estimating spectra.  

   + Some minor changes: 
   
     - In `matrixpwr` changed `isSymmetric(A)` to `isSymmetric(unname(A))`  because a symmetric matrix is not taken as such if the column and row names are not the same.  
     
     - In `arma.spec` if there is near parameter redundancy, `ylim` is now adjusted so the figure will be close to the white noise (uniform) density.


---
#### Version 1.13 - May 2021

+  Added `acfm` for multiple time series. Produces a matrix of plots of sample ACFs on the diagonal and sample CCFs on the off-diagonals. It's just a nicer version of `acf` for multiple time series. 

   + Also, changed the LAG axis labels on `acf1`, `acf2`, and `ccf2` to show the    frequency of the series if it's bigger than one.  For example, `soi` has    frequency 12 and the LAG axis of `acf1(soi)`  will be ticked as 1, 2, 3, ...    but the label now emphasizes that each tick is LAG divided by 12.

+  Some minor improvements  to `tsplot-spaghetti`, `sarima.sim`, `sarima`, and `arma.spec`.

    + For `sarima.sim`, I forgot to add the `innov` argument in the call (only a problem if you wanted to use your own innovations), but it seemed to work in the examples I tried (maybe it got passed in ...) ¿Quién sabe?   Or maybe it was just voodoo. 

    + Updated some man page (adding sources and subtracting typos).


---

#### Version 1.12 - started Dec 2020


+ Added `scatter.hist` to draw a scatterplot with marginal histograms - never really liked other versions.

+ Minor updates to `tsplot`, `SigExtract` and  `LagReg` to improve the displays.

+ Added scripts for the analysis of DNA sequences and other categorical time series: `specenv`, `dna2vector`, and the data set `EBV`.  And `specenv` can also handle real-valued series.

 - `dna2vector` is used to preprocess a categorical sequence.
   
- `EBV` is the entire Epstein-Barr sequence as a long single string. It's not useful on its own, but thru `dna2vector`, different regions can be explored via `specenv`.

+ We needed powers of matrices enough where we thought we'd include it in `astsa`.  The script is called `matrixpwr` and includes `%^%` as a more intuitive operator. For example, `var(econ5)%^%-.5` to calculate an inverse square root matrix.


+ Added `test.linear`, a script to test the null hypothesis that the data are generated from a linear process with iid innovations. 


+ Updated `Grid`, `tsplot`, `sarima.sim`, and `mvspec`. 

    - `Grid` and `tsplot` will produce grid lines at the minor ticks.  These can be shut off individually on either axis.  

   - For `sarima.sim`, now allow seasonal period without having to specify 
  other seasonal parameters - doing so gives a message to make sure you're doing it on purpose,  whereas it used to stop the execution.  There's an example of the advantage of this in its man page.
    
    - For `tsplot` and `mvspec`, by default now, there is one minor tick on the x-axis and none on the y-axis.  Also, `mvspec` doesn't display the bandwidth
on the axis - it's still there in the CI if the plot is on log-scale and it's still part of the "spec" object.

   - Also, updated `tsplot` so multiple series can have different plot symbols (`pch`), e.g., `tsplot(blood, type='o', col=2:4, pch=2:4, cex=2)`

+ Prettified  `arma.spec`, `lag1.plot`,  `lag2.plot`, `sarima`, and `sarima.for`, using the awesome power of `tsplot`, but no need to change existing code.

+ Updated `tsplot` to allow for spaghetti plots:<br/>
`x <- replicate(100, cumsum(rcauchy(1000))/1:1000)`<br/>
`tsplot(x, col=1:8, spaghetti=TRUE)`

+ The package now has its own color palette that is attached when the package is attached. The palette is  especially  suited for plotting  time series. It is a bit darker than the new default R4 palette. You can revert back using  `palette("default")`. 

  - In addition, added `astsa.col` script to easily adjust opacity of the astsa color palette - examples on its man page. 

+ Improvements to `acf1`, `acf2`, and `ccf2` employing the power of
`tsplot` to give  some kickass displays. For example,
`acf2(soi, col=4, lwd=3, gg=TRUE)`.


+ `sarima.sim` output used to start at time `0` - now the start
  time is up to the user (with default `t0=0`).
  


---
##### <s>Version 1.11</s> -- in the garbage

&nbsp;&nbsp; keep moving ... nothing to see here (basically, we forgot R is not zero-based)

---

#### Version 1.10 - May 2020 



+ added `sarima.sim` to simulate data from (possibly seasonal) ARIMA models ... as usual, it has simplified `astsa` syntax - the model is specified by the parameters, no lists are needed.  The script uses `polyMul` (also added) to obtain the appropriate autoregessive and moving average polynomials from the specified model.  

+ Changed any script that used colors as numbers to color names (due to change in R v4 palettes).

+ added PACF option to `acf1` so you can see the PACF alone

+ added `plot` option in `sarima.for`. 

+ added `spec.ic` which is similar to `spec.ar` but has option to base the AR spectral estimate on BIC and to `detrend` before the fit.

+ fixed `tsplot` - the minor ticks weren't changing on multiple plots

+ A major change was to fix routines that produced graphics but  didn't work on Apple's OS. In addition, I made `tsplot` even more useful:


   + For `tsplot`, I added an argument (`byrow`) where you can plot row wise (`TRUE`) or 
column wise (`FALSE`) for multiple plots. 

   + Also, for `tsplot`, added an argument `gg` so if it's true the plot will have a g-gray interior ... e.g., `tsplot(climhyd, ncolm=2, gg=TRUE, col=rainbow(6,v=.8), lwd=2)`


------------------------------

#### Version 1.9 - May 2019  


+ Added the polio data (`polio`) set from the gamlss.data package.  It is used in Chapter 6 problems. I added it because `gamlss.data` has data sets with names that are the same as those in astsa. I hate to see package fights.


+ Updated correlation scripts: 

   - for `acf1` and `acf2`, `plot=TRUE` prints rounded values, but if `plot=FALSE` the returned values are not rounded by the scirpt.

    - and `ccf2`, the values are now returned invisibly.



+ Updated `mvspec` due to possible plot error  being caused by use of `panel.first` (tries to draw `grid` before `plot` is called on some machines or OS).  Note to self: avoid `panel.first` dumb ass.

+ Updated `arma.spec` to avoid same problem as `mvspec`

+ While I'm here, updated `tsplot` to avoid similar problems.



+ added the ability of `tsplot` to do multiple plots, for example,<br/> 
`tsplot(eqexp[,1:8], col=rainbow(8), ncolm=2, lwd=2, main='EQs')` <br/> - there's no change for univariate time series. 


+ added ellipses ( &hellip; ) to `lag1.plot` and `lag2.plot` so you can change some of the graphical parameters; e.g., `lag1.plot(soi, max.lag=4, pch=20, cex=1.5, col=rgb(0,.5,1,.5))
`

+ fixed some man pages (after cRan submission) 

-------------------------------------------
#### Version 1.8 - Dec 2017  

>  Time Series Analysis and Its ... __Edition 4__ was written under this version.</b>

+ Fixed &beta; reporting for `LagReg()` when `inverse=TRUE`... it is correct in the text example.

+ Added ability to fix parameters  in `sarima()` and `sarima.for()`. Works just like it does in the stat package `arima()` but `transform.pars` is set to `FALSE` automatically if parameters are fixed.

+ Added a little explanation of how ICs are calculated in the `sarima()` man page.

+ Added `Grid()` combining `grid(lty=1, col=gray(.9))` and `minor.ticks()` from Graphics and Hmisc packages.  It's used in most scripts that used to call `grid()`.

+ Added `ssm()` for fitting a simple univariate state space model. This will be used in the forthcoming text.


+ `lag1.plot` and `lag2.plot` now have color option for the points with default `gray(.1)` for a little nicer display 
+  added `cardox` data set, an update to `co2` in the datasets package, which stopped in 1997 (now to the end of 2018) 
+ tweaked `sarima` residual analysis graphic so it has less white space - nothing else has changed


+ changed `mvspec` and `arma.spec` so the default is NOT to plot on a log scale and the graphics now have a grid ... also, for `mvspec`, added a `details` value, which is a matrix of *frequency, period, spectral ordinate*- e.g., `mvspec(soi)$details[1:45,]`

+ changed calculation of the ICs in `sarima` ... there will be a slight difference because I didn't remove the log(2&pi;) part.

+ (basically adding some new data sets):

   + added US GDP - quarterly adjusted to 1947-1 to 2018-3
   + slight change to `acf1` and `acf2` so user can change `ylim` 
   + `Hare` and `Lynx` the 90-year data sets of snowshoe hare and lynx pelts purchased by the Hudson's Bay Company of Canada - note `Lynx` differs from the R data set `lynx`. 
   + `gtemp_land`    land only - updated global temps to 2017
   + `gtemp_ocean`   open ocean only to 2017
   + added data set `salmon` 
   + added source of data to `gnp` man page
   + added `plot` option to `acf1` with default `TRUE` and a few additional minor changes


+ minor change to the way `acf2` calls `main` (cleaner) 



----------------------------
#### Version 1.7 - Dec 2016  

&starf; Just for historical record, version 1.7 was when CRAN maintainers got CRANky and started asking for arbitrary changes that no one would notice. I'm talking about asking to change one word in the DESCRIPTION file kind of stupid stuff.  This is when the GitHub versions started. 

+ added `ARMAtoAR` to give the pi-weights in the invertible representation of an ARMA model ... this is included mainly for pedagogical reasons
  
+ changed the `max.lag` default in `acf1` and `acf2` so if the series is
seasonal, you'll see at least 4 seasons by default ... I got tired of typing
`acf2(soi, 48)` in class ... now `acf2(soi)` is the same.  


+ in `sarima.for`, added the option to include regressors in the forecast

+  changed `na.action` to `na.pass` in `acf1`, `acf2`, and `ccf2`... these used to be `na.fail` which is the R stats package default

+ updated `tsplot` so the time index can be changed

+ added `tsplot` to give a nice plot of a univariate time series in one easy command ... works like `plot` for a `ts` object.


+ added `ccf2`, which plots the sample CCF of two series... it operates like `ccf` but the graphic is nicer

+ added `acf1` giving the sample ACF of a series without the  zero lag... it operates like `acf2` but doesn't give the PACF
	
+  added data set `hor`, quarterly Hawaiian Occupancy Rate (% of rooms)

+  some additons to `acf2` allowing a plot title change, and
     an option not to produce a graphic (if you only want to use or see the
	 values in a nice form)

+   added `plot.all` option to `sarima.for` so that if TRUE, all the data are plotted in the graphic; otherwise,
      only the last 100 observations are plotted.  The default is `plot.all=FALSE`  because it's easier to see 
      the forecasts if only 100 observations are plotted.

+  minor changes to `sarima`:  

   + diagnostic QQplot used to  depend on `MASS` package until it gave warnings on some simple examples ... now it's done "inhouse"<br/>
   +  changed degrees of freedom calculation (wasn't sure
	 the commands I used to get it were correct... now I'm sure).
   + made `details=FALSE` also shut off the diagnostic plot, so if you run<br/>
	 `dog <- sarima(cmort, 1,1,1, details=FALSE)`  <br/>
	  then everything (except the graphic) is stored in `dog` and you won't see any output.


+ fixed `x0n` and `P0n` in `Ksmooth0` and `Ksmooth1` (minor fix) 

+ add `box()` after `grid()` on some graphics 
   because the grid was overplotting the box =(
   
+ added title option to `sarima()` diagnostic plots indicating 
   model orders (there by default) ... now if you fit a few models, 
   it's easy to see which diagnostic plot goes with which model...

+ ... also added pointwise 99.9% confidence bounds to the innovations diagnostic QQ-plot based on asymptotic distn of iid normal order statistics ... and some minor tweaks to the Q-stat plot

+ now show ±1 and ±2 root MSPE bounds to `sarima.for()` and used transparent ribbons to display all error bounds because you can't be too pretty

+ added time series `cpg` (annual median cost per GB of storage) for an easy regression with autocorrelated errors exercise

+ added time series `UnempRate`, which can be taken as an update to `unemp` (still there) - the data are monthly US unemployment rate (% unemployed) from 1948 to Nov 2016.

----------------------------
#### Version 1.6 - October 2016 


+ added series `globtemp` and `globtempl` ... they are updates to the global temperature deviation series `gtemp` and `gtemp2`, respectively.  `globtempℓ` is land only.  `gtemp` and `gtemp2` are still in astsa so as not to cause problems - the temperature data sets were reformulated in 2011 so the series do not match up in the overlapping time frame - see the help file for more info

+ added new series `chicken`  ... the price of chicken, which is a decent example of trend stationarity 

----------------------------
#### Version 1.5 - August 2016


+ needed a minor fix to `acf2`, so while I'm here: 

+ minor tweaks to `acf2` and `sarima.for` displays

+ added `xts` dataset `djia` (Dow Jones) so don't need internet connection to use it (or Yahoo now that Verizon owns it - who knows what will happen???)

+ listed p-values in `sarima` `ttable` because t-tables and p-values go together like horses and carriages, and were popular together around the same time.	


---------------------------
#### Version 1.4 - July 2016


+ `sarima` has a t-table now (no p-values)

+ data set `ar1boot` is gone (example uses simulated data) 

+ minor tweaks to `lag1.plot` and `lag2.plot` displays

+ added `sp500w` ... an `xts` data set, S&P500 weekly returns

+ updated man pages for new edition


-------------------------
#### Version 1.3  -  Nov 2014


+ `sarima` now allows inclusion of `xreg` to facilitate regression with autocorrelated errors 

+ fixed `acf2` so grid is under plot

+ `star` data added

+ `sunspotz` man page emphasizes data are 2 times/year

+ fixed estimate of *cov( v<sub>t</sub> ) = R* in `EM0` and `EM1` (t=1 part was missing)

+ fixed typo in `EMx` missing code (0=observed, 1=missing)

+ `EM1` fixed so inputs are not allowed (and no longer included in the call):

   * Inputs are not allowed. The script uses `Ksmooth1`, but everything 
     related to inputs are set equal to zero.  That was the original 
     intent of this script.
   
   * It would be relatively easy to include estimates of `Ups` and `Gam`  because conditional on the states, these are just regression coefficients. If you decide to alter `EM1` to include estimates of the `Ups` or `Gam`, feel free to notify me with a working example and I'll include it in the  next update (assuming it's correct, of course). Instructors... this would bean awesome class project.

-------------------------
#### Version 1.2  - March 2014


+ Fixed man page for the scripts `stoch.reg` and for the `Kfilter`s and `Ksmooth`s

+ `acf2` can take additional `acf` arguments like `na.action=na.omit` ...

+ `acf2` max vertical axis was always 1; now it depends on data

+ `acf2` now has grid lines

+ `FDR` man entry corrected

+ `Kfilter1`; changed `Ups` and `Gam == 0` case to match `Kfilter2`s appropriate method

+ `astsadata()` is gone, `LazyData: true` instead

-------------------------
#### Version 1.1  - July 2012

+ Associated namespace with all but 'base' function calls

+ Added data set `blood` (based on code in Example 6.1) as an mts object of the Jones data set with `NA` as missing data code. Example 6.9 still uses 0 for missing data.  

+ Added links to related data sets in some man pages (e.g., `oil` <-> `gas` ...)

+ Added `astsadata.R` option to load all the data sets at once.

+ Changed `mvspec.R` so it could be used in place of `spec.pgram` and `spectrum`.  The defaults are similar now to `spec.prgram`, but the default is not to taper, forcing the user to think about it.  It also returns the book's more useful definition of bandwidth.  

-------------------------
#### Version 1.0  - June 2012


+ `astsa` built from `tsa3.rda` (which is gone now) with the following changes:<br/>


| in astsa |  was  | in tsa3 |
|:----------:|:---:|:--------:|
|`arma.spec()` | ... | `spec.arma()` |
|`lag1.plot()` | ... | `lag.plot1()` |
|`lag2.plot()` | ... | `lag.plot2()` |


-----------------
#### Version 0.4 - 2010

For the 3rd edition of the text, we included data and scripts as a compressed file
called `tsa3.rda` and the basic version of ASTSA was abandoned.  Two years later,
`tsa3.rda` was abandoned.


-----------------
#### Version 0.3 - 2005

The second edition of the text, which included the subtitle  *With R Examples* was when we started
giving R code in the text and writing R scripts to compensate for the fact that S and consequently R provided scripts for time series as an afterthought.  Still, much of the analysis in the text was done using Matlab.

-----------------
#### Version 0.2 -  2000  

The first edition of *Time Series Analysis and Its Applications* used 
an updated version of the basic  `ASTSA` and it was distributed on the website for that
version: [Edition 1 site](https://www.stat.pitt.edu/stoffer/xtra_stuff/tsa.html).
You had to extract the files to a floppy (3.5" by that time) and then install `ASTSA`.




-----------------
#### Version 0.1 - 1988

<img src="fun_with_astsa/figs/astsa_v0.jpg" alt="floppy"  height="300">

The first version of `ASTSA` was developed by R.H. Shumway for the new text *Applied Statistical Time Series Analysis* published by Prentice Hall.  The package was written in Microsoft basic and was distributed on a 5.25" floppy disk that was included with the text. 

The instruction manual has been preserved for historical purposes: [http://www.stat.pitt.edu/stoffer/astsaman.pdf](http://www.stat.pitt.edu/stoffer/astsaman.pdf)
