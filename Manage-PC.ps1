#
# Manage_PC.ps1
#


<#
.SYNOPSIS    
    Turn OFF the UAC setting
.DESCRIPTION 
    Turn OFF the UAC setting
.EXAMPLE     
    TurnOffUAC
.NOTES       
    Please keep above information
#>

Write-Host "Turn Off the UAC settings on Registry"
$key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
Set-ItemProperty $key EnableLUA 0


Set-ItemProperty -Path $key -Name EnableLUA -Value 0

