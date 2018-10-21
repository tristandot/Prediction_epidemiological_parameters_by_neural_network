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


data <- read.table(file=parameters, sep="\t", quote="", comment.char="")

names(data) <- as.character(unlist(data[1,]))
data <- data[-1,]
data <- data[,-1]
rownames(data) <- 1:nrow(data)


write.csv(data)
