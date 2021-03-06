# astsa vignette


##### we'll demonstrate some of the capabilities of `astsa` ... if you haven't installed it yet, [head over to the News page for installation instructions](https://github.com/nickpoison/astsa/blob/master/NEWS.md).

Remember to load `astsa` at the start of a session.

> **`library(astsa)`**

-----
------
 
### Table of Contents  
  * [1. Data](#1-data)
  * [2. Plotting](#2-plotting)
  * [3. Correlations](#3-correlations)
  * [4. ARIMA Simulation](#4-arima-simulation)
  * [5. ARIMA Estimation](#5-arima-estimation)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>





-----
-----



## 1. Data  

There are lots of fun data sets included in `astsa`. Here's a list obtained by issuing the command

> **`data(package = "astsa")`**

And you can get more information on any individual set using the `help()` command, e.g.
`help(cardox)` or `?cardox`

-----
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

 - When `astsa` is loaded, the astsa palette is attached.  The palette is  especially  suited for plotting  time series and it is a bit darker than the new default R4 palette. You can revert back using  `palette("default")`.  Also,  

> **`astsa.col()`** 

is included to easily adjust opacity of the palette.  For example,
```r
par(mfrow=c(3,1))
barplot(rep(1,8), col=1:8, main='astsa palette', names=1:8)
barplot(rep(1,8), col=astsa.col(1:8, .7), main='transparency', names=1:8)
barplot(rep(1,8), col=astsa.col(3:6, .5), main='pastelity', names=rep(3:6, 2))
```
<img src="figs/palette.png" alt="palette"  width="700">

- For plotting time series and just about anything else, you can use

> **`tsplot()`**

Notice there are minor ticks and a grid by default. Here are some examples.
<pre><code>
par(mfrow=c(2,1))
tsplot(soi, col=4, lwd=2)
tsplot(soi, col=4, lwd=2, gg=TRUE)
</code></pre>
<img src="figs/tsplot1.png" alt="tsplot"  width="700">

Two at a time:
<pre><code>
tsplot(cbind(mortality=cmort, particulates=part), col=4:5, lwd=2, main='LA Pollution')
</code></pre>
<img src="figs/lapollution.png" alt="lapollution"  width="700">


Do you like spaghetti?
<pre><code>
tsplot(cbind(Hare,Lynx), col=astsa.col(c(2,4),.5), lwd=2, type="o", pch=c(0,2), ylab=expression(Number~~~(""%*% 1000)), spaghetti=TRUE)
legend("topright", legend=c("Hare","Lynx"), col=c(2,4), lty=1, pch=c(0,2), bty="n")
</code></pre>
<img src="figs/lynxhare.png" alt="tsplot"  width="700">
<pre><code>
x <- replicate(100, cumsum(rcauchy(1000))/1:1000)
tsplot(x, col=1:8, main='not happening', spaghetti=TRUE, gg=TRUE, ylab="sample mean", xlab="sample size")
</code></pre>
<img src="figs/tsplot2.png" alt="tsplot"  width="700">



-----



## 3. Correlations

There are three basic correlation scripts in `astsa`.  They are


> **`acf1()`**, **`acf2()`,** and **`ccf2()`** 

The first one will give the sample ACF or PACF of a series.  The second one gives both the
sample ACF and PACF in a multifigure plot and both on the same scale.  The graphics do not display the lag 0 value because it is always 1.  The third one plots the sample CCF.
The first two also print the values; the third one returns the values invisibly.


+ The individual sample ACF or PACF
<pre><code>
acf1(soi)
</code></pre>
and output

```diff
+  [1]  0.60  0.37  0.21  0.05 -0.11 -0.19 -0.18 -0.10  ...
```
<img src="figs/acf1.png" alt="acf1"  width="700">

<pre><code>
acf1(rec, pacf=TRUE, gg=TRUE, col=2:7, lwd=4)
  
[1]  0.92 -0.44 -0.05 -0.02  0.07 -0.03 -0.03  0.04 ...
</code></pre>
<img src="figs/pacf1.png" alt="pacf1"  width="700">

+ Sample ACF and PACF at the same time
<pre><code>
acf2(diff(log(varve)))

        [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] ...
   ACF  -0.4 -0.04 -0.06  0.01  0.00  0.04 -0.04  0.04  0.01 ...
   PACF -0.4 -0.24 -0.23 -0.18 -0.15 -0.08 -0.11 -0.05 -0.01 ... 
</code></pre>
<img src="figs/acf2.png" alt="acf2"  width="700">

+ and the sample CCF
<pre><code>
ccf2(cmort, part)
</code></pre>
<img src="figs/ccf2.png" alt="ccf2"  width="700">

-----

## 4. ARIMA Simulation

You can simulate data from seasonal ARIMA or non-seasonal ARIMA models via 

> **`sarima.sim()`**

The syntax are simple and we'll demonstrate with a couple of examples. There are more examples in the help file (`?sarima.sim`).  For example, you can input your own innovations or generate non-normal innovations (the default is normal).

+ First an AR(2) with a mean of 50 (n=500 is the default sample size)
<pre><code>
y = sarima.sim(ar=c(1.5,-.75)) + 50
tsplot(y, main=expression(AR(2)~~~phi[1]==1.5~~phi[2]==-.75), col=4)
</code></pre>
<img src="figs/ar2sim.png" alt="ar2sim"  width="700">

+ Now we'll simulate from a seasonal model, `SARIMA(0,1,1)x(0,1,1)`<sub>`12`</sub>  --- B&J's favorite
<pre><code>
set.seed(101010)
tsplot(sarima.sim(d=1, ma=-.4, D=1, sma=-.6, S=12, n=120), col=4, ylab='')  
</code></pre>
<img src="figs/sarima.sim.png" alt="sarima.sim"  width="700">

-----

## 5. ARIMA Estimation

Fitting ARIMA models to data is a breeze with the modern script

> **`sarima()`**

It can do everything for you but you have to choose the model. 

Don't use black boxes like `auto.arima` from the `forecast` package because IT DOESN'T WORK; see [Issue 2 of the R time series issues page](https://www.stat.pitt.edu/stoffer/tsa4/Rissues.htm). Originally, `astsa` had a version of automatic fitting of models, but IT DOESN'T WORK, so it was scrapped.  The bottom line is, if you don't know what you're doing, then why are you doing it? Maybe a better idea is to [take a short course on fitting ARIMA models to data](https://www.datacamp.com/courses/arima-models-in-r).

As with everything else, there are many examples on the help page (`?sarima`) and we'll do a couple here.

+ Everyone else does it, so why don't we.  Here's a seasonal ARIMA fit to the AirPassenger data set (for the millionth time).

<pre><code>
sarima(log(AirPassengers),0,1,1,0,1,1,12, gg=TRUE, col=4)
</code></pre>
and the partial output including the residual diagnostic plot is:
<pre>
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
</pre>

<img src="figs/airpass.png" alt="airpass"  width="700">

You can shut off the diagnostics using `details=FALSE`
<pre><code>
 sarima(log(AirPassengers),0,1,1,0,1,1,12, details=FALSE)
</code></pre>


+ You can fix parameters too, for example
<pre><code>
x = sarima.sim( ar=c(0,-.9), n=200 ) + 50 
sarima(x, 2,0,0, fixed=c(0,NA,NA))
</code></pre> 
with partial output
<pre>
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
</pre>

+ And one more with exogenous variables - this is the regression
of `Lynx` on `Hare` lagged one year with AR(2) errors.

<pre><code>
pp = ts.intersect(Lynx, HareL1 = lag(Hare,-1), dframe=TRUE)
sarima(pp$Lynx, 2,0,0, xreg=pp$HareL1)
</code></pre>
with partial output
<pre>

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
</pre>

<img src="figs/sarimalynxhare.png" alt="sarimalynxhare"  width="700">






