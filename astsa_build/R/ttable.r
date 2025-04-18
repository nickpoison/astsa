ttable<-
function (obj, digits = 4, vif = FALSE, ...){
   x = stats::summary.lm(obj)
   resid <- x$residuals
   num = length(resid)
   df <- x$df
   rdf <- df[2L]
   aic  =  AIC(obj)/num - log(2*pi)
   bic  =  BIC(obj)/num - log(2*pi)
############################### for nicer display
   dimnames(x$coefficients) <- list(dimnames(x$coefficients)[[1]], 
            c("Estimate", "     SE", " t.value", " p.value"))
##############################
    if (length(x$aliased) == 0L) { 
        cat("\nNo Coefficients\n")
    } else {
       if (nsingular <- df[3L] - df[1L]){
        cat("\nCoefficients: (", nsingular,  " not defined because of singularities)\n", sep = "")
        coefs <- cbind(x$coefficients)
        if(!is.null(aliased <- x$aliased) && any(aliased)) {
            cn <- names(aliased)
            coefs <- matrix(NA, length(aliased), 4, dimnames=list(cn, colnames(coefs)))
            coefs[!aliased, ] <- cbind(x$coefficients)
            print(round(coefs, digits), ... ) 
        cat("\nResidual standard error:",
        format(signif(x$sigma, digits)), "on", rdf, "degrees of freedom")
        cat("\n")
        if(nzchar(mess <- naprint(x$na.action))) cat("  (",mess, ")\n", sep = "")
        if (!is.null(x$fstatistic)) {
        cat("Multiple R-squared: ", formatC(x$r.squared, digits = digits))
        cat(",\tAdjusted R-squared: ",formatC(x$adj.r.squared, digits = digits),
        "\nF-statistic:", formatC(x$fstatistic[1L], digits = digits),
         "on", x$fstatistic[2L], "and",
        x$fstatistic[3L], "DF,  p-value:",
        format.pval(pf(x$fstatistic[1L], x$fstatistic[2L],
                           x$fstatistic[3L], lower.tail = FALSE),
                        digits = digits)) }
        cat('\n','\nWarning:','Due to perfect multicollinearity, at least \none variable has been kicked out of the regression. \nConsider changing the model and trying again.','\n')
        return(invisible(x))
        .stopquiet()
        }
       }
# check if only one predictor
   if (vif){  
       Xterms <- labels(coef(obj))
       n.Xterms <- length(Xterms) - ("(Intercept)" %in% Xterms)
      if (n.Xterms < 2) { 
        vif = FALSE
        cat("No VIFs printed because the model has only one predictor. \n")
       }
   }


       if (!vif) {
        cat("\nCoefficients:\n")
        coefs <- cbind(x$coefficients)

        if(!is.null(aliased <- x$aliased) && any(aliased)) {
            cn <- names(aliased)
            coefs <- matrix(NA, length(aliased), 4, dimnames=list(cn, colnames(coefs)))
            coefs[!aliased, ] <- cbind(x$coefficients)
            print(round(coefs,digits), ... ) 
        cat("\nResidual standard error:",
        format(signif(x$sigma, digits)), "on", rdf, "degrees of freedom")
        cat("\n")
        if(nzchar(mess <- naprint(x$na.action))) cat("  (",mess, ")\n", sep = "")
        if (!is.null(x$fstatistic)) {
        cat("Multiple R-squared: ", formatC(x$r.squared, digits = digits))
        cat(",\tAdjusted R-squared: ",formatC(x$adj.r.squared, digits = digits),
        "\nF-statistic:", formatC(x$fstatistic[1L], digits = digits),
         "on", x$fstatistic[2L], "and",
        x$fstatistic[3L], "DF,  p-value:",
        format.pval(pf(x$fstatistic[1L], x$fstatistic[2L],
                           x$fstatistic[3L], lower.tail = FALSE),
                        digits = digits)) }
        }
       }
        else {
        if ("(Intercept)" %in% labels(coef(obj))){
             VIF = c(NA, .VIF(obj))} else {VIF = .VIF(obj) } 
        cat("\nCoefficients:\n")
        coefs <- cbind(x$coefficients, NA, VIF)
        if(!is.null(aliased <- x$aliased) && any(aliased)) {
            cn <- names(aliased)
            coefs <- matrix(NA, length(aliased), 5, dimnames=list(cn, colnames(coefs), ' VIF'))
            coefs[!aliased, ] <- cbind(x$coefficients, VIF)
        }
        }
        print(round(coefs, digits), na.print = " ", ... )  
    }
    k = nrow(coefs)
    aicc = ( num*aic + ((2*k^2+2*k)/(num-k-1)) )/num
    ##
    cat("\nResidual standard error:",
	format(signif(x$sigma, digits)), "on", rdf, "degrees of freedom")
    cat("\n")
    if(nzchar(mess <- naprint(x$na.action))) cat("  (",mess, ")\n", sep = "")
    if (!is.null(x$fstatistic)) {
	cat("Multiple R-squared: ", formatC(x$r.squared, digits = digits))
	cat(",\tAdjusted R-squared: ",formatC(x$adj.r.squared, digits = digits),
	    "\nF-statistic:", formatC(x$fstatistic[1L], digits = digits),
	    "on", x$fstatistic[2L], "and",
	    x$fstatistic[3L], "DF,  p-value:",
	    format.pval(pf(x$fstatistic[1L], x$fstatistic[2L],
                           x$fstatistic[3L], lower.tail = FALSE),
                        digits = digits))
        cat("\n")
        cat('AIC = ',  round(aic,  digits), '  ',
            'AICc = ', round(aicc, digits), '  ', 
            'BIC = ',  round(bic,  digits), '\n') 
    }
    cat("\n")
    invisible(x)
}


.VIF = function(obj){
   varX = vcov(obj)
   if ("(Intercept)" %in% labels(coef(obj))) { varX = varX[-1,-1] } else 
       { cat("VIFs may not make sense if there is no intercept.\n") }
   corX = cov2cor(varX)
   return(diag(solve(corX)))
}


.stopquiet <- function() {  
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}
