#tasklist.exe /FO CSV /NH
#tasklist.exe 

# Get-Process;

param(
   [Parameter(Mandatory=$true)]
   [int]$MemoryThresholdMB)
   write-host "Your inserted parameter:"$MemoryThresholdMB "MB"




                         