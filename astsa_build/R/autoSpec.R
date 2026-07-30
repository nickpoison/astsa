#########################################################################################

##-- autoSpec 

# PopSize: population size. The number of chromosomes in each generation
# Generation: Number of iterations
# m0   = Maximum width of kernel is 2*m0+1 - see '?bart()' 
# Pi.P = Probability of taking parent's gene in mutation
# Pi.N = Probability of taking -1 in mutation
# Pi.B = Probability of being a break point in initial stage, default to 10/n
# Pi.C = Probability of conducting crossover, default to (n-10)/n
# NI   = number if islands
# taper = half width of taper; .5 is full taper
# min.freq, max.freq => frequency range is (min.freq, max.freq) with default (0, .5)


autoSpec <-
function(xdata, Pi.B = NULL, Pi.C = NULL, PopSize = 70, generation = 70, m0 = 10, 
         Pi.P = 0.3, Pi.N = 0.3, NI = 7, taper = .5, min.freq = 0, max.freq = .5){

if (NCOL(xdata) > 1) stop("univariate time series only")
xdata = c(xdata)  # remove ts attributes if there
n     = length(xdata)
if (n < 100) stop('sample size should be at least 100')
if (is.null(Pi.B)) Pi.B = 10/n
if (is.null(Pi.C)) Pi.C = (n-10)/n
if (m0 > 20) {m0=20; cat("m0 has been reset to 20 \n")}

# find breakpoints
brkpts  = .GA(xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq)

# optimal orders
u    = c(brkpts, n)
npts = length(brkpts)
kmdl = c()
bst  = c()

# frequency-index bounds used for the unsmoothed periodogram - mirrors the clipping
# done inside .MDL.individual so the reused periodogram lines up with what it would
# have computed itself
mf.min = max(min.freq, 0)
mf.max = min(max.freq, .5)

for (i in 1:npts){
  strt = u[i]
  endd = u[i+1]-1
  if (i == npts) endd = endd+1
  data.piece = xdata[strt:endd]
  m00 = ifelse((endd-strt) < 2*m0, floor(.5*(endd-strt+1)), m0)

  # the unsmoothed periodogram doesn't depend on the kernel order k, so compute it
  # once per segment instead of once per candidate order tested below
  strt.f = max(1, ceiling(length(data.piece)*mf.min))
  endd.f = floor(length(data.piece)*mf.max)
  per0   = mvspec(c(data.piece), plot=FALSE, demean=TRUE, detrend=FALSE)$spec[strt.f:endd.f]

  for( k in 0:m00 ) { 
   kmdl[k+1] = .MDL.individual(data.piece,k,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,
                               Pi.P,Pi.N,NI,taper,min.freq,max.freq,per=per0) 
   }  
  bst[i] = which.min(kmdl)-1
}

# return
cat('returned breakpoints include the endpoints', '\n')
return(list(breakpoints=u, number_of_segments=npts,segment_kernel_orders_m=bst))
}

#This is the overall GA function
.GA = function(xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq)
{
 gene.parent = vector("list", NI)                #Stores Chromosomes
 gene.child = vector("list", NI)                 #Stores Chromosomes
 S.parent = matrix(0, nrow = NI, ncol = PopSize)      #Stores MDL
 S.child = matrix(0, nrow = NI, ncol = PopSize)       #Stores MDL
 rank.child = matrix(0, nrow = NI, ncol = PopSize)
 gene.best = vector("list", generation)
 for(i in 1:NI){           #Generate all initial generation for all islands
   gene.parent[[i]] = .Initial(xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,
                               taper,min.freq,max.freq)
   S.parent[i,] = apply(gene.parent[[i]], 1, function(j) .MDL.total(xdata,j,n,Pi.B,Pi.C,
         PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq))
 }

 #Generates the next generation
 pb = txtProgressBar(min=1, max=generation, style=2)  # progress bar - created once, not per-generation
 for(k in 1:generation){   #For each next generation
  for(i in 1:NI){      #For each island
    #.generate() is handed the already-computed parent fitness (S.parent[i,]) instead
    #of recomputing it internally via another full pass of .MDL.total()
    gene.child[[i]] = .generate(gene.parent[[i]],S.parent[i,],xdata,n,Pi.B,Pi.C,PopSize,
                                generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq)
    S.child[i,] = apply(gene.child[[i]], 1, function(j) .MDL.total(xdata,j,n,Pi.B,Pi.C,
                        PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq))
  }
  min.index = which(S.child == min(S.child), arr.ind = TRUE)  
  gene.best[[k]] = gene.child[[min.index[1]]][min.index[2], ]
  #Only comparing first and last of 20,
  if(k > 20 && .MDL.total(xdata,gene.best[[k]],n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,
                 Pi.N,NI,taper,min.freq, max.freq) == .MDL.total(xdata,gene.best[[k-20]],n,Pi.B,
                 Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq)) break  
  gene.parent = gene.child
  S.parent = S.child

    #Migration
if(k %% 5 == 0){
  elite.list = matrix(0, nrow = NI, ncol = 5)  #Index
  poor.list = matrix(0, nrow = NI, ncol = 5)   #Index
  for(j in 1:NI){
    elite.list[j,] = order(S.parent[j,])[1:5]
    poor.list[j,] = order(S.parent[j,], decreasing = T)[1:5]
  }
  for(move in 1:(NI-1)){
    gene.parent[[move+1]][poor.list[(move+1),],] = gene.parent[[move]][elite.list[move,],]
  }
  gene.parent[[1]][poor.list[1,],] = gene.parent[[NI]][elite.list[NI,],]
}
setTxtProgressBar(pb,k)
  }
close(pb)

break.locations = which(gene.best[[k]]!=-1)
return(break.locations)
}

