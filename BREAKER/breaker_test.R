#!/bin/env Rscript

source("/home/boujer01/BREAKER/breaker.R")

for(i in 1:10){
  message("Loop #", i)
  message("\tMemory threshold : ", (1-(i/10))*100, "%")
  mem_check(mem_tot_lim=(1-(i/10)))
}

