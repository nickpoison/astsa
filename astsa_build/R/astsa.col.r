astsa.col <- 
function(col=1, alpha=1, wheel=FALSE, pie=FALSE, num, sat=NULL, val=NULL){  
  if (!wheel){
   u <- c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62")
   culers = u[(col+7)%%8 + 1]
   culers = adjustcolor(culers, alpha.f=alpha)
   if (pie){ pie(rep(1,length(col)), col=culers) }
   invisible(culers)
  } else {  # make wheel
   if (missing(num)) num = readline(prompt="How many colors do you want? ")
   num = as.integer(num)
   hsv = rgb2hsv(col2rgb(col))
    h   = hsv[1]
    s   = ifelse(is.null(sat), hsv[2], sat %% 1)
    v   = ifelse(is.null(val), hsv[3], val %% 1)
   hues = seq(h, h + 1, by=1/num)[1:num] %% 1
   culers =  hsv(hues, s, v, alpha=alpha)
   if (pie){ pie(rep(1,num), col=culers) }
   invisible(culers)
  }
}