.MinSpan = c(10,10,12,14,16,18,20,rep(25,4),rep(50,10))

   #Setting up initial generation of chromosomes
   #Rewritten with a while-loop that genuinely jumps the index forward past positions
   #already known to be -1 (the previous for-loop visited every position one at a time
   #regardless, since reassigning the for-loop variable in R does not skip iterations)
.Initial=function(xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,taper,min.freq,max.freq)  
{
  Ini=matrix(0,nrow=PopSize,ncol=n)
  last = n - 50
  for(i in 1:PopSize){
    ord = sample(seq(1,m0,1),1)
    Ini[i,1] = ord
    span = .MinSpan[ord+1]
    if (span > 1) Ini[i,2:span] = -1
    t = span + 1
    while (t <= last) {
      r = runif(1,0,1)
      if (r < Pi.B) {
        ord = sample(seq(1,m0,1),1)
        Ini[i,t] = ord
        span = .MinSpan[ord+1]
        if (span > 1) Ini[i,(t+1):(t+span-1)] = -1
        t = t + span
      } else {
        Ini[i,t] = -1
        t = t + 1
      }
    }
    Ini[i,(n-49):n]=-1
  }
  return(Ini[,1:n])
}



.crossover=function(parent.1,parent.2,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,
                    NI,taper,min.freq,max.freq){
 chromosome.crossover=rep(-9999,n)
 last = n - 50
 t = 1
 while (t <= last) {
  val = if (runif(1,0,1) < 0.5) parent.1[t] else parent.2[t]
  chromosome.crossover[t] = val
  if (val != -1) {
    span = .MinSpan[val+1]
    if (span > 1) chromosome.crossover[(t+1):(t+span-1)] = -1
    t = t + span
  } else {
    t = t + 1
  }
 }
 chromosome.crossover[(n-49):n]=rep(-1,50)
 return(chromosome.crossover[1:n])
}


.mutation=function(parent.mutation,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,
                   taper,min.freq,max.freq){
  chromosome.mutation=rep(-9999,n)
  ord = sample(seq(1,m0,1),1)
  chromosome.mutation[1] = ord
  span = .MinSpan[ord+1]
  if (span > 1) chromosome.mutation[2:span] = -1
  t = span + 1
  last = n - 50
  while (t <= last) {
    r = runif(1,0,1)
    if (r <= Pi.N) {
      chromosome.mutation[t] = -1
      t = t + 1
    } else if (r < Pi.P + Pi.N) {
      chromosome.mutation[t] = parent.mutation[t]
      if (parent.mutation[t] != -1) {
        span = .MinSpan[parent.mutation[t]+1]
        if (span > 1) chromosome.mutation[(t+1):(t+span-1)] = -1
        t = t + span
      } else {
        t = t + 1
      }
    } else {
      ord = sample(seq(1,m0,1),1)
      chromosome.mutation[t] = ord
      span = .MinSpan[ord+1]
      if (span > 1) chromosome.mutation[(t+1):(t+span-1)] = -1
      t = t + span
    }
  }
  chromosome.mutation[(n-49):n]=rep(-1,50)
  return(chromosome.mutation[1:n])
}


