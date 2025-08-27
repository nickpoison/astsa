timex <- function(xts.object){

  is.xts = ifelse("xts" %in% class(xts.object), TRUE, FALSE)
  if (!is.xts) stop("object is not an 'xts' object")  

  tzone  = attr(xts.object, 'tzone')
  dates  = as.POSIXct(attr(xts.object, 'index'), tz=tzone) 
  year   = as.numeric(format(dates, "%Y"))
  day    = as.numeric(format(dates, "%j"))
  leap   = ifelse(year%%100==0, year%%400==0, year%%4==0)
  tot    = ifelse(leap, 366, 365)
  Time   = year + day / tot
  invisible(Time)
}
