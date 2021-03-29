# fun with astsa


##### we'll demonstrate some of the capabilities of `astsa` ... if you haven't installed it yet, [head over to the News page for installation instructions](https://github.com/nickpoison/astsa/blob/master/NEWS.md).

Remember to load `astsa` at the start of a session.

> **`library(astsa)`**

it's more than just data ...


-----
------
 
### Table of Contents  
  * [1. Data](#1-data)
  * [2. Plotting](#2-plotting)
  * [3. Correlations](#3-correlations)
  * [4. ARIMA Simulation](#4-arima-simulation)
  * [5. ARIMA Estimation](#5-arima-estimation)
  * [6. Forecasting](#6-forecasting)
  * [7. Spectral Analysis](#7-spectral-analysis)
     * [ARMA Spectrum](#arma-spectral-density)
     * [Nonparametric](#nonparametric-spectral-analysis)
     * [Parametric](#parametric-spectral-analysis)
     * [Spectral Matrices](#more-multivariate-spectra)     
  * [8. Testing for Linearity](#8-linearity-test)
  * [9. State Space Models and Kalman Filtering](#9-state-space-models)
  * [10. EM Algorithm](#10-em-algorithm)
  * [11. Arithmetic](#11-arithmetic)
     * [ARMAtoAR](#armatoar)
     * [Matrix Powers](#matrix-powers)
     * [Polynomial Multiplication](#polynomial-multiplication)


-----
-----



## 1. Data  

&#x1F4A1; There are lots of fun data sets included in `astsa`. Here's a list obtained by issuing the command

> **`data(package = "astsa")`**

And you can get more information on any individual set using the `help()` command, e.g.
`help(cardox)` or `?cardox`


|Data sets in package ‘astsa’|                         |
|----------|-------------|
|EQ5                         | Seismic Trace of Earthquake number 5                        |
|EQcount                     | EQ Counts                                                   |
|EXP6                        | Seismic Trace of Explosion number 6                         |
|HCT                         | Hematocrit Levels                                           |
|Hare                        | Snowshoe Hare                                               |
|Lynx                        | Canadian Lynx                                               |
|PLT                         | Platelet Levels                                             |
|UnempRate                   | U.S. Unemployment Rate                                      |
|WBC                         | White Blood Cell Levels                                     |
|ar1miss                     | AR with Missing Values                                      |
|arf                         | Simulated ARFIMA                                            |
|beamd                       | Infrasonic Signal from a Nuclear Explosion                  |
|birth                       | U.S. Monthly Live Births                                    |
|blood                       | Daily Blood Work                                            |
|bnrf1ebv                    | Nucleotide sequence - BNRF1 Epstein-Barr                    |
|bnrf1hvs                    | Nucleotide sequence - BNRF1 of Herpesvirus saimiri          |
|cardox                      | Monthly Carbon Dioxide Levels at Mauna Loa                  |
|chicken                     | Monthly price of a pound of chicken                         |
|climhyd                     | Lake Shasta inflow data                                     |
|cmort                       | Cardiovascular Mortality from the LA Pollution study        |
|cpg                         | Hard Drive Cost per GB                                      |
|djia                        | Dow Jones Industrial Average                                |
|econ5                       | Five Quarterly Economic Series                              |
|eqexp                       | Earthquake and Explosion Seismic Series                     |
|flu                         | Monthly pneumonia and influenza deaths in the U.S., 1968 to 1978. |
|fmri                        | fMRI - complete data set                                    |
|fmri1                       | fMRI Data Used in Chapter 1                                 |
|gas                         | Gas Prices                                                  |
|gdp                         | Quarterly U.S. GDP                                          |
|globtemp                    | Global mean land-ocean temperature deviations to 2015       |
|globtempl                   | Global mean land (only) temperature deviations to 2015      |
|gnp                         | Quarterly U.S. GNP                                          |
|gtemp                       | Global mean land-ocean temperature deviations               |
|gtemp2                      | Global Mean Surface Air Temperature Deviations              |
|gtemp_land                  | Global mean land temperature deviations - updated to 2017   |
|gtemp_ocean                 | Global mean ocean temperature deviations - updated to 2017  |
|hor                         | Hawaiian occupancy rates                                    |
|jj                          | Johnson and Johnson Quarterly Earnings Per Share            |
|lap                         | LA Pollution-Mortality Study                                |
|lead                        | Leading Indicator                                           |
|nyse                        | Returns of the New York Stock Exchange                      |
|oil                         | Crude oil, WTI spot price FOB                               |
|part                        | Particulate levels from the LA pollution study              |
|polio                       | Poliomyelitis cases in US                                   |
|prodn                       | Monthly Federal Reserve Board Production Index              |
|qinfl                       | Quarterly Inflation                                         |
|qintr                       | Quarterly Interest Rate                                     |
|rec                         | Recruitment (number of new fish index)                      |
|sales                       | Sales                                                       |
|salmon                      | Monthly export price of salmon                              |
|salt                        | Salt Profiles                                               |
|saltemp                     | Temperature Profiles                                        |
|so2                         | SO2 levels from the LA pollution study                      |
|soi                         | Southern Oscillation Index                                  |
|soiltemp                    | Spatial Grid of Surface Soil Temperatures                   |
|sp500w                      | Weekly Growth Rate of the Standard and Poor's 500           |
|speech                      | Speech Recording                                            |
|star                        | Variable Star                                               |
|sunspotz                    | Biannual Sunspot Numbers                                    |
|tempr                       | Temperatures from the LA pollution study                    |
|unemp                       | U.S. Unemployment                                           |
|varve                       | Annual Varve Series                                         |

-----


## 2. Plotting

&#x1F4A1; When `astsa` is loaded, the astsa palette is attached.  The palette is  especially  suited for plotting  time series and it is a bit darker than the new default R4 palette. You can revert back using  `palette("default")`.  Also,  

> **`astsa.col()`** 

is included to easily adjust the opacity of the colors. 

```r
par(mfrow=c(3,1))

barplot(rep(1,8), density=10, angle=c(45, -45))
par(new=TRUE)
barplot(rep(1,8), col=1:8, main='astsa palette', names=1:8)

barplot(rep(1,8),density=10, angle=c(45, -45))
par(new=TRUE)
barplot(rep(1,8), col=astsa.col(1:8, .7), main='transparency', names=1:8)

barplot(rep(1,8), density=10, angle=c(45, -45))
par(new=TRUE)
barplot(rep(1,8), col=astsa.col(3:6, .5), main='pastelity', names=rep(3:6, 2))
```
**Notice each color display has diagonal lines behind it to demonstrate opacity.**

<img src="figs/palette.png" alt="palette"  width="700">



&#x1F535; For plotting time series and just about anything else, you can use

> **`tsplot()`**




&#x1F535; Notice there are minor ticks and a grid by default. Here are some examples.

```r
par(mfrow=c(2,1))
tsplot(soi, col=4, lwd=2)
tsplot(soi, col=4, lwd=2, gg=TRUE)
```
<img src="figs/tsplot1.png" alt="tsplot"  width="700">

&#x1F535; Many in one swell foop:

```r
tsplot(climhyd, ncol=2, gg=TRUE, col=2:7, lwd=2) 
```
<img src="figs/climhyd.png" alt="climhyd"  width="700">


&#x1F535; Do you like `spaghetti` (you can shorten it to `spag` or even `spaghet`):

```r
tsplot(cbind(Hare,Lynx), col=astsa.col(c(2,4),.5), lwd=2, type="o", pch=c(0,2),
          ylab=expression(Number~~~(""%*% 1000)),  spaghetti=TRUE)
legend("topright", legend=c("Hare","Lynx"), col=c(2,4), lty=1, pch=c(0,2), bty="n")
```
<img src="figs/lynxhare.png" alt="lynxhare"  width="700" height="400">


&#x1F535; And the land where the LLN ceases to exist:

```r
x <- replicate(100, cumsum(rcauchy(1000))/1:1000)
tsplot(x, col=1:8, main='not happening', spaghetti=TRUE, gg=TRUE, ylab="sample mean", xlab="sample size")
```

<img src="figs/tsplot2.png" alt="tsplot"  width="700" height="400">


&#x1F4A1; There are also lag plots for one series and for two series using

> **`lag1.plot()`** or **`lag2.plot()`**

By default, the graphic displays the sample ACF or CCF and a `lowess` fit.
They can be turned off individually (`?lag1.plot` or `?lag2.plot` for more info).

First,  for one series  

```r
lag1.plot(soi, 12, col=astsa.col(4, .3), pch=20, cex=2)
```
<img src="figs/lag1plot.png" alt="lag1plot"  width="700">

and for two series (the first one gets lagged)

```r
lag2.plot(soi, rec, 8)
```
<img src="figs/lag2plot.png" alt="lag2plot"  width="700">

-----



## 3. Correlations

&#x1F4A1; There are three basic correlation scripts in `astsa`.  They are


> **`acf1()`**, **`acf2()`,** and **`ccf2()`** 

The first one will give the sample ACF or PACF of a series.  The second one gives both the
sample ACF and PACF in a multifigure plot and both on the same scale.  The graphics do not display the lag 0 value because it is always 1.  The third one plots the sample CCF.
The first two also print the values; the third one returns the values invisibly.


&#x1F535; The individual sample ACF or PACF  

```r
acf1(soi)

  [1]  0.60  0.37  0.21  0.05 -0.11 -0.19 -0.18 -0.10  ...
```
<img src="figs/acf1.png" alt="acf1"  width="700" height="400">

```r  
acf1(rec, pacf=TRUE, gg=TRUE, col=2:7, lwd=4)  

   [1]  0.92 -0.44 -0.05 -0.02  0.07 -0.03 -0.03  0.04 ...
```
<img src="figs/pacf1.png" alt="pacf1"  width="700" height="400">

&#x1F535; Sample ACF and PACF at the same time

```r
acf2(diff(log(varve)))  

        [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] ...
   ACF  -0.4 -0.04 -0.06  0.01  0.00  0.04 -0.04  0.04  0.01 ...
   PACF -0.4 -0.24 -0.23 -0.18 -0.15 -0.08 -0.11 -0.05 -0.01 ... 
```
<img src="figs/acf2.png" alt="acf2"  width="700">

&#x1F535; If you just want the values, use `plot=FALSE` (works for `acf1` too)
```r
acf2(diff(log(varve)), plot=FALSE)  

                ACF         PACF
 [1,] -0.3974306333 -0.397430633
 [2,] -0.0444811551 -0.240404406
 [3,] -0.0637310878 -0.228393075
 [4,]  0.0092043800 -0.175778181
 [5,] -0.0029272130 -0.148565114
 [6,]  0.0353209520 -0.080800502

[33,] -0.0516758878 -0.017946464
[34,] -0.0308370865 -0.021854959
[35,]  0.0431050489  0.010867281
[36,] -0.0503025493 -0.068574763
```


&#x1F535; and the sample CCF  

```r
ccf2(cmort, part)
```
<img src="figs/ccf2.png" alt="ccf2"  width="700" height="400">

-----

## 4. ARIMA Simulation

&#x1F4A1; You can simulate data from seasonal ARIMA or non-seasonal ARIMA models via 

> **`sarima.sim()`**

The syntax are simple and we'll demonstrate with a couple of examples. There are more examples in the help file (`?sarima.sim`).  For example, you can input your own innovations or generate non-normal innovations (the default is normal).

&#x1F535; First an AR(2) with a mean of 50 (n=500 is the default sample size)  

```r
y = sarima.sim(ar=c(1.5,-.75)) + 50
tsplot(y, main=expression(AR(2)~~~phi[1]==1.5~~phi[2]==-.75), col=4)
```
<img src="figs/ar2sim.png" alt="ar2sim"  width="700" height="400">

&#x1F535; Now we'll simulate from a seasonal model, `SARIMA(0,1,1)x(0,1,1)`<sub>`12`</sub>  --- B&J's favorite  

```r
set.seed(101010)
x = sarima.sim(d=1, ma=-.4, D=1, sma=-.6, S=12, n=120) + 100
tsplot(x, col=4, lwd=2, gg=TRUE, ylab='Number of Widgets')  
```
<img src="figs/sarima.sim.png" alt="sarima.sim"  width="700" height="400">

-----

## 5. ARIMA Estimation

&#x1F4A1; Fitting ARIMA models to data is a breeze with the modern script

> **`sarima()`**

It can do everything for you but you have to choose the model. 

&#x274C; Don't use black boxes like `auto.arima` from the `forecast` package because IT DOESN'T WORK; see [Issue 2 of the R time series issues page](https://www.stat.pitt.edu/stoffer/tsa4/Rissues.htm). Originally, `astsa` had a version of automatic fitting of models, but IT DOESN'T WORK, so it was scrapped. 
 The bottom line is, here, __AI = As if__, and if you don't know what you're doing, why are you doing it? Maybe a better idea is to [take a short course on fitting ARIMA models to data](https://www.datacamp.com/courses/arima-models-in-r).

As with everything else, there are many examples on the help page (`?sarima`) and we'll do a couple here.

&#x1F535; Everyone else does it, so why don't we.  Here's a seasonal ARIMA fit to the AirPassenger data set (for the millionth time).

```r
sarima(log(AirPassengers),0,1,1,0,1,1,12, gg=TRUE, col=4)
```
and the partial output including the residual diagnostic plot is (`AIC` is basically `aic` divided by the sample size):  

```r
Coefficients:
          ma1     sma1
      -0.4018  -0.5569
s.e.   0.0896   0.0731

sigma^2 estimated as 0.001348:  log likelihood = 244.7,  aic = -483.4

$degrees_of_freedom
[1] 129

$ttable
     Estimate     SE t.value p.value
ma1   -0.4018 0.0896 -4.4825       0
sma1  -0.5569 0.0731 -7.6190       0

$AIC
[1] -3.404219

$AICc
[1] -3.403611

$BIC
[1] -3.343475
```

<img src="figs/airpass.png" alt="airpass"  width="700">

&#x1F535; You can shut off the diagnostics using `details=FALSE` 

```r
 sarima(log(AirPassengers),0,1,1,0,1,1,12, details=FALSE)
```


&#x1F535; You can fix parameters too, for example  

```r
x = sarima.sim( ar=c(0,-.9), n=200 ) + 50 
sarima(x, 2,0,0, fixed=c(0,NA,NA))
```
with output   

```r
Coefficients:
      ar1      ar2    xmean
        0  -0.8829  49.9881
s.e.    0   0.0317   0.0381

sigma^2 estimated as 1.02:  log likelihood = -287.3,  aic = 580.59

$degrees_of_freedom
[1] 198

$ttable
      Estimate     SE   t.value p.value
ar2    -0.8829 0.0317  -27.8093       0
xmean  49.9881 0.0381 1311.6366       0

$AIC
[1] 2.902961

$AICc
[1] 2.903265

$BIC
[1] 2.952436
```

&#x1F535; And one more with exogenous variables - this is the regression
of `Lynx` on `Hare` lagged one year with AR(2) errors.

```r
pp = ts.intersect(Lynx, HareL1 = lag(Hare,-1), dframe=TRUE)
sarima(pp$Lynx, 2,0,0, xreg=pp$HareL1)
```
with partial output

```r
sigma^2 estimated as 59.57:  log likelihood = -312.8,  aic = 635.59

$degrees_of_freedom
[1] 86

$ttable
          Estimate     SE t.value p.value
ar1         1.3258 0.0732 18.1184  0.0000
ar2        -0.7143 0.0731 -9.7689  0.0000
intercept  25.1319 2.5469  9.8676  0.0000
xreg        0.0692 0.0318  2.1727  0.0326

$AIC
[1] 7.062148

$AICc
[1] 7.067377

$BIC
[1] 7.201026
```

<img src="figs/sarimalynxhare.png" alt="sarimalynxhare"  width="700">

-----

## 6. Forecasting

&#x1F4A1;  Forecasting your fitted ARIMA model is as simple as using

> **`sarima.for()`**

You get a graphic showing  ± 1 and 2 root mean square prediction errors and the predictions and standard errors are printed.   The syntax are similar to `sarima` but the 
number of periods to forecast, `n.ahead`, has to be specified.


&#x1F535; Here's a simple example.  We'll generate some data from an ARIMA(1,1,0), forecast some of it and then compare the forecasts to the actual values.

```r
set.seed(12345)
x <- sarima.sim(ar=.9, d=1, n=150)
y <- window(x, start=1, end=100)
sarima.for(y, n.ahead=50, p=1, d=1, q=0, plot.all=TRUE)
text(85, 375, "PAST"); text(115, 375, "FUTURE")
abline(v=100, lty=2, col=4)
lines(x)
```
with partial output  

```r
$pred
Time Series:
Start = 101 
End = 150 
Frequency = 1 
 [1] 242.3821 241.3023 240.5037 239.9545 239.6264 239.4945 239.5364 ...

$se
Time Series:
Start = 101 
End = 150 
Frequency = 1 
 [1]  1.136849  2.427539  3.889295  5.459392  7.096606  8.772528 10.466926 ...  
```
<img src="figs/fore1.png" alt="fore1"  width="700" height="400">

&#x1F535; Notice the `plot.all=TRUE` in the previous example. If you leave that off, the graphic show the final 100 observations and the forecasts to make it easier to see what's going on.

```r
sarima.for(cardox, 60, 1,1,1, 0,1,1,12)
```
<img src="figs/foreCO2.png" alt="foreCO2"  width="700" height="400">


-----
## 7. Spectral Analysis

&#x1F4A1;  There are a few scripts that help with spectral analysis.

The spectral density of an ARMA model can be obtained using

> **`arma.spec()`**

Nonparametric spectral analysis is done with

> **`mvspec()`** 

and parametric spectral analysis with  

> **`spec.ic`**

### ARMA Spectral Density


&#x1F4A1;  `arma.spec` tests for causality, invertibility, and common zeros. If the model is not causal or invertible an error message is given. If there are approximate common zeros, a spectrum will be displayed and a warning will be given; e.g., `arma.spec(ar= .9, ma= -.9)` will yield a warning and the plot will be the spectrum of white noise. For example (the frequency and spectral ordinates are returned invisibly)

```r
arma.spec(ar = c(1.5, -.75), ma = c(-.8,.4), col=4, lwd=2)
```
and the graphic can be on log-scale (`log='y'`) or decibels (`log='dB')`.


<img src="figs/arma_spec.png" alt="arma_spec"  width="700">



### nonparametric spectral analysis

&#x1F4A1; `mvspec` was originally just a way to  get the multivariate spectral density estimate out of `spec.pgram` directly (without additional calculations), but then it turned into its own little monster with different defaults and bandwidth calculations.

&#x1F535; If you want the periodogram, you got it (tapering is not done automatically because you're old enough to do it by yourself):

```r
x1 = 2*cos(2*pi*1:100*5/100)  + 3*sin(2*pi*1:100*5/100)
x2 = 4*cos(2*pi*1:100*10/100) + 5*sin(2*pi*1:100*10/100)
x3 = 6*cos(2*pi*1:100*40/100) + 7*sin(2*pi*1:100*40/100)
x  = x1 + x2 + x3
tsplot(x, col=5, lwd=2, gg=TRUE) 
mvspec(x, col=4, lwd=2, type='o', pch=20)
```

<img src="figs/cosum.png" alt="cosum"  width="700">
<img src="figs/periodogram.png" alt="periodogram"  width="700" height="400">

&#x1F535; You can smooth in the usual way and get the CIs on the log-plot:

```r
par(mfrow=c(2,1))
sois  = mvspec(soi, spans=c(7,7), taper=.1, col=4, lwd=2)
soisl = mvspec(soi, spans=c(7,7), taper=.5, col=4, lwd=2, log='y')
```

<img src="figs/soispec.png" alt="soispec"  width="700">

&#x1F535; and you can get the usual information

```r
c(sois$df, sois$bandwidth)

  [1] 17.4261799  0.2308103
```

and easily locate the peaks

```r
 sois$details[1:45,]

      frequency  period spectrum

 [8,]     0.200  5.0000   0.0461
 [9,]     0.225  4.4444   0.0489
[10,]     0.250  4.0000   0.0502  <- here
[11,]     0.275  3.6364   0.0490
[12,]     0.300  3.3333   0.0451
[13,]     0.325  3.0769   0.0403
[14,]     0.350  2.8571   0.0361

[38,]     0.950  1.0526   0.1253
[39,]     0.975  1.0256   0.1537
[40,]     1.000  1.0000   0.1675  <- here
[41,]     1.025  0.9756   0.1538
[42,]     1.050  0.9524   0.1259
[43,]     1.075  0.9302   0.0972

```
&#x1F535; and cross-spectra  

```r
mvspec(cbind(soi,rec), spans=20, plot.type="coh", ci.lty=2, main="SOI & Recruitment")
```

<img src="figs/coher.png" alt="coher"  width="700" height="400">


### parametric spectral analysis




&#x1F4A1; `spec.ic` is similar to `spec.ar` but the option to use BIC instead of AIC is available.  Also, you can use the script to compare  AIC and BIC for AR fits to the data.

&#x1F535; Based on BIC after detrending (default is using AIC with `BIC=FALSE`)

```r
u <- spec.ic(soi, BIC=TRUE, detrend=TRUE, col=4, lwd=2)  
```

<img src="figs/spec.bic.png" alt="spec.bic"  width="700" height="400">

&#x1F535; Print and plot AIC and BIC (both pick order 15):

```r
u[[1]]   # notice the values are adjusted by the min

      ORDER         AIC        BIC
 [1,]     0 272.6937023 210.955320
 [2,]     1  82.1484043  24.525915
 [3,]     2  84.1441892  30.637592
 [4,]     3  85.5926277  36.201922
 [5,]     4  80.4715619  35.196749
 [6,]     5  70.7822012  29.623280
 [7,]     6  69.5898661  32.546837
 [8,]     7  71.5718647  38.644728
 [9,]     8  71.4320021  42.620757
[10,]     9  63.2815353  38.586183
[11,]    10  49.9872355  29.407775
[12,]    11  40.7220194  24.258451
[13,]    12  41.0928139  28.745138
[14,]    13  37.0833413  28.851557
[15,]    14   8.7779160   4.662024
[16,]    15   0.0000000   0.000000  
[17,]    16   0.4321663   4.548058
[18,]    17   0.8834736   9.115258
[19,]    18   0.9605224  13.308199
[20,]    19   2.9348253  19.398394
[21,]    20   4.7475516  25.327012
[22,]    21   6.7012637  31.396616
[23,]    22   7.1553956  35.966641
[24,]    23   4.6428297  37.569967
[25,]    24   5.8610042  42.904033
[26,]    25   6.5000325  47.658954
[27,]    26   2.8918549  48.166668
[28,]    27   4.2581518  53.648857
[29,]    28   5.5960927  59.102690
[30,]    29   6.3765400  63.999030
[31,]    30   2.6978096  64.436191 
```

```r
tsplot(0:30, u[[1]][,2:3], type='o', col=2:3, xlab='ORDER', nxm=5, lwd=2, gg=TRUE)  
```
<img src="figs/aicbic.png" alt="aicbic"  width="700">


### more multivariate spectra

&#x1F535; The data frame `econ5` was used to consider the effect of quarterly GNP, consumption, and government and private investment on  U.S. unemployment. In this case, `mvspec` will plot the individual spectra by default and you can extract the spectral matrices as `fxx`, an array of dimensions `dim = c(p,p,nfreq)` as well as plot coherencies and phases. Here, <i>p = 5</i>:

```r
gr = diff(log(econ5)) 
gr = scale(gr)  # for comparable spectra
tsplot(gr, ncol=2, col=2:6, lwd=2, byrow=FALSE) 
gr.spec = mvspec(gr, spans=c(7,7), detrend=FALSE, taper=.25, col=2:6, lwd=2, main='spectra')
round(gr.spec$fxx, 2) 
```
<img src="figs/econ5.png" alt="econ5"  width="700">

And a sample of the output of the last line giving the matrix estimate. The numbers at top
refer to frequency ordinate:

```r
, , 49

              [,1]          [,2]          [,3]          [,4]          [,5]
[1,]  0.097+0.000i -0.048+0.042i -0.053+0.080i  0.032-0.037i -0.027+0.033i
[2,] -0.048-0.042i  0.129+0.000i  0.100-0.039i -0.052+0.012i  0.111+0.000i
[3,] -0.053-0.080i  0.100+0.039i  0.232+0.000i -0.041+0.001i  0.023+0.079i
[4,]  0.032+0.037i -0.052-0.012i -0.041-0.001i  0.051+0.000i -0.049+0.008i
[5,] -0.027-0.033i  0.111+0.000i  0.023-0.079i -0.049-0.008i  0.157+0.000i

, , 50

              [,1]          [,2]          [,3]          [,4]          [,5]
[1,]  0.093+0.000i -0.054+0.045i -0.053+0.081i  0.030-0.034i -0.033+0.035i
[2,] -0.054-0.045i  0.124+0.000i  0.112-0.041i -0.048+0.010i  0.100+0.008i
[3,] -0.053-0.081i  0.112+0.041i  0.240+0.000i -0.034+0.009i  0.027+0.085i
[4,]  0.030+0.034i -0.048-0.010i -0.034-0.009i  0.050+0.000i -0.043+0.015i
[5,] -0.033-0.035i  0.100-0.008i  0.027-0.085i -0.043-0.015i  0.146+0.000i

```



-----
## 8. Linearity Test

&#x1F4A1;  Linear time series models are built on the linear process, where it is assumed that a univariate series <i>X<sub>t</sub></i> can be generated as

&emsp;&emsp; <i>X<sub>t</sub> = &mu; + &sum; &psi;<sub>j</sub> Z<sub>t - j</sub></i> where  &sum; | &psi;<sub>j</sub> | < &infin;


where <i>Z<sub>t</sub></i> is a sequence of i.i.d. random variables with at least finite third moments.  This assumption can be tested using the bispectrum, which  is constant under the null hypothesis  that the data are from a linear process with i.i.d. innovations.  The workhorse here is

> **`test.linear()`**

and more details can be found in its help file (`?test.linear`).    Chi-squared test statistics are formed in blocks to measure departures from the null hypothesis and the corresponding p-values are displayed in a graphic and returned invisibly.

&#x1F535; First an example of a linear process where the graphic suggests a constant bispectrum.

```r
test.linear(soi) 
```
<img src="figs/test_soi.png" alt="test_soi"  width="700" height="400">

&#x1F535; Notoriously nonlinear processes are financial series, for example the returns of the New York Stock Exchange (NYSE) from February 2, 1984 to December 31, 1991

```r
test.linear(nyse) 
tsplot(nyse, col=4) 
```
<img src="figs/test_nyse.png" alt="test_nyse"  width="700" height="400">
<img src="figs/nyse.png" alt="nyse"  width="700">

-----

## 9. State Space Models


 &#x1F4A1;  There are a number of levels of Kalman filtering and smoothing in `astsa`. The most basic script is 

> **`ssm()`**


&#x1F535; First, consider a simple univariate model. 
We write the **states** as _x<sub>t</sub>_ and the **observations** as _y<sub>t</sub>_.
 
&emsp;&emsp;_x<sub>t</sub> = &alpha; + &phi; x<sub>t-1</sub> + w<sub>t</sub>_    &nbsp;&nbsp; and &nbsp;&nbsp; _y<sub>t</sub> = A x<sub>t</sub> + v<sub>t</sub>_<br/> 

where  _w<sub>t</sub> ~ iid N(0, &sigma;<sub>w</sub>)_ &perp;   _v<sub>t</sub> ~ iid N(0, &sigma;<sub>v</sub>)_ &perp; _x<sub>0</sub> ~ N(&mu;<sub>0</sub>, &sigma;<sub>0</sub>)_

&#x1F535; We'll fit the model to one of the global temperature series.
To use the script, you have to give initial estimates and then the script fits the model via MLE. The initial values of &mu;<sub>0</sub> and &sigma;<sub>0</sub> are chosen automatically.

```r
u = ssm(gtemp_land, A=1, alpha=.01, phi=1, sigw=.01, sigv=.1)
```
with output (estimates and standard errors) 

```r
        estimate          SE
phi   1.01350314 0.009171042
alpha 0.01270687 0.003749046
sigw  0.04252969 0.010688521
sigv  0.14902612 0.010685375
```

and a nice picture - the data [_y<sub>t</sub>_], the smoothers [ E(_x<sub>t</sub>_ | _y<sub>1</sub> ,..., y<sub>n</sub>_) ] and  &#177;2 root MSPEs.  The smoothers are
in `Xs` and the MSPEs are in `Ps`: 

```r
tsplot(gtemp_land, col=4, type="o", pch=20, ylab="Temperature Deviations")
lines(u$Xs, col=6, lwd=2)
 xx = c(time(u$Xs), rev(time(u$Xs)))
 yy = c(u$Xs-2*sqrt(u$Ps), rev(u$Xs+2*sqrt(u$Ps)))
polygon(xx, yy, border=8, col=gray(.6, alpha=.25) )
```
<img src="figs/ssm.png" alt="ssm"  width="700" height="400">


&#x1F535; You can fix &phi;=1 in this case if you believe the series is taking a random walk with drift:

```r
ssm(gtemp_land, A=1, alpha=.01, phi=1, sigw=.01, sigv=.1, fixphi=TRUE)

##-- output --##
initial  value -79.270104 
iter   2 value -158.182337
iter   3 value -160.835289

iter  17 value -172.310970
iter  18 value -172.312005
iter  19 value -172.326951
iter  20 value -172.326965
iter  20 value -172.326965
iter  20 value -172.326965
final  value -172.326965 
converged

        estimate          SE
alpha 0.01356630 0.004279108
sigw  0.04930987 0.011151130
sigv  0.14727510 0.010881612
```
<br/>

&#x1F535; The output of `ssm()` gives the predictors  [`Xp`] and MSPE [`Pp`], the 
filtered values [`Xf` and `Pf`]  and the smoothers [`Xs` and `Ps`]:

```r
str(u) 

List of 6
 $ Xp: Time-Series [1:138] from 1880 to 2017: -0.591 -0.602 -0.538 -0.511 -0.537 ...
 $ Pp: Time-Series [1:138] from 1880 to 2017: 0.02441 0.01375 0.01053 0.00915 0.00846 ...
 $ Xf: Time-Series [1:138] from 1880 to 2017: -0.606 -0.544 -0.516 -0.543 -0.615 ...
 $ Pf: Time-Series [1:138] from 1880 to 2017: 0.01163 0.00849 0.00714 0.00648 0.00613 ...
 $ Xs: Time-Series [1:138] from 1880 to 2017: -0.595 -0.588 -0.593 -0.607 -0.621 ...
 $ Ps: Time-Series [1:138] from 1880 to 2017: 0.00432 0.0038 0.0035 0.00333 0.00324 ...
 ```

&#x1F535; For general models, there are three levels are called

> **`Kfilter0()/Ksmooth0()`**, **`Kfilter1()/Ksmooth1()`**, **`Kfilter2()/Ksmooth2()`** 

+ For various models, each script provides the 

<ol>
<li> Kalman filter   and/or</li>
<li> Kalman smoother</li>
<li> Innovations and the corresponding variance-covariance matrices</li>
<li> The value of the innovations likelihood at the location of the parameter values passed to the script
</ol>  

+ MLE is  accomplished by calling the script that runs the filter. 

+ Many examples can be found in the Springer text, Chapter 6, and the [R code may be found on the website for the text](https://www.stat.pitt.edu/stoffer/tsa4/Rexamples.htm/) - just expand Chapter 6  

+ Further explanations are also given on a [special page on Kalman filtering and
smoothing](https://www.stat.pitt.edu/stoffer/tsa4/chap6.htm) for the text.

&#x1F535; We'll give an example of using `Kfiler1()` and `Ksmooth1()` on the data set `WBC`, which is the daily white blood cell count of a patient for 3 months. 
There are many missing values after the first month and they are coded as `0` in the data file.  We'll fit a state space model and then display the smoother estimates.
The model is like the previous model,

&emsp;&emsp;_x<sub>t</sub> = &alpha; + &phi; x<sub>t-1</sub> + w<sub>t</sub>_    &nbsp;&nbsp; and &nbsp;&nbsp; _y<sub>t</sub> = A<sub>t</sub> x<sub>t</sub> + v<sub>t</sub>_<br/>

but now _A<sub>t</sub> =_ 0 or 1 depending on whether an observation is missing or not.

```r
y     = WBC
num   = length(y)
A     = ifelse(WBC>0, 1, 0)
A     = array(A, dim=c(1,1,num))  # measurement matrices must be an array
input = rep(1,num)

#  function to calculate likelihood
Linn=function(para){
   phi = para[1]; alpha = para[2];  sigw = para[3];  sigv = para[4]
   kf = Kfilter1(num,y,A,x00,P00,phi,alpha,0,sigw,sigv,input)  # ?Kfilter1 for details
 return(kf$like)  # returns -loglike
}

# Estimation
# initial parameters
phi = 1; alpha = 0;  sigw = .1;  sigv = .01
init.par = c(phi,alpha,sigw,sigv)
x00 = 2     # initial state parameters
P00 = .05   # keep these fixed (not necessary)
est = optim(init.par, Linn, NULL, method="BFGS", hessian=TRUE, control=list(trace=1,REPORT=1)) 
SE = sqrt(diag(solve(est$hessian))) 

 ##--  some output --##
 #  initial  value -213.802860
 #  iter   2 value -301.268549
 #  
 #  iter  27 value -1498.920633
 #  iter  28 value -1566.562235
 #  iter  29 value -1645.965583
 #  iter  29 value -1419.901686
 #  iter  29 value -1479.781053
 #  final  value -1645.9

u = cbind(estimate = est$par, SE)
rownames(u)=c("phi", "alpha", "sigw", "sigv")
round(u,3)

#        estimate    SE
#  phi      0.946 0.028
#  alpha    0.194 0.096
#  sigw     0.160 0.016
#  sigv     0.000 0.000  

phat = u[,1]  # final parameter estimats
# run filter /smoother with estimates
ks = Ksmooth1(num,y,A,x00,P00,phat[1],phat[2],0,phat[3],phat[4],input)

# plot the results - data are solid points, smoothers are blue circles and a line
# gray swatch is 95% pointwise intervals 
tsplot(ks$xs, type='o', col=4, ylim=c(1,5), ylab="WBC", xlab="day")
points(WBC, pch=19)
 xx = c(time(WBC), rev(time(WBC)))
 yy = c(ks$xs-2*sqrt(ks$Ps), rev(ks$xs+2*sqrt(ks$Ps)))
polygon(xx, yy, border=8, col=gray(.6, alpha=.2) )
```

<img src="figs/WBCss.png" alt="WBCss"  width="700" height="400">


## 10. EM Algorithm

&#x1F4A1;  To use the EM algorithm presented in [Shumway & Stoffer (1982)](https://www.stat.pitt.edu/stoffer/dss_files/em.pdf) there are two scripts

> **`EM0()`** and **`EM1()`**

that follow the Kalman filtering scripts, `EM0` does the EM Algorithm for Time Invariant State Space Models, and `EM1` does the EM Algorithm for General State Space Models.

&#x1F535; We'll do an example for the general set up using the data in `blood` containing the daily blood work of a patient for 90 days and where there are many missing observations after the first month.  This is an extension of the 
previous analysis of `WBC`.


```r
tsplot(blood, type='o', col=c(6,4,2), lwd=2, pch=19, cex=1)
```
<img src="figs/blood.png" alt="blood"  width="700">

+ First the set up. 
 
&emsp;&emsp;_x<sub>t</sub> =   &Phi; x<sub>t-1</sub> + w<sub>t</sub>_    &nbsp;&nbsp; and &nbsp;&nbsp; _y<sub>t</sub> = A<sub>t</sub> x<sub>t</sub> + v<sub>t</sub>_ 

where _A<sub>t</sub>_ is 3x3 identity when observed, and 0 matrix when missing.
The errors are  _w<sub>t</sub> ~ iid N<sub>3</sub>(0, Q)_ &perp;   _v<sub>t</sub> ~ iid N<sub>3</sub>(0, V)_ &perp; _x<sub>0</sub> ~ N<sub>3</sub>(&mu;<sub>0</sub>, &Sigma;<sub>0</sub>)_. 




```r
y    = cbind(WBC, PLT, HCT)      # variables in blood with 0s instead of NAs
num  = nrow(y)       
A    = array(0, dim=c(3,3,num))  # creates num 3x3 zero matrices
for(k in 1:num) if (y[k,1] > 0) A[,,k]= diag(1,3) # measurement matrices for observed

```

+ Next, run the EM Algorithm by specifying model parameters. You can specify the max number of iterations and relative tolerance, too.
 
```r
# Initial values 
mu0    = matrix(0,3,1) 
Sigma0 = diag(c(.1,.1,1) ,3)
Phi    = diag(1,3)
cQ     = diag(c(.1,.1,1), 3)
cR     = diag(c(.1,.1,1), 3)  
(em = EM1(num, y, A, mu0, Sigma0, Phi, cQ, cR, 100, .001))    
``` 

Note that, as in the `Kfilter_` and `Ksmooth_` scripts, 
`cQ` and `cR` are the Cholesky-type decompositions of `Q` and `R`. In particular, `Q = t(cQ)%*%cQ` and `R = t(cR)%*%cR` is all that is required (assuming `Q` and `R` are valid covariance matrices).  In this example, the covariance matrix `R` is diagonal, so the elements of `cR` are the standard deviations.

The (partial) output is

```r
iteration    -loglikelihood 
     1           68.28328 
     2          -183.9361 
     3          -194.2051 
     4          -197.5444 
     5          -199.7442 

    20          -220.2935 
    21          -221.1649 
    22          -221.9869 
    23          -222.762 
    24          -223.4924 
    25          -224.1805 
   
    40          -230.6582 
    41          -230.9019 
    42          -231.1289 

# estimates below

$Phi
            [,1]        [,2]        [,3]
[1,]  0.98052698 -0.03494377 0.008287009
[2,]  0.05279121  0.93299479 0.005464917
[3,] -1.46571679  2.25780951 0.795200344

$Q
             [,1]         [,2]       [,3]
[1,]  0.013786772 -0.001724166 0.01882951
[2,] -0.001724166  0.003032109 0.03528162
[3,]  0.018829510  0.035281625 3.61897901

$R
            [,1]      [,2]      [,3]
[1,] 0.007124671 0.0000000 0.0000000
[2,] 0.000000000 0.0168669 0.0000000
[3,] 0.000000000 0.0000000 0.9724247

$mu0
          [,1]
[1,]  2.119269
[2,]  4.407390
[3,] 23.905038

$Sigma0
              [,1]          [,2]          [,3]
[1,]  4.553949e-04 -5.249215e-05  0.0005877626
[2,] -5.249215e-05  3.136928e-04 -0.0001199788
[3,]  5.877626e-04 -1.199788e-04  0.1677365489

$cvg
[1] 0.0009832656  # relative tolerance of -loglikelihood at convergence
```

+ Now  plot the results.

```r
# Run smoother at the estimates
ks  = Ksmooth1(num, y, A, em$mu0, em$Sigma0, em$Phi, 0, 0, chol(em$Q), chol(em$R), 0)

# Pull out the values
y1s = ks$xs[1,,] 
y2s = ks$xs[2,,] 
y3s = ks$xs[3,,]
p1  = 2*sqrt(ks$Ps[1,1,]) 
p2  = 2*sqrt(ks$Ps[2,2,]) 
p3  = 2*sqrt(ks$Ps[3,3,])

# plots 
par(mfrow=c(3,1))
tsplot(WBC, type='p', pch=19, ylim=c(1,5), col=6, lwd=2, cex=1)
lines(y1s) 
  xx = c(time(WBC), rev(time(WBC)))  # same for all
  yy = c(y1s-p1, rev(y1s+p1))
polygon(xx, yy, border=8, col=astsa.col(8, alpha = .1))  

tsplot(PLT, type='p', ylim=c(3,6), pch=19, col=4, lwd=2, cex=1)
lines(y2s)
  yy = c(y2s-p2, rev(y2s+p2))
polygon(xx, yy, border=8, col=astsa.col(8, alpha = .1))  

tsplot(HCT, type='p', pch=19, ylim=c(20,40), col=2, lwd=2, cex=1)
lines(y3s)
  yy = c(y3s-p3, rev(y3s+p3))
polygon(xx, yy, border=8, col=astsa.col(8, alpha = .1))  
```

<img src="figs/blood2.png" alt="blood2"  width="700">


## 11. Arithmetic

&#x1F4A1; The package has a few scripts to help with items related to time series and stochastic processes. 

### ARMAtoAR

&#x1F535;  R `stats` has an `ARMAtoMA` script to help visualize the causal form of a model.  To help visualize the _invertible_ form of a model, `astsa` includes an `ARMAtoAR` script.  For example,
```r
# ARMA(2, 2) in invertible form [rounded for your pleasure]
ARMAtoMA(ar = c(1.5, -.75), ma = c(-.8,.4), 50)

  [1]  0.7000  0.7000  0.5250  0.2625  0.0000 -0.1969 -0.2953 -0.2953 -0.2215 -0.1107
 [11]  0.0000  0.0831  0.1246  0.1246  0.0934  0.0467  0.0000 -0.0350 -0.0526 -0.0526 ...
```
giving some of the &psi;-weights in the _x<sub>t</sub> = &sum;&psi;<sub>j</sub> w<sub>t-j</sub>_ representation of the model (_w<sub>t</sub>_ is white noise). If you want to go the other way, use
```r
ARMAtoAR(ar = c(1.5, -.75), ma = c(-.8,.4), 50) 

  [1] -0.7000 -0.2100  0.1120  0.1736  0.0941  0.0058 -0.0330 -0.0287 -0.0098  0.0037
 [11]  0.0068  0.0040  0.0005 -0.0012 -0.0012 -0.0004  0.0001  0.0003  0.0002  0.0000 ...
```
giving some of the &pi;-weights in the _w<sub>t</sub> = &sum;&pi;<sub>j</sub> x<sub>t-j</sub>_ representation of the model.

&#x1F4A1; As a side note, you can check if a model is causal and invertible using `arma.spec()` from `astsa`, and if you're not careful
```r
arma.spec(ar = c(1.5, -.75), ma = c(-.8,-.4))

  WARNING: Model Not Invertible 
  Error in arma.spec(ar = c(1.5, -0.75), ma = c(-0.8, -0.4)) : Try Again
```

### Matrix Powers

&#x1F535;  I have to compute _Q<sup>-1/2</sup>_ where _Q_ is a variance-covariance matrix  when calculating the [_spectral envelope_](https://projecteuclid.org/journals/statistical-science/volume-15/issue-3/The-spectral-envelope-and-its-applications/10.1214/ss/1009212816.full) so I built in a script called `matrixpwr` that computes powers of a square matrix, including negative powers for nonsingular matrices.
Also, `%^%` is available as a more intuitive operator. For example,

```r
var(econ5)^-.5  # rounded for you pleasure

          unemp   gnp consum govinv prinv
   unemp  0.586 0.036  0.042  0.092 0.094
   gnp    0.036 0.001  0.001  0.003 0.003
   consum 0.042 0.001  0.002  0.004 0.004
   govinv 0.092 0.003  0.004  0.007 0.007
   prinv  0.094 0.003  0.004  0.007 0.007

```

&#x1F535; But also, if you're playing with Markov Chains, you can learn about long run distributions by raising the transition matrix to a large power.  Here's a demonstration of convergence in a 2 state MC:

```r
( P = matrix(c(.7,.5,.3,.5), 2) )  # 1 step transitions
  
       [,1] [,2]
  [1,]  0.7  0.3
  [2,]  0.5  0.5

( P %^% 5 )  # 5 step transitions
  
          [,1]    [,2]
  [1,] 0.62512 0.37488
  [2,] 0.62480 0.37520

( P %^% 50 )  # 50 step transitions

        [,1]  [,2]
  [1,] 0.625 0.375
  [2,] 0.625 0.375
```
_&pi;(1)_ = 5/(3+5) and _&pi;(2)_ = 3/(3+5) and almost there in 5 steps.  

A note - if you use it in an expression, surround the operation with parentheses:
```r
c(.5,.5) %*% (P%^%50)  # toss a coin for initial state (which doesn't matter)

        [,1]  [,2]
  [1,] 0.625 0.375

# but this draws an error because %*% is first
c(1,0) %*% P%^%50
```

### Polynomial Multiplication 

&#x1F535;  The script `sarima.sim` uses `polyMul` when simulating data from seasonal ARIMA models. 
It might help to see what happens with a multiplicative model such as<br/>
_&emsp; &emsp; (1 - 1.5B<sup>1</sup> + .75B<sup>2</sup>)&times;(1 - .9B<sup>12</sup>) x<sub>t</sub>   =w<sub>t</sub>_<br/>
which is an ARIMA(2,0,0)&times;(1,0,0)<sub>12</sub> model.  You can add MA and SMA parts to your liking in the same manner.  Here's the AR polynomial on the left (`ARpoly`) and then the AR coefficients when on the right (`ARparm`):

```r
ar = c(1, -1.5, .75)
sar = c(1, rep(0,11), .9)
AR = polyMul(ar,sar)
( ARpoly = cbind(order=0:14, ARpoly=AR) ) 
  
        order ARpoly
   [1,]     0  1.000
   [2,]     1 -1.500
   [3,]     2  0.750
   [4,]     3  0.000
   [5,]     4  0.000
   [6,]     5  0.000
   [7,]     6  0.000
   [8,]     7  0.000
   [9,]     8  0.000
  [10,]     9  0.000
  [11,]    10  0.000
  [12,]    11  0.000
  [13,]    12  0.900
  [14,]    13 -1.350
  [15,]    14  0.675

( ARparm = cbind(order=1:14, ARparm=-AR[-1]) )
  
       order ARparm
  [1,]     1  1.500
  [2,]     2 -0.750
  [3,]     3  0.000
  [4,]     4  0.000
  [5,]     5  0.000
  [6,]     6  0.000
  [7,]     7  0.000
  [8,]     8  0.000
  [9,]     9  0.000
 [10,]    10  0.000
 [11,]    11  0.000
 [12,]    12 -0.900
 [13,]    13  1.350
 [14,]    14 -0.675
```


