Write-Host "Turn On Windows Features ..."

Import-module ServerManager


$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$xmlDoc = New-Object System.Xml.XmlDocument
$xmlDoc.Load("$scriptPath\Add-WindowsFeatures.source.xml")

$nodes = $xmlDoc.SelectNodes("/windowsfeatures/windowsfeature")
$osVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption

foreach($node in $nodes){
    if($node.includeallsubfeature -eq "true"){
        if($node.targetos -eq $null -or $osVersion.Contains($node.targetos)){
            Add-WindowsFeature $node.name -IncludeAllSubFeature | Out-Default
        }
        else{
            Write-Host "Skip Feature"$node.name" because it only need to install on"$node.targetos"servers"
        }
    }
    else{
        $feature = Get-WindowsFeature | Where-Object { $_.name -eq $node.name} 
        if ($feature.Installed -ne $true){
            if($node.targetos -eq $null -or $osVersion.Contains($node.targetos)){
                Add-WindowsFeature  $node.name | Out-Default              
            }
            else{
                Write-Host "Skip Feature"$node.name" because it only need to install on"$node.targetos"servers"
            }
        }
        else{
            Write-Host "Windows Feature"$node.name"Already Existed" -ForegroundColor:Yellow
        } 
    }
}

