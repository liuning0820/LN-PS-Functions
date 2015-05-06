function Create-Directory ([string]$Path) 
{
if (Test-Path $Path){
        Write-Host "Folder: $Path Already Exists" -ForeGroundColor Yellow
    }
    else{
        Write-Host "Creating $Path" -Foregroundcolor Green
        New-Item -Path $Path -type directory | Out-Null
    }
}

Write-Host "Creating Standard Directories ..."
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$xmlDoc = New-Object System.Xml.XmlDocument
$xmlDoc.Load("$scriptPath\Create-Directory.directories.xml")

$nodes = $xmlDoc.SelectNodes("/directories/directory")
foreach($node in $nodes){
    Create-Directory $node.name
}
