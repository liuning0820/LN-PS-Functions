# Powershell backgroud job
Get-Help  Start-Job

# create background job
$procjob = start-job {get-process}

# give the job a name
start-job {Get-HotFix} -Name hf