
mem_check <- function(mem_tot_lim=NULL, mem_task_lim=NULL, save_dat=FALSE){
  #' @usage Checks memory usage and stops R for current script in case of memory overload
  #' @param mem_tot_lim (float) Total memory usage threshold (0,1) (default NULL)
  #' @param mem_task_lim (float) Current task memory usage threshold (0,1) (default NULL)
  #' @param save_dat (bool) Should you save the current workspace in case of memory overload  (default FALSE)
  #' @return Dataframe containing current/total and task/total ratios
  if(is.null(mem_tot_lim) && is.null(mem_task_lim)){stop("Error in mem_check() : no memory threshold specified.")}
  if(!is.null(mem_tot_lim) & is.null(mem_task_lim)){case<-1; pct_tot<-round(mem_tot_lim*100,2)}
  if(is.null(mem_tot_lim) & !is.null(mem_task_lim)){case<-2; pct_task<-round(mem_task_lim*100,2)} 
  if(!is.null(mem_tot_lim) & !is.null(mem_task_lim)){case<-3; pct_tot<-round(mem_tot_lim*100,2); pct_task<-round(mem_task_lim*100,2)}
  mem.test <- as.data.frame(system2("free", " --mega", stdout = TRUE))
  col=strsplit(mem.test[1,], " +")[[1]]
  mem <- list(total=as.numeric(strsplit(mem.test[2,], " +")[[1]][which(col=='total')]),
              curr=as.numeric(strsplit(mem.test[2,], " +")[[1]][which(col=='used')]),
              task=as.numeric(sapply(strsplit(as.character(pryr::mem_used()),' '), `[[`, 1))/1e6)
  ct_ratio <- round((mem$curr/mem$total)*100,2); tt_ratio <- round((mem$task/mem$total)*100,2); tc_ratio <- round((mem$task/mem$curr)*100,2)
  check_ct<-ifelse(test=!is.null(mem_tot_lim),yes=(ct_ratio/100)>=mem_tot_lim,no=FALSE); check_tt<-ifelse(test=!is.null(mem_task_lim),yes=(tt_ratio/100)>=mem_task_lim,no=FALSE); err<-"\n\t"
  if(save_dat){save_dat <- "yes"} else {save_dat <- "no"}; stop<-FALSE;
  if((case==1) & check_ct){err<-paste0(err,"Total memory usage too high!\n\t\t--Current/Total > ", mem_tot_lim*100, "% (", ct_ratio,"%)\n"); stop<-TRUE
  } else if((case==2) & check_tt){err<-paste0(err, "Current task memory usage too high!\n\t\t--Task/Total > ", mem_task_lim*100, "% (", tt_ratio,"%)\n"); stop<-TRUE
  } else if((case==3) & (check_ct | check_tt)){err<-paste0(err,"Memory usage too high!\n\t\t--Current/Total > ", mem_tot_lim*100, "% (", ct_ratio, "%)\n\t\t--Task/Total > ", mem_task_lim, "% (", tt_ratio, "%)\n"); stop<-TRUE
  } else {err<-paste0(err,"Memory usage :\n\t\t--Current/Total :", ct_ratio, "%\n\t\t--Task/Total :", tt_ratio, "%\n\t\t--Task/Current : ", tc_ratio,"%\n")}
  if(stop){stop(err); quit(save = save_dat, status=0)
  } else {message(err)}
  return(data.frame(ct_ratio=ct_ratio, tt_ratio=tt_ratio))
}
