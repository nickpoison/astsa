
## This is the changelog for `astsa` ...


To update the package to the most recent version, you just need the following two lines:
>  `install.packages("devtools")`<br/>
>  `devtools::install_github("nickpoison/astsa")`

------------------------------
### Version 1.9  - May 2019 (GitHub and CRAN)

This version is essentially version 1.8.8 but with changes made to pass the CRAN tests, which mainly deal with the man pages (help files). I noticed a few typos in the man pages after submitting to CRAN but I'm keeping the version number at 1.9.

For the Springer text, you can see the difference between v1.8 and v1.9 by looking at the changelog below v1.8.8.  Some scripts have added capabilities, but it won't change any data analysis. The only real difference will be slight numerical differences in the reported ICs in `sarima`.     


### Version 1.8.8 - Mar 2019 (GitHub)

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


------------------------------
### Version 1.8 - Dec 2017 (GitHub and CRAN)

<b> Time Series Analysis and Its Applications With R Examples -- Edition 4 was written under this version, so you don't need more recent updates to get through the text. But as my mother used to say, *"It couldn't hurt!"* </b>

+ Version 1.8 is on CRAN 

+ Version 1.8.1 is here on GitHub.

+ These versions are essentially version 1.7.11 but with some minor
changes to satisfy the CRANks. Also, the   GitHub version is slightly improved, so call it v1.8.1. The changes are things no one would notice in places where no one looks.


----------------------------
### Version 1.7.11 - Oct 2017  (on GitHub)


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
	
1.7.4.  added data set `hor`, quarterly Hawaiian Occupancy Rate (% of rooms) ... 
    good for showing seasonal persistence - check this out [hawaii_occ_rate.r](https://github.com/nickpoison/tsa4/blob/master/hawaii_occ_rate.r)

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

	 

----------------------------
### Version 1.7 - Dec 2016  (on CRAN)


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

+ fixed estimate of $cov(v\_t) = R$ in `EM0` and `EM1` (t=1 part was missing)

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

+ Associated namespace with all 'base' function calls
 
+ Added data set `blood` (based on code in Example 6.1) as an mts object of the Jones data set with `NA` as missing data code. Example 6.9 still uses 0 for missing data.  

+ Added links to related data sets in some man pages (e.g., `oil` <-> `gas` ...)

+ Added `astsadata.R` option to load all the data sets at once.

+ Changed `mvspec.R` so it could be used in place of `spec.pgram` and `spectrum`.  The defaults are similar now to `spec.prgram`, but the default is not to taper, forcing the user to think about it.  It also returns the book's more useful definition of bandwidth.  

-------------------------
### Version 1.0  - June 2012


+ astsa built from tsa3.rda with the following changes

          in astsa | was |  in tsa3   
         ----------|-----|------------
       arma.spec() |     | spec.arma() 
       lag1.plot() |     | lag.plot1() 
       lag2.plot() |     | lag.plot2() 

* `tsa3.rda` is gone    

