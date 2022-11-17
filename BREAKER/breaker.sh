#!/bin/bash
declare -A arguments=(); declare -A variables=(); declare -i index=1;
variables["--mem_tot"]="mem_tot_lim";
variables["--mem_task"]="mem_task_lim";
for i in "$@"
do
        arguments[$index]=$i;
        prev_index="$(expr $index - 1)";
        if [[ $i == *"="* ]]
                then argument_label=${i%=*}
                else argument_label=${arguments[$prev_index]}
        fi
        if [[ -n $argument_label ]] ; then
                if [[ -n ${variables[$argument_label]} ]]
                        then
                        if [[ $i == *"="* ]]
                                then declare ${variables[$argument_label]}=${i#$argument_label=}
                                else declare ${variables[$argument_label]}=${arguments[$index]}
                        fi
                fi
        fi
  index=index+1;
done;
if [ -z "${mem_tot_lim}" ]; then mem_tot_lim=10000000; fi;
if [ -z "${mem_task_lim}" ]; then mem_task_lim=10000000; fi;
mem_tot_lim=`echo "scale=4; $mem_tot_lim" | bc`
mem_tot_lim_nodot=`echo $mem_tot_lim | sed 's/\.//g'`
mem=`free`; tot=`echo $mem | awk '{print $8}'`;
used=`echo $mem | awk '{print $9}'`;
mem_tot_used=`echo "scale=4; $used / $tot" | bc`
mem_tot_used_nodot=`echo $mem_tot_used | sed 's/\.//g'`
if [ "$mem_tot_lim_nodot" -lt 10 ]; then mem_tot_lim_nodot=$((mem_tot_lim_nodot*1000));
 else
  if [ "$mem_tot_lim_nodot" -lt 100 ]; then mem_tot_lim_nodot=$((mem_tot_lim_nodot*100));
   else
    if [ "$mem_tot_lim_nodot" -lt 1000 ]; then mem_tot_lim_nodot=$((mem_tot_lim_nodot*10));
    fi;
  fi;
fi;
if [ "$mem_tot_used_nodot" -gt "$mem_tot_lim_nodot" ]; then echo "Total memory usage too high :"; echo "	--Total/Current : $(echo $mem_tot_used | awk '{printf "%4.3f\n",$1*100}')% > $(echo $mem_tot_lim | awk '{printf "%4.3f\n",$1*100}')%"; echo "Stopping program..."; kill -9 $PPID; exit 1; fi;
avail=`echo $mem | awk '{print $13}'`;
mem_task_lim=`echo "scale=4; $mem_task_lim" | bc`
mem_task_lim_nodot=`echo $mem_task_lim | sed 's/\.//g'`
mem_task=`pmap $$ | tail -n1 | awk '{print $2}'`
if [ `echo $mem_task | grep 'K'` ]
then
	mem_task=`echo $mem_task | sed 's/K//g'`
else if [ `echo $mem_task | grep 'M'` ]
then
	mem_task=`echo $mem_task | sed 's/M//g'`
	mem_task=$((mem_task*1000))
else if [ `echo $mem_task | grep 'G'` ]
then
        mem_task=`echo $mem_task | sed 's/G//g'`
        mem_task=$((mem_task*1000000))
    fi;
  fi;
fi;
mem_task_used=`echo "scale=4; $mem_task / $avail" | bc`
mem_task_used_nodot=`echo $mem_task_used | sed 's/\.//g'`
if [ "$mem_task_lim_nodot" -lt 10 ]; then mem_task_lim_nodot=$((mem_task_lim_nodot*1000));
 else
  if [ "$mem_task_lim_nodot" -lt 100 ]; then mem_task_lim_nodot=$((mem_task_lim_nodot*100));
   else
    if [ "$mem_task_lim_nodot" -lt 1000 ]; then mem_task_lim_nodot=$((mem_task_lim_nodot*10));
    fi;
  fi;
fi;
if [ "$mem_task_used_nodot" -gt "$mem_task_lim_nodot" ]; then echo "Total memory usage too high :"; echo "        --Task/Available : $(echo $mem_task_used | awk '{printf "%4.3f\n",$1*100}')% > $(echo $mem_task_lim | awk '{printf "%4.3f\n",$1*100}')%"; echo "Stopping program..."; kill -9 $$; exit 1; fi;
mem_avail_tot=`echo "scale=4; $avail / $tot" | bc`
mem_avail_tot=`echo $mem_avail_tot | sed 's/\.//g'`
if [ "$mem_avail_tot" -gt 9500 ]; then echo "Total memory usage too high :"; echo "        --Available/Total : $mem_tot_used % > 95%"; echo "Stopping program..."; kill -9 $PPID; exit 1; fi;
