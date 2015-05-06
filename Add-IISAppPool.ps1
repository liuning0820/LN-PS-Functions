

<#
.SYNOPSIS    
    Add AppPool to local host
.DESCRIPTION 
    This task will Add a AppPool to local host
.EXAMPLE     
    Add-IISAppPool -Name "DemoAppPool1" -UserName "AppUser" -Password "My_P@ssWORd12"
.EXAMPLE
    Add-IISAppPool "DemoAppPool1" "AppUser" "My_P@ssWORd12"
.NOTES       
    Please keep above information
#>
Function Add-IISAppPool{
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,HelpMessage="Enter application pool name.")][string]$Name,
    [Parameter(Mandatory=$True,HelpMessage="Enter user name.")][string]$UserName,
    [Parameter(Mandatory=$True,HelpMessage="Enter password.")][string]$Password,
    [Parameter(HelpMessage="Enter ManagedRuntimeVersion, eg 4.0")][string]$ManagedRuntimeVersion="v4.0",
    [Parameter(HelpMessage="Enter ManagedPipelineMode, eg 0 or 1")][int]$ManagedPipelineMode=0
)



try
{
    Write-Host $(Get-Date) "Start create application pool ""$Name""." -ForegroundColor White
    $appPoolSettings = [wmiclass] "root\MicrosoftIISv2:IISApplicationPoolSetting"
    $newPool = $appPoolSettings.CreateInstance()
    $newPool.Name = "W3SVC/AppPools/" + $Name
    $newPool.WAMUsername = $UserName
    $newPool.WAMUserPass = $Password
    $newPool.ManagedRuntimeVersion = $ManagedRuntimeVersion
    $newPool.ManagedPipelineMode = $ManagedPipelineMode
    $newPool.Put()
    # Do it again if it fails as there is a bug with Powershell/WMI
    if (!$?) 
    {
        $newPool.Put() 
        Write-Host $(Get-Date) "SUCCESS: Create application pool ""$Name""." -ForegroundColor Green
    }
    else
    {
        Write-Host $(Get-Date) "SUCCESS: Create application pool ""$Name""." -ForegroundColor Green
    }
    
}
catch
{
    Write-Host $(Get-Date) "Failed to create application pool ""$Name"". Review the error message" -ForegroundColor Red
    $_
}
}


Write-Host "Configuring IIS Application Pools ..."

$global:gv=@{"server"= ($env:computername).ToLower()}

 $gv.Add("servertype","local")
 $gv.Add("InstallDrive","C:")


$xmlDoc = New-Object System.Xml.XmlDocument
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$xmlDoc.Load("$scriptPath\Add-IISAppPool.source.xml")

$nodes = $xmlDoc.SelectNodes("/iis/apppools/apppool")
foreach($node in $nodes){
    if($gv.servertype -eq "local" -or $node.targetserver.contains($gv.servertype)){
        Add-IISAppPool $node.name $node.username $node.password
    }
}