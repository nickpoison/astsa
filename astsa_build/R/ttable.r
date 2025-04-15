ttable<-
function (obj, digits = 4, vif = FALSE, ...){
   x = stats::summary.lm(obj)
   resid <- x$residuals
   num = length(resid)
   df <- x$df
   rdf <- df[2L]
   aic  =  AIC(obj)/num - log(2*pi)
   bic  =  BIC(obj)/num - log(2*pi)
   ucfactors = FALSE

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
        cat('\n','\nWarning:','Due to perfect multicollinearity, at least \none variable has been kicked out of the regression. \nConsider changing the model and trying again.','\n')
        return(invisible(x))
        .stopquiet()
        }
       }
       if (!is.null(obj$contrasts)){ ucfactors = TRUE; vif = FALSE}
       # check if dummy variables used ##########
      if (attr(x$coef, 'dimnames')[[1]][1] ==  "(Intercept)"){
       tempx = as.matrix(model.matrix(obj)[,-1]) 
      } else { tempx = as.matrix(model.matrix(obj)) }
       for (i in 1:ncol(tempx)){
       if ( sum( tempx[,i] %in% c(0,1)) > 1){
           ucfactors = TRUE; vif = FALSE} 
       } 
#      # check if only one ind variable
#      if (vif){
#        terms <- labels(coef(obj))
#        n.terms <- length(terms)
#       if (n.terms < 2) { 
#         vif = FALSE
#         cat("No VIFs printed because model contains fewer than 2 terms. \n")
#        }
#      }
##################
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
        if (attr(x$coef, 'dimnames')[[1]][1] ==  "(Intercept)"){
             VIF = c(NA,.VIF(obj))} else {VIF = .VIF(obj) } 
        cat("\nCoefficients:\n")
        coefs <- cbind(x$coefficients, VIF)
        if(!is.null(aliased <- x$aliased) && any(aliased)) {
            cn <- names(aliased)
            coefs <- matrix(NA, length(aliased), 5, dimnames=list(cn, colnames(coefs), ' VIF'))
            coefs[!aliased, ] <- cbind(x$coefficients, VIF)
        }
        }
        print(round(coefs,digits), na.print = " ", ... )  
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
        cat('AIC = ',  round(aic,  digits+1), '  ',
            'AICc = ', round(aicc, digits+1), '  ', 
            'BIC = ',  round(bic,  digits+1), '\n') 
    }
    correl <- x$correlation
    if (!is.null(correl)) {
	p <- NCOL(correl)
	if (p > 1L) {
	    cat("\nCorrelation of Coefficients:\n")
	    if(is.logical(symbolic.cor) && symbolic.cor) {# NULL < 1.7.0 objects
		print(symnum(correl, abbr.colnames = NULL))
	    } else {
                correl <- format(round(correl, 2), nsmall = 2, digits = digits)
                correl[!lower.tri(correl)] <- ""
                print(correl[-1, -p, drop=FALSE], quote = FALSE)
            }
	}
    }
    if (ucfactors) cat('\nNote:','No VIFs are printed because the model includes factors.')
    cat("\n")#- not in S
    invisible(x)
}




.VIF <- function (obj) 
{
  if (any(is.na(coef(obj)))) 
    stop("There are aliased coefficients in the model.")
  v <- vcov(obj)
  assign <- attr(model.matrix(obj), "assign")
    Intrcpt = FALSE
  if (names(coefficients(obj)[1]) == "(Intercept)") {
    v <- v[-1, -1]
    assign <- assign[-1]
    Intrcpt = TRUE
  }
  else warning("No intercept: VIFs may not be sensible.")
#
  modmat = model.matrix(obj)
  if (Intrcpt){
  terms <- colnames(modmat[,-1])
  n.terms <- ncol(modmat) -1 
  } else {
  terms <- colnames(modmat)
  n.terms <- ncol(modmat)
} 
#
  if (n.terms < 2) {
     cat("No VIFs printed because model contains fewer than 2 terms. \n")
     return(NA); .stopquiet()
  }
  R <- cov2cor(v)
  detR <- det(R)
  result <- c()#matrix(0, n.terms, 3)
#  rownames(result) <- terms
 # colnames(result) <- c("GVIF", "Df", "GVIF^(1/(2*Df))")
  for (term in 1:n.terms) {
    subs <- which(assign == term)
    result[term]  <- det(as.matrix(R[subs, subs])) * det(as.matrix(R[-subs, -subs]))/detR
    #result[term, 2] <- length(subs)
  }
#   if (all(result[, 2] == 1)) 
#    result <- result[, 1]
#    else result[, 3] <- result[, 1]^(1/(2 * result[, 2]))
  return(result)
}


.stopquiet <- function() {  
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}


# remove me
#.VIF_orig <- function (mod) 
#{
#  if (any(is.na(coef(mod)))) 
#    stop("there are aliased coefficients in the model")
#  v <- vcov(mod)
#  assign <- attr(model.matrix(mod), "assign")
#  if (names(coefficients(mod)[1]) == "(Intercept)") {
#    v <- v[-1, -1]
#    assign <- assign[-1]
#  }
#  else warning("No intercept: vifs may not be sensible.")
#  terms <- labels(terms(mod))
#  n.terms <- length(terms)
#  if (n.terms < 2) 
#    stop("model contains fewer than 2 terms")
#  R <- cov2cor(v)
#  detR <- det(R)
#  result <- matrix(0, n.terms, 3)
#  rownames(result) <- terms
#  colnames(result) <- c("GVIF", "Df", "GVIF^(1/(2*Df))")
#  for (term in 1:n.terms) {
#    subs <- which(assign == term)
#    result[term, 1] <- det(as.matrix(R[subs, subs])) * det(as.matrix(R[-subs, 
#                                                                       -subs]))/detR
#    result[term, 2] <- length(subs)
#  }
#  if (all(result[, 2] == 1)) 
#    result <- result[, 1]
#  else result[, 3] <- result[, 1]^(1/(2 * result[, 2]))
#  result
#}