################ likelihood calculated here ######################
# orders is m in bart()
# `per`: optional precomputed unsmoothed periodogram (over the same freq-index window)
# for this data.piece. If supplied, the redundant mvspec() call for the unsmoothed
# periodogram - which never depends on `orders` - is skipped. GA fitness calls
# (via .MDL.total) don't have a precomputed value handy and fall back to computing it.
.MDL.individual = function(data.piece,orders,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,
                           Pi.P,Pi.N,NI,taper,min.freq,max.freq,per=NULL){ 
 #Calculate the MDL value for a segment of the data
  if (max.freq > .5) max.freq = .5 
  if (min.freq < 0)  min.freq = 0
  Bw    = 2*orders+1  
  code.orders = .5*log(length(data.piece) * Bw^2)
  strt  = max(1, ceiling(length(data.piece)*min.freq)) # set min freq index
  endd  = floor(length(data.piece)*max.freq)           # set max.freq index
  num   = endd - strt + 1
  if (is.null(per)) {
    u   = mvspec(c(data.piece), plot=FALSE, demean=TRUE, detrend=FALSE) 
    per = u$spec[strt:endd]   # periodogram  
  }
  ker   = bart(orders)
  v     = mvspec(c(data.piece), plot=FALSE, taper=taper, kernel=ker, demean=TRUE, detrend=FALSE)
  spec  = v$spec[strt:endd]   # spectrum
  #
  loglikelihood =  num*log(2*pi) +  sum(log(spec) + per/spec)   # -logLike  
  #
  mdl.piece = code.orders + loglikelihood  
  return(mdl.piece)
}




#Calculate the MDL value for each model/chromosom
.MDL.total = function(xdata,chromosome,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,
                      taper,min.freq,max.freq){
  #Find the break locations - vectorized (was an O(n) loop growing a vector with c())
  breakpoint = which(chromosome != -1)
  m=length(breakpoint)
  breakpoint[m+1]=n+1

  mdl = 0
  for(i in 1:m){
    mdl = mdl + .MDL.individual(xdata[breakpoint[i]:(breakpoint[i+1]-1)], 
                                chromosome[breakpoint[i]],xdata,n,Pi.B,Pi.C,PopSize,
                                generation,m0,Pi.P,Pi.N,NI,taper,min.freq, max.freq)
  }
  if(m == 1){
    mdl = mdl + log(n)
  }else{
    mdl = mdl + log(m-1) + (m)*log(n)
  }
  return(mdl)
}

#get the probabilities that inversely proportional to their ranks sorted by S values
.rank.crossover = function(S.chromosome){
  en = length(S.chromosome)
  rank.chromosome = rank(S.chromosome)
  return(2*(en+1-rank.chromosome)/en/(en+1))   #the total probabilities equal to 1
}


#This function generates the next generation
#`MDL.parents` is now passed in by the caller (.GA already computed it as S.parent)
#instead of being recomputed here via a second full apply(.MDL.total) pass over the
#population - that recomputation was pure duplicated work every single generation.
.generate=function(parents,MDL.parents,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,Pi.P,Pi.N,NI,taper,
                   min.freq, max.freq){  
  #parents is a matrix of Popsize x n, each row is a model/chromosome
  offspring = matrix(0,nrow = PopSize,ncol = n)
  probs = .rank.crossover(MDL.parents)   #depends only on MDL.parents - compute once, not per-offspring
  for(i in 1:PopSize){
    r=runif(1,0,1)
    if(r<Pi.C){                                 #conduct crossover
      S.parent1 = sample(1:PopSize, 1, prob = probs)
      S.parent2 = sample(1:PopSize, 1, prob = probs)
      parent.1 = parents[S.parent1,]; parent.2 = parents[S.parent2,]
      offspring[i,]=.crossover(parent.1,parent.2,xdata,n,Pi.B,Pi.C,PopSize,generation,m0,
                               Pi.P,Pi.N,NI,taper,min.freq, max.freq)
    } else {                                      #conduct mutation
      S.parent = sample(1:PopSize, 1, prob = probs)
      offspring[i,]=.mutation(parents[S.parent,],xdata,n,Pi.B,Pi.C,PopSize,
                      generation,m0,Pi.P,Pi.N,NI,taper,min.freq, max.freq)
    }
  }
  return(offspring)
}
