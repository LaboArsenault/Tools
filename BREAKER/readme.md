# BREAKER (Bourgault's REact And Kill - Extreme Response)

## Author
Created by Jerome Bourgault (jerome.bourgault@criucpq.ulaval.ca)
Current version : v1.0
Date : 11/16/2022

## Description
This toolkit includes an R script and a bash script that are meant to be called within other scripts (especially in parts that may cause an increase in memory (RAM) burden, such as loops) <br>
It is meant to kill the current task if the total memory used and/or the memory used by current task is above a specified threshold to prevent memory overload. <br>
These scripts have a few options that allow the user to specify memory threshold(s) and to save the current workspace (Rscript only). <br>
The Rscript also returns a Data Frame which contains the current/total and task/total memory usage ratios for monitoring purposes.

## Installation
No installation is required.
Only clone this repository and source/call the scripts within you own scripts.
