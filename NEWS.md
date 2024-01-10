
## This is the changelog for 


<img src="fun_with_astsa/figs/astsa.gif" alt="astsa"  height="100">

**more than just data ... it's a palindrome**  

... `astsa` is the R package to accompany  [Time Series Analysis and Its Applications: With R Examples](http://www.stat.pitt.edu/stoffer/tsa4/)  and  [Time Series A Data Analysis Approach using R](http://www.stat.pitt.edu/stoffer/tsda/). 

The GitHub version is updated before the CRAN version.   To update the package to the most recent working version, you just need the following two lines:

```r
install.packages("remotes")   # if you don't have the package already
remotes::install_github("nickpoison/astsa/astsa_build")
```

>  If `astsa` is loaded, then detach it first: `detach(package:astsa)`.  If you get a warning to install Rtools, ignore it. After successful installation, don't forget to reload  `astsa`. If you get an error, just restart R and reload `astsa`.

&#x1F4A1;  You can also install `astsa` from the archive (which is always current)
[astsa_2.1.tar.gz](https://github.com/nickpoison/astsa/blob/master/astsa_2.1.tar.gz). Download it (there's a download button) and in R, use _Install package(s) from local files..._ from the Packages tab.


&#128036; You can find a short guide to  astsa scripts right here at [**FUN WITH ASTSA**](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md) .

#### &#10024; Here is [A Road Map](https://nickpoison.github.io/) if you want a broad view of what is available. 

 
---
---

### Version 2.1 (on GitHub)

- Jan 2024:  v2.0.1:0018 is now v2.1 here and will push to CRAN this month... hopefully the
CRANks won't push back.  


#### v2.0.1.0018: (on GitHub) - some small and a few not so small updates after v2.0:

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

### Version 2.0 - Jan 2023 (on CRAN)

 >  **Note**  There are a number of new scripts and some old ones are set to be retired eventually.  

- Added [`autoSpec`](https://dx.doi.org/10.4310/21-SII703) for changepoint detection using local nonparametric spectra.

    - Also added the data set `ENSO` which is the most recent update to SOI (an older version was used the paper that introduced autoSpec).  

    - The script uses the Bartlett kernel so it was made available for general use; see `bart`.

- Also added   [`autoParm`](https://doi.org/10.1198/016214505000000745) for changepoint detection using local AR models.

✄ &nbsp; Some examples are in  [FUN WITH ASTSA - structural breaks](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md#6-detecting-structural-breaks).

&#128312;&#128312;&#128312;&#128312;&#128312;



   - Added `Kfilter` and `Ksmooth` which are faster than the older `Kfilter0-1-2` and  `Ksmooth0-1-2`, are easier to work with, and removes the need for 3 different scripts.  Simple examples are in the help files and other examples are on  [FUN WITH ASTSA - Kalman filtering and smoothing](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md#quick-kalman-filter-and-smoother).

 

   - Added `EM` which supersedes `EM0` and `EM1` and uses the quicker `Kfilter` and `Ksmooth` scripts. **In addition, the script now accepts inputs in both the state and observations equations.** There's an example in the help file (?EM) and other examples on [FUN WITH ASTSA - EM algorithm and missing data](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md#9-em-algorithm-and-missing-data).

 
 > __Warning__  the old script names  `EM0-1`, `Kfilter0-1-2`, and `Ksmooth0-1-2` have an `x` in front of them now: `xEM0-1`, `xKfilter0-1-2`, and `xKsmooth0-1-2`.  The scripts haven't changed (old scripts will still work with the `x` name change), but they will be phased out eventually.  Converting code that used the old scripts to use the newer scripts should be easy with only a few minor changes in the call.  

&#128312;&#128312;&#128312;&#128312;&#128312;

   - Updated (to run with the new `Kfilter` and `Ksmooth` scripts): 
   
      + the Forward Filtering Backward Smoothing script (`ffbs`) and 
      + the simple univariate state space model (`ssm`) script       

   - Updated data files `gtemp_land` and `gtemp_ocean` to 2021  

   - Made `lag1.plot` and `lag2.plot` look more purty. 

---
---


### Version v1.16 - Sept 2022 (on CRAN)

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
### Version 1.15 - May 2022
+   v1.15 is v1.14.3 plus the following 2 additions and (of course) minor changes to appease the CRAN warlords:

    + Added two new scripts ```detrend()``` and ```trend()```.  The first one returns a detrended series using a polynomial regression (default is linear) or lowess (with the default span).  The second script fits a trend (same options as detrend) and produces a graphic of the series with the trend and error bounds superimposed.  The trend and error bounds are returned invisibly.





---
### Versions 1.14 - Sept 2021

+ v1.14.3  (Dec 2021)
   
   + Added sleep state and movement data (`sleep1` and `sleep2`) - more details in the help files. 

   + Added option to specify a kernel in `specenv` and if `spans` and `kernel` are both `NULL`, the spectral envelope will be based on the periodogram.  Also changed the way it checks if `section` is a proper sequence and added option to taper the data prior to estimating spectra.  

   + Some minor changes: 
   
     - In `matrixpwr` changed `isSymmetric(A)` to `isSymmetric(unname(A))`  because a symmetric matrix is not taken as such if the column and row names are not the same.  
     
     - In `arma.spec` if there is near parameter redundancy, `ylim` is now adjusted so the figure will be close to the white noise (uniform) density.
    
+ v1.14 (Sept 2021) Just in time for a new skool year - v1.14 is on CRAN -  it is v1.13.2 with minor changes to please the CRAN gods.

---
### Versions 1.13 - May 2021

+ v1.13.2 (Aug 2021) Added `acfm` for multiple time series. Produces a matrix of plots of sample ACFs on the diagonal and sample CCFs on the off-diagonals. It's just a nicer version of `acf` for multiple time series. 

   + Also, changed the LAG axis labels on `acf1`, `acf2`, and `ccf2` to show the 
   frequency of the series if it's bigger than one.  For example, `soi` has
   frequency 12 and the LAG axis of `acf1(soi)`  will be ticked as 1, 2, 3, ...
   but the label now emphasizes that each tick is LAG divided by 12.

+ v1.13.1 (July 2021) Some minor improvements  to `tsplot-spaghetti`, `sarima.sim`, `sarima`, and `arma.spec`.

    + For `sarima.sim`, I forgot to add the `innov` argument in the call (only a problem if you wanted to use your own innovations), but it seemed to work in the examples I tried (maybe it got passed in ...) ¿Quién sabe?   Or maybe it was just voodoo. 

    + Updated some man page (adding sources and subtracting typos).

+ v1.13 is on CRAN.   There are lots of additions to the package that are listed below.


---

### Versions 1.12 - started Dec 2020

1.12.9 (GitHub - May 2021) 

+ Added `scatter.hist` to draw a scatterplot with marginal histograms - never really liked other versions.

+ Minor updates to `tsplot`, `SigExtract` and  `LagReg` to improve the displays.

+ Added scripts for the analysis of DNA sequences and other categorical time series: `specenv`, `dna2vector`, and the data set `EBV`.  And `specenv` can also handle real-valued series; see the examples included in the man page for `specenv` or in  [**FUN WITH ASTSA**](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md).


    - `dna2vector` is used to preprocess a categorical sequence.

    - `EBV` is the entire Epstein-Barr sequence as a long single string. It's not useful on its own, but thru `dna2vector`, different regions can be explored via `specenv`.



+ We needed powers of matrices enough where we thought we'd include it in `astsa`.  The script is called `matrixpwr` and includes `%^%` as a more intuitive operator.
For example, `var(econ5)%^%-.5` to calculate an inverse square root matrix.


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

+ The package now has its own color palette that is attached
when the package is attached. The palette is  especially  suited for plotting
 time series. It is a bit darker than the new default R4 palette.
You can revert back using  `palette("default")`. 

  - In addition, added `astsa.col` script to easily adjust opacity of the astsa color palette - examples on its man page. 

+ Improvements to `acf1`, `acf2`, and `ccf2` employing the power of
`tsplot` to give  some kickass displays. For example,
`acf2(soi, col=4, lwd=3, gg=TRUE)`.


+ `sarima.sim` output used to start at time `0` - now the start
time is up to the user (with default `t0=0`).




1.12 (CRAN - Dec 2020) The main change  was to add a  simulation script `sarima.sim` for seasonal ARIMA models.   


---
#### <s>Version 1.11</s> -- in the garbage

&nbsp;&nbsp; keep moving ... nothing to see here 

---

### Versions 1.10 - May 2020 


1.10.6 (Nov 2020 - Github)

+ added `sarima.sim` to simulate data from (possibly seasonal) ARIMA models ... as usual, it has simplified `astsa` syntax - the model is specified by the parameters, no lists are needed.  The script uses `polyMul` (also added) to obtain the appropriate autoregessive and moving average polynomials from the specified model.  

+ Changed any script that used colors as numbers to color names (due to change in R v4 palettes).

+ added PACF option to `acf1` so you can see the PACF alone

+ added `plot` option in `sarima.for`. 

+ added `spec.ic` which is similar to `spec.ar` but has option to base the AR spectral estimate on BIC and to `detrend` before the fit.

+ fixed `tsplot` - the minor ticks weren't changing on multiple plots

1.10 (May 2020 - CRAN)
Since Version 1.9, see the updates 1.9.1-4 below.  The major change was to fix routines
that produced graphics but  didn't work on Apple's OS. In addition, I made `tsplot` even more useful:


+ For `tsplot`, I added an argument (`byrow`) where you can plot row wise (`TRUE`) or 
column wise (`FALSE`) for multiple plots. 

+ Also, for `tsplot`, added an argument `gg` so if it's true the plot will have a g-gray interior ... e.g., `tsplot(climhyd, ncolm=2, gg=TRUE, col=rainbow(6,v=.8), lwd=2)`


------------------------------

### Versions 1.9 - May 2019  



1.9.4  

+ Added the polio data (`polio`) set from the gamlss.data package.  It is used in Chapter 6 problems. I added it because gamlss.data has data sets with names that are the same as those in astsa. I hate to see package fights.

1.9.3  

+ Updated correlation scripts: 

   - for `acf1` and `acf2`, `plot=TRUE` prints rounded values, but if `plot=FALSE` the returned values are not rounded by the scirpt.

    - and `ccf2`, the values are now returned invisibly.

1.9.2  

+ Updated `mvspec` due to possible plot error  being caused by use of `panel.first` (tries to draw `grid` before `plot` is called on some machines or OS).  Note to self: avoid `panel.first` dumb ass.

+ Updated `arma.spec` to avoid same problem as `mvspec`

+ While I'm here, updated `tsplot` to avoid similar problems.

1.9.1 

+ added the ability of `tsplot` to do multiple plots, for example,<br/> 
`tsplot(eqexp[,1:8], col=rainbow(8), ncolm=2, lwd=2, main='EQs')` <br/> - there's no change for univariate time series. 


+ added ellipses ( &hellip; ) to `lag1.plot` and `lag2.plot` so you can change some of the graphical parameters; e.g., `lag1.plot(soi, max.lag=4, pch=20, cex=1.5, col=rgb(0,.5,1,.5))
`

+ fixed some man pages (after cRan submission)

1.9 (CRAN - May 2019)

+ This version is essentially version 1.8.8 but with changes made to pass the CRAN tests, which mainly deal with the man pages (help files). 

+ For the Springer text, you can see the difference between v1.8 and v1.9 by looking at the changelog below v1.8.8.  Some scripts have added capabilities, but it won't change any data analysis. The only real difference will be slight numerical differences in the reported ICs in `sarima`.     

-------------------------------------------
### Versions 1.8 - Dec 2017  


1.8.8 

+ Fixed &beta; reporting for `LagReg()` when `inverse=TRUE`... it is correct in the text example.

+ Added ability to fix parameters  in `sarima()` and `sarima.for()`. Works just like it does in the stat package `arima()` but `transform.pars` is set to `FALSE` automatically if parameters are fixed.

+ Added a little explanation of how ICs are calculated in the `sarima()` man page.

1.8.7 Added `Grid()` combining `grid(lty=1, col=gray(.9))` and `minor.ticks()` from Graphics and Hmisc packages.  It's used in most scripts that used to call `grid()`.

1.8.6 Added `ssm()` for fitting a simple univariate state space model. This will be used in the forthcoming text.

1.8.5 

+ `lag1.plot` and `lag2.plot` now have color option for the points with default `gray(.1)` for a little nicer display 
+  added `cardox` data set, an update to `co2` in the datasets package, which stopped in 1997 (now to the end of 2018) 
+ tweaked `sarima` residual analysis graphic so it has less white space - nothing else has changed


1.8.4 changed `mvspec` and `arma.spec` so the default is NOT to plot on a log scale and the graphics now have a grid ... also, for `mvspec`, added a `details` value, which is a matrix of *frequency, period, spectral ordinate*- e.g., `mvspec(soi)$details[1:45,]`

1.8.3 changed calculation of the ICs in `sarima` ... there will be a slight difference because I didn't remove the log(2&pi;) part.

1.8.2 (basically adding some new data sets)

+ added US GDP - quarterly adjusted to 1947-1 to 2018-3
+ slight change to `acf1` and `acf2` so user can change `ylim` 
+ `Hare` and `Lynx` the 90-year data sets of snowshoe hare and lynx pelts purchased by the Hudson's Bay Company of Canada - note `Lynx` differs from the R data set `lynx`. 
+ `gtemp_land`    land only - updated global temps to 2017
+ `gtemp_ocean`   open ocean only to 2017
+ added data set `salmon` 
+ added source of data to `gnp` man page
+ added `plot` option to `acf1` with default `TRUE` and a few additional minor changes


1.8.1 minor change to the way `acf2` calls `main` (cleaner)  - this was done at the beginning of v1.8 - it just never made it to CRAN 


<b> Time Series Analysis and Its Applications With R Examples -- Edition 4 was written under this version, so you don't need more recent updates to get through the text. </b>

+ Version 1.8 is on CRAN 

+ Version 1.8.1 is here on GitHub.

+ These versions are essentially version 1.7.11 but with some minor
changes to satisfy the CRANks. Also, the   GitHub version is slightly improved, so call it v1.8.1. The changes are things no one would notice in places where no one looks.


----------------------------
### Versions 1.7 - Dec 2016  
&starf; Just for historical record, version 1.7 was when CRAN maintainers got CRANky and started asking for arbitrary changes that no one would notice. I'm talking about asking to change one word in the DESCRIPTION file kind of stupid stuff.  This is when the GitHub versions started. 

1.7.11. 
       
+ added `ARMAtoAR` to give the pi-weights in the invertible representation of an ARMA model ... this is included mainly for pedagogical reasons
   
+ changed the `max.lag` default in `acf1` and `acf2` so if the series is
seasonal, you'll see at least 4 seasons by default ... I got tired of typing
`acf2(soi, 48)` in class ... now `acf2(soi)` is the same.  


1.7.10. in `sarima.for`, added the option to include regressors in the forecast

1.7.9. changed `na.action` to `na.pass` in `acf1`, `acf2`, and `ccf2`... these used to be `na.fail` which is the R stats package default

1.7.8. updated `tsplot` so the time index can be changed

1.7.7. added `tsplot` to give a nice plot of a univariate time series in one easy command ... works like `plot` for a `ts` object.


1.7.6. added `ccf2`, which plots the sample CCF of two series... it operates like `ccf` but the graphic is nicer

1.7.5. added `acf1` giving the sample ACF of a series without the  zero lag... it operates like `acf2` but doesn't give the PACF
	
1.7.4.  added data set `hor`, quarterly Hawaiian Occupancy Rate (% of rooms)

1.7.3.  some additons to `acf2` allowing a plot title change, and
     an option not to produce a graphic (if you only want to use or see the
	 values in a nice form)

1.7.2.   added `plot.all` option to `sarima.for` so that if TRUE, all the data are plotted in the graphic; otherwise,
      only the last 100 observations are plotted.  The default is `plot.all=FALSE`  because it's easier to see 
      the forecasts if only 100 observations are plotted.

1.7.1.  minor changes to `sarima`   

  + diagnostic QQplot used to
     depend on `MASS` package until it gave warnings on some
	 simple examples ... now it's done "inhouse"<br/>
+  changed degrees of freedom calculation (wasn't sure
	 the commands I used to get it were correct... now I'm sure).
+   made `details=FALSE` also shut off the diagnostic plot, so if you run<br/>
 `dog <- sarima(cmort, 1,1,1, details=FALSE)`  <br/>
	 then everything (except the graphic) is stored in `dog` and you won't see any output.

	
1.7  On CRAN Dec 2016

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
### Version 1.6 - October 2016 


+ added series `globtemp` and `globtempl` ... they are updates to the global temperature deviation series `gtemp` and `gtemp2`, respectively.  `globtempℓ` is land only.  `gtemp` and `gtemp2` are still in astsa so as not to cause problems - the temperature data sets were reformulated in 2011 so the series do not match up in the overlapping time frame - see the help file for more info

+ added new series `chicken`  ... the price of chicken, which is a decent example of trend stationarity 

----------------------------
### Version 1.5 - August 2016


+ needed a minor fix to `acf2`, so while I'm here: 

+ minor tweaks to `acf2` and `sarima.for` displays

+ added `xts` dataset `djia` (Dow Jones) so don't need internet connection to use it (or Yahoo now that Verizon owns it - who knows what will happen???)

+ listed p-values in `sarima` `ttable` because t-tables and p-values go together like horses and carriages, and were popular together around the same time.	


---------------------------
### Version 1.4 - July 2016


+ `sarima` has a t-table now (no p-values)

+ data set `ar1boot` is gone (example uses simulated data) 

+ minor tweaks to `lag1.plot` and `lag2.plot` displays

+ added `sp500w` ... an `xts` data set, S&P500 weekly returns

+ updated man pages for new edition


-------------------------
### Version 1.3  -  Nov 2014


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
### Version 1.2  - March 2014


+ Fixed man page for the scripts `stoch.reg` and for the `Kfilter`s and `Ksmooth`s

+ `acf2` can take additional `acf` arguments like `na.action=na.omit` ...

+ `acf2` max vertical axis was always 1; now it depends on data

+ `acf2` now has grid lines

+ `FDR` man entry corrected

+ `Kfilter1`; changed `Ups` and `Gam == 0` case to match `Kfilter2`s appropriate method

+ `astsadata()` is gone, `LazyData: true` instead
 
-------------------------
### Version 1.1  - July 2012

+ Associated namespace with all but 'base' function calls
 
+ Added data set `blood` (based on code in Example 6.1) as an mts object of the Jones data set with `NA` as missing data code. Example 6.9 still uses 0 for missing data.  

+ Added links to related data sets in some man pages (e.g., `oil` <-> `gas` ...)

+ Added `astsadata.R` option to load all the data sets at once.

+ Changed `mvspec.R` so it could be used in place of `spec.pgram` and `spectrum`.  The defaults are similar now to `spec.prgram`, but the default is not to taper, forcing the user to think about it.  It also returns the book's more useful definition of bandwidth.  

-------------------------
### Version 1.0  - June 2012


+ `astsa` built from `tsa3.rda` (which is gone now) with the following changes:<br/>


| in astsa |  was  | in tsa3 |
|:----------:|:---:|:--------:|
|`arma.spec()` | ... | `spec.arma()` |
|`lag1.plot()` | ... | `lag.plot1()` |
|`lag2.plot()` | ... | `lag.plot2()` |


-----------------
### Version 0.4 - 2010

For the 3rd edition of the text, we included data and scripts as a compressed file
called `tsa3.rda` and the basic version of ASTSA was abandoned.  Two years later,
`tsa3.rda` was abandoned.


-----------------
### Version 0.3 - 2005

The second edition of the text, which included the subtitle  *With R Examples* was when we started
giving R code in the text and writing R scripts to compensate for the fact that S and consequently R provided scripts for time series as an afterthought.  Still, much of the analysis in the text was done using Matlab.

-----------------
### Version 0.2 -  2000  

The first edition of *Time Series Analysis and Its Applications* used 
an updated version of the basic  `ASTSA` and it was distributed on the website for that
version: [Edition 1 site](https://www.stat.pitt.edu/stoffer/xtra_stuff/tsa.html).
You had to extract the files to a floppy (3.5" by that time) and then install `ASTSA`.



 
-----------------
### Version 0.1 - 1988

<img src="fun_with_astsa/figs/astsa_v0.jpg" alt="floppy"  height="300">

The first version of `ASTSA` was developed by R.H. Shumway for the new text *Applied Statistical Time Series Analysis* published by Prentice Hall.  The package was written in Microsoft basic and was distributed on a 5.25" floppy disk that was included with the text. 
 
The instruction manual has been preserved for historical purposes: [http://www.stat.pitt.edu/stoffer/astsaman.pdf](http://www.stat.pitt.edu/stoffer/astsaman.pdf)
