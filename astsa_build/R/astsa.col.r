astsa.col <- function(col=1, alpha=1, wheel=FALSE, pie=FALSE, num) {  
  if (!wheel){
   u <- c("black","#F6483C","#00BA38","#1874cd","#0D9AC0","#cd1874","#CD7118","gray62")
   culers = u[(col+7)%%8 + 1]
   culers = adjustcolor(culers, alpha.f=alpha)
   if (pie){ pie(rep(1,length(col)), col=culers) }
   return(culers)
  } else {  # make wheel
   if (missing(num)) num = readline(prompt="How many colors do you want? ")
   num = as.integer(num)
   hsv = rgb2hsv(col2rgb(col))
    h   = hsv[1]
    s   = hsv[2]
    v   = hsv[3]
   hues = seq(h, h + 1, by=1/num)[1:num] %% 1
   culers = adjustcolor(hsv(hues, s, v, alpha=alpha))
   if (pie){ pie(rep(1,num), col=culers) }
   return(culers)
  }
}
