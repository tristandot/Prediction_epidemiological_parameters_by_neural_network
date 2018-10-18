#!/usr/bin/env Rscript

library(igraph)
library(ape)
library(ctv)

#install.views('Phylogenetics')
#update.views('Phylogenetics')

tmpArgs <- commandArgs(TRUE)
args <- NULL
i <- 1
while (i < length(tmpArgs))
{
  if (tmpArgs[i] %in% c("tree", "id", "step")) {
    tmpNames <- names(args)
    args <- c(args, tmpArgs[i+1])
    names(args) <- c(tmpNames, tmpArgs[i])
    i <- i+2
  }
}

#tree<-read.table(args["tree"], header=T, stringsAsFactors=F)
tree<- paste0(args["tree"])
id<- paste0(args["id"])
step<- paste0(args["step"])

#nbTrees <- read.table(args["nbTrees"], header=T, stringsAsFactors=F)

method = c("standard")


#tree = sprintf("arbre_%d.nwk",i)

phylo <- try(read.tree(file = tree))

x = list()

options("scipen"=100, "digits"=10)

for(i in seq(1,step))
{
  
  if(class(phylo[i][[1]]) != "NULL")
  {

    if (method == "standard") {
      e = eigen(graph.laplacian(graph.adjacency(data.matrix(dist.nodes(phylo[i][[1]])), 
                                                weighted = T), normalized = F), symmetric = T, only.values = T)
    
    }
  
  
    if (method == "normal") {
     e = eigen(graph.laplacian(graph.adjacency(data.matrix(dist.nodes(phylo[i][[1]])), 
                                                weighted = T), normalized = T), symmetric = T, only.values = T)
      
    }
  
    x = subset(e$values, e$values >= 0)
    #x = e
  
    col_res_eigenv <- as.data.frame(t(x))  
  
      line <- data.frame(me = c(col_res_eigenv), row.names = (as.numeric(id)+i-1))
  
      if(dim(col_res_eigenv)[2] == 399){
        line <- line[,-399]
      }
  
      if(i == 1){
       data = line
      }
  
      else
      {
        newdf = rbind(data, line)
        data = newdf
      }
    
   }
  
}

write.table(data, col.names=FALSE, sep=",")

