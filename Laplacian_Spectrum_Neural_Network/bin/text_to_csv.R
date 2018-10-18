#!/usr/bin/env Rscript



tmpArgs <- commandArgs(TRUE)
args <- NULL
i <- 1
while (i < length(tmpArgs))
{
  if (tmpArgs[i] %in% c("parameters")) {
    tmpNames <- names(args)
    args <- c(args, tmpArgs[i+1])
    names(args) <- c(tmpNames, tmpArgs[i])
    i <- i+2
  }
}

parameters<- paste0(args["parameters"])


datalala <- read.table(file=parameters, sep="\t", quote="", comment.char="")

names(datalala) <- as.character(unlist(datalala[1,]))
datalala <- datalala[-1,]
datalala <- datalala[,-1]
rownames(datalala) <- 1:nrow(datalala)


write.csv(datalala)
