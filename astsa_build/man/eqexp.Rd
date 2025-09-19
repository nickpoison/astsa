\name{eqexp}
\alias{eqexp}
\docType{data}
\title{Earthquake and Explosion Seismic Series
} 
\description{This is a data frame of the earthquake and explosion seismic series used throughout the text. 
}
\format{
  A data frame with 2048 observations (rows) on  17 variables (columns).  Each column is a numeric vector.
}
\references{You can find demonstrations of  astsa capabilities at  
\href{https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md}{FUN WITH ASTSA}.

The most recent version of the package can be found  at \url{https://github.com/nickpoison/astsa/}.

In addition, the News and ChangeLog files are at  \url{https://github.com/nickpoison/astsa/blob/master/NEWS.md}.

The webpages for the texts and some help on using R for time series analysis can be found at
 \url{https://nickpoison.github.io/}.  
}
\details{The matrix has 17 columns, the first eight are earthquakes, the second eight are explosions, and the last column is the Novaya Zemlya event of unknown origin.  

The column names are: \code{EQ1, EQ2,...,EQ8; EX1, EX2,...,EX8; NZ}.  The first 1024 observations correspond to the P wave, the second 1024 observations correspond to the S wave.

All events in the data set were on or near  land and were distributed uniformly over Scandinavia so as to minimize  the possibility  that discriminators might be keying on location or land-sea differences. The events are earthquakes ranging in magnitude from 2.74 to 4.40 and explosions   in the range 2.13 to 2.19. Also added is an event of uncertain  origin that was located in the Novaya Zemlya region  of  Russia. All events  except the Russian  event occurred in  the Scandinavian peninsula and were recorded by seismic arrays located in Norway  by  Norwegian  and Arctic experimental seismic stations  (NORESS,  ARCESS)  and in Finland by Finnish experimental seismic stations (FINESS).

\tabular{rrrrrrr}{
No.\tab Type\tab Date\tab Array \tab Magnitude \tab   Latitude \tab   Longitude \cr
1  \tab EQ \tab 6/16/92 \tab  FINESS\tab  3.22\tab 65.5\tab  22.9 \cr
2  \tab EQ \tab 8/24/91 \tab  ARCESS\tab  3.18\tab 65.7\tab  32.1 \cr
3  \tab EQ \tab 9/23/91 \tab  NORESS\tab  3.15\tab 64.5\tab  21.3 \cr
4  \tab EQ \tab 7/4/92  \tab  FINESS\tab  3.60\tab 67.8\tab  15.1 \cr
5  \tab EQ \tab 2/19/92 \tab  ARCESS\tab  3.26\tab 59.2\tab  10.9 \cr
6  \tab EQ \tab 4/13/92 \tab  NORESS\tab  4.40\tab 51.4\tab  6.1  \cr
7  \tab EQ \tab 4/14/92 \tab  NORESS\tab  3.38\tab 59.5\tab  5.9  \cr
8  \tab EQ \tab 5/18/92 \tab  NORESS\tab  2.74\tab 66.9\tab  13.7 \cr
9  \tab EX \tab 3/23/91 \tab  ARCESS\tab  2.85\tab 69.2\tab  34.3 \cr
10 \tab EX \tab 4/13/91 \tab  FINESS\tab  2.60\tab 61.8\tab  30.7 \cr
11 \tab EX \tab 4/26/91 \tab  ARCESS\tab  2.95\tab 67.6\tab  33.9 \cr
12 \tab EX \tab 8/3/91  \tab  ARCESS\tab  2.13\tab 67.6\tab  30.6 \cr
13 \tab EX \tab 9/5/91  \tab  ARCESS\tab  2.32\tab 67.1\tab  21.0 \cr
14 \tab EX \tab 12/10/91\tab  FINESS\tab  2.59\tab 59.5\tab  24.1 \cr
15 \tab EX \tab 12/29/91\tab  ARCESS\tab  2.96\tab 69.4\tab  30.8 \cr
16 \tab EX \tab 3/25/92 \tab  NORESS\tab  2.94\tab 64.7\tab  30.8 \cr
17 \tab NZ \tab 12/31/92\tab  NORESS\tab  2.50\tab 73.6\tab  55.2 \cr
}
}
\examples{
# view all series 
# first 2 rows EQs - next 2 rows EXs
# 5th row NZ event 

tsplot(eqexp, ncol=4, col=c(rep(6,8),rep(4,8),2), scale=.75)

\dontrun{

# for a nice html map, use the 'leaflet' package

library(leaflet)   # install if you don't have it

lat = c(
65.5,65.7,64.5,67.8,59.2,51.4,59.5,66.9,
69.2,61.8,67.6,67.6,67.1,59.5,69.4,64.7,
73.6)

long = c(
22.9,32.1,21.3,15.1,10.9,6.1,5.9,13.7,
34.3,30.7,33.9,30.6,21.0,24.1,30.8,30.8,
55.2)

event = c(
"EQ","EQ","EQ","EQ","EQ","EQ","EQ","EQ",
"EX","EX","EX","EX","EX","EX","EX","EX",
"NZ")


eventmap = data.frame(
  longitude = long,
  latitude = lat,
  event = event )

leaflet(eventmap) \%>\%
  addTiles() \%>\% 
  addMarkers(~longitude, ~latitude, label = ~event,
    labelOptions = labelOptions(noHide = TRUE))

}
}
\keyword{datasets}


