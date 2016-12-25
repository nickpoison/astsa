
_version 1.7 is the most current version and is on CRAN now_  - Nicky

[![Rdoc](http://www.rdocumentation.org/badges/version/astsa)](http://www.rdocumentation.org/packages/astsa)   [![Research software impact](http://depsy.org/api/package/cran/astsa/badge.svg)](http://depsy.org/package/r/astsa) [![](http://cranlogs.r-pkg.org/badges/astsa)](http://cran.rstudio.com/web/packages/astsa/index.html) [![](http://www.stat.pitt.edu/stoffer/tsa4/NickyApproved.png)]

_Badges, to god-damned hell with badges! We have no badges. In fact, we don't need badges. I don't have to show you any stinking badges, you god-damned cabrón and chinga tu madre!_

From _The Treasure of the Sierra Madre_, by B. Traven

----------------------------
### Version 1.7 - Dec 2016  


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


+ astsa built from tsa3.rda with the following changes:

          in astsa | is |  in tsa3   
         ----------|----|------------
      `arma.spec()`|    |`spec.arma()` 
      `lag1.plot()`|    |`lag.plot1()` 
      `lag2.plot()`|    |`lag.plot2()` 

* `tsa3.rda` is gone    

