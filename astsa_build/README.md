
### &#x1D538; &#x1D54A; 	&#x1D54B; &#x1D54A; &#x1D538;  &#9889;   applied statistical time series analysis
... more than just data ... it's a palindrome

---

... `astsa` includes data sets and scripts for analyzing time series in both the frequency and time domains including state space modeling as well as supporting the [Springer](https://link.springer.com/book/10.1007/978-3-031-70584-7) text, [Time Series Analysis and Its Applications: With R Examples](https://github.com/nickpoison/tsa5/blob/main/textRcode.md)  and the [Chapman & Hall](https://www.routledge.com/Time-Series-A-Data-Analysis-Approach-Using-R/Shumway-Stoffer/p/book/9781041031642) text  [Time Series: A Data Analysis Approach using R](https://github.com/nickpoison/tsda/blob/main/Rcode.md).  

Most scripts are designed to require minimal input to produce aesthetically pleasing output for ease of use in live demonstrations and course work.


We do not always push the latest version of the package to CRAN, but [the latest working version of the package will always be at Github](https://github.com/nickpoison/astsa/).

* The [ROAD MAP](https://nickpoison.github.io/) is a good place to start to find all the links to the webpages for the texts and some help on using R for time series analysis. 
* See the [NEWS](https://github.com/nickpoison/astsa/blob/master/NEWS.md) for further details about the state of the package, how to install the latest version, and the changelog.
* [FUN WITH ASTSA](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md) has a list of data sets, scripts, and demonstrations of the capabilities of `astsa` ...  it's more fun than high school. Also, the code for the examples are listed on GitHub:
  * The [code for the graduate level text](https://github.com/nickpoison/tsa5/blob/master/textRcode.md) is here: [TSA5](https://github.com/nickpoison/tsa5/blob/master/textRcode.md).

  * The updated [code for the data science text](https://github.com/nickpoison/tsda2/blob/master/Rcode.md) is here: [TSDA2](https://github.com/nickpoison/tsda2/blob/master/Rcode.md).

* Python

  - The [code in the first 3 chapters of the Springer text (ed 4) has been converted to Python here.](https://github.com/borisgarbuzov/tsa4-python/tree/master/src) 
  - And a [Python package that contains datasets from astsa is here.](https://pypi.org/project/astsadata/) 




---

&#9940; __WARNING:__  If loaded, the package `dplyr` may (and probably will) corrupt the base scripts `filter` and `lag` that a time series analyst uses often. An easy fix if you’re analyzing time series (or teaching a class) is to (tell students to) do the following if `dplyr` is going being used:

```r
# [1] either detach it if it's loaded but no longer needed
detach(package:dplyr)  

# [2] or fix it yourself when loading dplyr 
# this is a great idea from https://stackoverflow.com/a/65186251
library(dplyr, exclude = c("filter", "lag"))   # remove the culprits
dlag    = dplyr::lag                           # then correct ... 
dfilter = dplyr::filter                        # ... the blunders
#  Now use `dlag` and `dfilter` in dplyr scripts and
# `lag` and `filter` can be use as originally intended

# [3] or just take back the commands
filter = stats::filter
lag    = stats::lag
# in this case, you can still use these for dplyr
dlag    = dplyr::lag     
dfilter = dplyr::filter 
```

&#128526; Also, consider that `dplyr` is a MUCH SLOWER and weaker version of `data.table`. So  try [data.table](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html) if you have to do data manipulation. AND, when you load `data.table`, there are ZERO masked warnings!!!  And maybe we can stop having to put warnings about `dplyr` everywhere for time series analysts who want to use R. 

---

---

<br/><br/>







