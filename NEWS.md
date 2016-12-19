----------------------------
### Version 1.7 - Dec 2016 (will be on CRAN by end of year)


+ fixed `x0n` and `P0n` in `Ksmooth0` and `Ksmooth1` (minor fix) 

+ add `box()` after `grid()` on some graphics 
   because the grid was overplotting the box =(
   
+ added title option to `sarima()` diagnostic plots indicating 
   model orders (there by default)

+ added ptwise 99.9% conf bounds to QQ-plot

+ added +/-1 root MSPE bounds to `sarima.for()` and changed graphic 
   params a little - bnds are a gray swatch

+ added data set `cpg` (cost per GB of storage) for a problem

+ added `UnempRate` data set... US unemployment in percent unemployed
   from 1948 to November 2016

----------------------------
### Version 1.6 - October 2016 (on CRAN)


+ added 3 new series: 

1. `globtemp` 
2. `globtempl`
3. `chicken`

* 1 and 2 are updates to the global temperature deviation series to 2015, 
   globtemp-el is land only. 
   
* The third set is the price of chicken - a good example of trend stationary. 

----------------------------
### Version 1.5 - August 2016


+ needed a minor fix to `acf2`, so while I'm here: 

+ minor tweaks to `acf2` and `sarima.for` displays

+ added dataset `djia` (Dow Jones) so don't need internet connection to use it

+ gave in to peer pressure and listed p-values in `sarima` ttable


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

