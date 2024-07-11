## astsa &mdash; applied statistical time series analysis

<img src="https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/figs/astsa.gif" alt="&nbsp; &nbsp; ASTSA ..."  height="100">

... more than just data ... it's a palindrome

---

... `astsa` includes data sets and scripts for analyzing time series in both the frequency and time domains including state space modeling as well as supporting the [Springer](https://link.springer.com/book/10.1007/978-3-319-52452-8) text, [Time Series Analysis and Its Applications: With R Examples](https://github.com/nickpoison/tsa4)  and the [Chapman & Hall](https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9780367221096) text  [Time Series: A Data Analysis Approach using R](https://github.com/nickpoison/tsda). 




We do not always push the latest version of the package to CRAN, but [the latest working version of the package will always be at Github](https://github.com/nickpoison/astsa/).

* The [ROAD MAP](https://nickpoison.github.io/) is a good place to start to find all the links to the webpages for the texts and some help on using R for time series analysis. 
* See the [NEWS](https://github.com/nickpoison/astsa/blob/master/NEWS.md) for further details about the state of the package, how to install the latest version, and the changelog.
* __WARNING:__  If loaded, the package `dplyr` may (and probably will) corrupt the base scripts `filter` and `lag` that a time series analyst uses often. An easy fix if you’re analyzing time series (or teaching a class) is to (tell students to) do the following if `dplyr` is being used:

```r
# either detach it
detach(package:dplyr)  

# or fix it yourself if you want dplyr 
# this is a great idea from  https://stackoverflow.com/a/65186251
library(dplyr, exclude = c("filter", "lag"))  # remove the culprits
Lag <- dplyr::lag            # and do what the dplyr ... 
Filter <- dplyr::filter      # ... maintainers refuse to do
# then use `Lag` and `Filter` in dplyr scripts and
# `lag` and `filter` can be use as originally intended

# or just take back the commands
filter = stats::filter
lag = stats::lag
```


* A list of data sets, scripts, and demonstrations of the capabilities of `astsa` can be found  at [FUN WITH ASTSA](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md)...  it's more fun than high school.


* The [code for the graduate level text](https://github.com/nickpoison/tsa5/blob/master/textRcode.md) is here: [TSA5](https://github.com/nickpoison/tsa5/blob/master/textRcode.md).

* The updated [code for the data science text](https://github.com/nickpoison/tsda/blob/master/Rcode.md) is here: [TSDA](https://github.com/nickpoison/tsda/blob/master/Rcode.md).

* Python

   - The [code in the first 3 chapters of the Springer text (ed 4) has been converted to Python here.](https://github.com/borisgarbuzov/tsa4-python/tree/master/src) 

   - And a [Python package that contains datasets from astsa is here.](https://pypi.org/project/astsadata/)







