# BREAKER (Bourgault's REact And Kill - Extreme Response)

## Author
Created by Jerome Bourgault (jerome.bourgault@criucpq.ulaval.ca) <br>
Current version : v1.0 <br>
Date : 11/16/2022

## Description
This toolkit includes an R script and a bash script that are meant to be called within other scripts (especially in parts that may cause an increase in memory (RAM) burden, such as loops) <br>
It is meant to kill the current task if the total memory used and/or the memory used by current task is above a specified threshold to prevent memory overload. <br>
These scripts have a few options that allow the user to specify memory threshold(s) and to save the current workspace (Rscript only). <br>
The Rscript also returns a Data Frame which contains the current/total and task/total memory usage ratios for monitoring purposes.<br>
If memory usage is okay, then nothing will happen and only the current memory usage will be displayed (Rscript only).

## Installation
No installation is required. <br>
Only clone this repository and source/call the scripts within you own scripts.

## Usage
Arguments for both scripts are : <br>
#### --mem_tot_lim : current/total memory threshold (0,1)
#### --mem_task_lim : task/total memory threshold (0,1)
#### --save_dat : should you save the current workspace before killing the task (Rscript only)

<br>
See 'breaker_test.R' for an example of the Rscript usage.
