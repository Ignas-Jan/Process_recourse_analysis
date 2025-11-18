
param(
   [Parameter(Mandatory=$true)]
   [int]$MemoryThresholdMB
   )

Write-Host ("-" * 200)
Write-Host "Your inserted parameter:"$MemoryThresholdMB "MB"


#tasklist.exe
$TaskList = tasklist.exe /FO CSV /NH

#Image Name, PID, Session Name, Session#, Mem Usage - column names

$SystemProcesses = $TaskList | ConvertFrom-Csv -Header "ImageName", "PID", "SessionName", "Session", "MemUsage" # adds header names to all columns in this particular order

$SystemProcesses = $SystemProcesses | ForEach-Object {
                  if ($_.MemUsage -notmatch 'N/A') {
                  $memoryKB = [double]($_.MemUsage -replace '[",\sK]|', '')  # replaces " if existent "," K and spaces into '' # double is used to convert to digit
                  $memoryMB = [math]::Round([double]$memoryKB / 1024, 2) # converts kilobytes to megabytes = 1MB is 1024 KB and is rounded to, to 2 digits after comma

                  [PSCustomObject]@{    # converting text outputs into powershell objects
                  ImageName = $_.ImageName   
                  PID = $_.PID
                  MemUsage = $memoryMB
                  }
               }
}
Read-Host -Prompt "Press any key to continue to inspect processes or CTRL+C to quit" | Out-Null

$filtered = $SystemProcesses| Where-Object {$_.MemUsage -gt $MemoryThresholdMB} #selects processes that has higher memory usage than the input
$grouped = $filtered | Group-Object -Property ImageName #groups the processes by ImageName (process name)

#Write-Output $grouped    #can be used just to display results with no formating


foreach ($groups in $grouped) { # for loop for each group of objects
   Write-Host ("." * 200)
   Write-Host "Process Name: $($groups.Name) (Count: $($groups.Count))"
   $groups.Group | Sort-Object -Property MemUsage -Descending | Format-Table PID, MemUsage  # formated table to look more readable and sorted by memory usage descending   
}



                         