#########################################################################################

##-- autoParm 

# PopSize: population size. The number of chromosomes in each generation
# Generation: Number of iterations
# P0   = Maximum AR order
# Pi.P = Probability of taking parent's gene in mutation
# Pi.N = Probability of taking -1 in mutation
# Pi.B = Probability of being a break point in initial stage, default to 10/n
# Pi.C = Probability of conducting crossover, default to (n-10)/n
# NI   = number if islands


#########################################################################################

autoParm <-
function(xdata, Pi.B = NULL, Pi.C = NULL, PopSize = 70, generation = 70, P0 = 20, 
         Pi.P = 0.3, Pi.N = 0.3, NI = 7){

if (NCOL(xdata) > 1) stop("univariate time series only")
xdata = c(xdata)  # remove ts attributes if there
n     = length(xdata)
if (n < 100) stop('sample size should be at least 100')
if (is.null(Pi.B)) Pi.B = 10/n
if (is.null(Pi.C)) Pi.C = (n-10)/n

# find breakpoints
brkpts  = .GA1(xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI)

# optimal orders
 u    = c(brkpts, n)
 npts = length(brkpts)
 bst  = c()
 kmdl = c()
 for (i in 1:npts){
  strt = u[i]
  endd = u[i+1]-1
  if (i == npts) endd = endd+1
  data.piece = xdata[strt:endd]
   P00 = ifelse((endd-strt) < P0, floor(.8*(endd-strt)), P0)
  for( k in 0:P00 ) { 
   kmdl[k+1] = .MDL.individual1(data.piece,k,xdata,n,Pi.B,Pi.C,PopSize,generation,P0,
                               Pi.P,Pi.N,NI) 
   }  
  bst[i] = which.min(kmdl)-1
}


# return
cat('returned breakpoints include the endpoints', '\n')
return(list(breakpoints=u, number_of_segments=npts,segment_AR_orders=bst))
}

