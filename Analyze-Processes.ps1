
param(
   [Parameter(Mandatory=$true)]
   [int]$MemoryThresholdMB)
   write-host "Your inserted parameter:"$MemoryThresholdMB "MB"

#tasklist.exe
$TaskList = tasklist.exe /FO CSV /NH

#Image Name, PID, Session Name, Session#, Mem Usage - column names

$SystemProcesses = $TaskList | ConvertFrom-Csv -Header "ImageName", "PID", "SessionName", "Session", "MemUsage" # adds header names to all columns in this particular order

$SystemProcesses = $SystemProcesses | ForEach-Object {
                   $memoryKB = [double]($_.MemUsage -replace '[",\sK]|', '')  # replaces "" , K and spaces into '' # double is used to convert to digit
                   $memoryMB = [math]::Round([double]$memoryKB / 1024, 2) # converts kilobytes to megabytes = 1MB is 1024 KB and is rounded to, to 2 digits after comma

                     [PSCustomObject]@{    # converting text outputs into powershell objects
                     ImageName = $_.ImageName   
                     PID = $_.PID
                     MemUsage = $memoryMB
                     }
                   }


$filtered = $SystemProcesses| Where-Object {$_.MemUsage -gt $MemoryThresholdMB} #selects processes that has higher memory usage than the input
$grouped = $filtered | Group-Object -Property ImageName #groups the processes by ImageName

Write-Output $grouped





                         