#This is the overall GA function
.GA1 = function(xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI)
{
 gene.parent = vector("list", NI)                #Stores Chromosomes
 gene.child = vector("list", NI)                 #Stores Chromosomes
 S.parent = matrix(0, nrow = NI, ncol = PopSize)      #Stores MDL
 S.child = matrix(0, nrow = NI, ncol = PopSize)       #Stores MDL
 rank.child = matrix(0, nrow = NI, ncol = PopSize)
 gene.best = vector("list", generation)
 for(i in 1:NI){           #Generate all initial generation for all islands
   gene.parent[[i]] = .Initial1(xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI)
   S.parent[i,] = apply(gene.parent[[i]], 1, function(j) .MDL.total1(xdata,j,n,Pi.B,Pi.C,
         PopSize,generation,P0,Pi.P,Pi.N,NI))
 }

 #Generates the next generation
 for(k in 1:generation){   #For each next generation
pb = txtProgressBar(min=1, max=generation, style=2)  # progress bar
  for(i in 1:NI){      #For each island
    gene.child[[i]] = .generate1(gene.parent[[i]],xdata,n,Pi.B,Pi.C,PopSize,generation,
                                P0,Pi.P,Pi.N,NI)
    S.child[i,] = apply(gene.child[[i]], 1, function(j) .MDL.total1(xdata,j,n,Pi.B,Pi.C,
                        PopSize,generation,P0,Pi.P,Pi.N,NI))
  }
  min.index = which(S.child == min(S.child), arr.ind = TRUE)  
  gene.best[[k]] = gene.child[[min.index[1]]][min.index[2], ]
  #Only comparing first and last of 20,
  if(k > 20 && .MDL.total1(xdata,gene.best[[k]],n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,
                 Pi.N,NI) == .MDL.total1(xdata,gene.best[[k-20]],n,Pi.B,
                 Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI)) break  
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

.MinSpan1 = c(10,10,12,14,16,18,20,rep(25,4),rep(50,10))

   #Setting up initial generation of chromosomes
.Initial1=function(xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI)  
{
  Ini=matrix(0,nrow=PopSize,ncol=n)
  for(i in 1:PopSize){
    Ini[i,1]=sample(seq(1,P0,1),1)
    Ini[i,2:.MinSpan1[Ini[i,1]+1]]=-1
    for(t in 2:(n-50)){
      if(Ini[i,t]==0){
        r=runif(1,0,1)
        if(r<Pi.B){
          Ini[i,t]=sample(seq(1,P0,1),1)
          Ini[i,(t+1):(t+.MinSpan1[Ini[i,t]+1]-1)]=-1
        }
        else {Ini[i,t]=-1}
      }
      else {t=t+1}
    }
    Ini[i,(n-49):n]=-1
  }
  return(Ini[,1:n])
}


.crossover1=function(parent.1,parent.2,xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,
                    NI){
 chromosome.crossover=rep(-9999,n)
 for(t in 1:(n-50)){
  if(chromosome.crossover[t]==-9999){
    if(runif(1,0,1)<0.5) {chromosome.crossover[t]=parent.1[t]}
    else {chromosome.crossover[t]=parent.2[t]}
    if(chromosome.crossover[t]!=-1)  {
    chromosome.crossover[(t+1):(t+.MinSpan1[chromosome.crossover[t]+1]-1)]=-1
    }
  }         #This step replace all followings with -1
  else{t=t+1}   #Since we have replaced with -1, can just move on.
 }
 chromosome.crossover[(n-49):n]=rep(-1,50)
 return(chromosome.crossover[1:n])
}


.mutation1=function(parent.mutation,xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI){
  chromosome.mutation=rep(-9999,n)
  chromosome.mutation[1]=sample(seq(1,P0,1),1)
  chromosome.mutation[2:.MinSpan1[chromosome.mutation[1]+1]]=-1
  for(t in (.MinSpan1[chromosome.mutation[1]+1]+1):(n-50)){
    if(chromosome.mutation[t]==-9999){
      r=runif(1,0,1)
      if(r<=Pi.N)      {chromosome.mutation[t]=-1}
      else if(r>Pi.N&&r<Pi.P+Pi.N){
        chromosome.mutation[t]=parent.mutation[t]
        if(parent.mutation[t]!=-1){
          chromosome.mutation[(t+1):(t+.MinSpan1[parent.mutation[t]+1]-1)]=-1
        }
      }
      else{
        chromosome.mutation[t]=sample(seq(1,P0,1),1)
        chromosome.mutation[(t+1):(t+.MinSpan1[chromosome.mutation[t]+1]-1)]=-1
      }
    }
    else{t=t+1}
  }
  chromosome.mutation[(n-49):n]=rep(-1,50)
  return(chromosome.mutation[1:n])
}


.MDL.individual1 = function(data.piece, orders,xdata,n,Pi.B,Pi.C,PopSize,
                            generation,P0,Pi.P,Pi.N,NI){  #Calculate the MDL value for a segment of the data
  if(orders != 0){
    code.orders = log(orders)
    fit = ar(data.piece, aic = FALSE, order.max = orders)
    var.pred = fit$var.pred
  }else{
    code.orders = 0
    var.pred = var(data.piece)
  }
  code.parameter = (orders + 2)/2 * log(length(data.piece))
  loglikelihood = length(data.piece)/2*log(2*pi*var.pred)

  mdl.piece = code.orders + code.parameter + loglikelihood
  return(mdl.piece)
}


#Calculate the MDL value for each model/chromosom
.MDL.total1 = function(xdata,chromosome,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI){
  #Find the break locations
  breakpoint=c()
  for(t in 1:n){          #Find all the break points
    if(chromosome[t]!=-1){
      breakpoint=c(breakpoint,t)
    }
  }
  m=length(breakpoint)
  breakpoint[m+1]=n+1

  mdl = 0
  for(i in 1:m){
    mdl = mdl + .MDL.individual1(xdata[breakpoint[i]:(breakpoint[i+1]-1)], 
                                chromosome[breakpoint[i]],xdata,n,Pi.B,Pi.C,PopSize,
                                generation,P0,Pi.P,Pi.N,NI)
  }
  if(m == 1){
    mdl = mdl + log(n)
  }else{
    mdl = mdl + log(m-1) + (m)*log(n)
  }
  return(mdl)
}

#get the probabilities that inversely proportional to their ranks sorted by S values
.rank.crossover1 = function(S.chromosome){
  en = length(S.chromosome)
  rank.chromosome = rank(S.chromosome)
  return(2*(en+1-rank.chromosome)/en/(en+1))   #the total probabilities equal to 1
}


#This function generates the next generation
.generate1=function(parents,xdata,n,Pi.B,Pi.C,PopSize,generation,P0,Pi.P,Pi.N,NI){  
  #parents is a matrix of Popsize x n, each row is a model/chromosome
  offspring = matrix(0,nrow = PopSize,ncol = n)
  MDL.parents = apply(parents, 1, function(i) .MDL.total1(xdata,i,n,Pi.B,Pi.C,PopSize,
                       generation,P0,Pi.P,Pi.N,NI))
  for(i in 1:PopSize){
    r=runif(1,0,1)
    if(r<Pi.C){                                 #conduct crossover
      S.parent1 = sample(1:PopSize, 1, prob = .rank.crossover1(MDL.parents))
      S.parent2 = sample(1:PopSize, 1, prob = .rank.crossover1(MDL.parents))
      parent.1 = parents[S.parent1,]; parent.2 = parents[S.parent2,]
      offspring[i,]=.crossover1(parent.1,parent.2,xdata,n,Pi.B,Pi.C,PopSize,generation,P0,
                               Pi.P,Pi.N,NI)
    }
    if(r>=Pi.C){                                      #conduct mutation
      S.parent = sample(1:PopSize, 1, prob = .rank.crossover1(MDL.parents))
      offspring[i,]=.mutation1(parents[S.parent,],xdata,n,Pi.B,Pi.C,PopSize,
                      generation,P0,Pi.P,Pi.N,NI)
    }
  }
  return(offspring)
}

