<#
.SYNOPSIS    
    Install Software
.DESCRIPTION 
    Install Software
.EXAMPLE
    InstallSoftware
.NOTES       
    Please keep above information
#>

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$xmlDoc = New-Object System.Xml.XmlDocument

Write-Host "Installing Softwares ..."



$xmlDoc.Load("$scriptPath\Install-Software.source.xml")

$xmlDoc.SelectNodes("/softwares/software") | % {

    if($_.targetserver.contains($gv.servertype)){
        $curTime = Get-Date
        #Write-Host "[$curTime] Begin Install "$_.name $_.version"" -ForegroundColor:Green
        $softwareFilePath = $gv.InstallDrive+"\Users\niliu\OneDrive\LNSoftware\WindowsDevelopment\"+$_.path
        $installBatFile = $softwareFilePath+"install.bat"
        $found = $False
        $installedSoftwares = $gv.GetInstalledSoftware()
        if($installedSoftwares -ne $Null){
            foreach($installedSoftware in $installedSoftwares){
                if($installedSoftware.DisplayName -eq $_.name ){
                    $found = $True
                    break
                }
            }
        }
        if($found){
            Write-Host "Software"$_.name" Already Existed" -ForegroundColor:Yellow
            $_.SetAttribute("status","Existed")
        }
        else{
            Write-Host "Installing"$_.name", esitmate is"$_.estimate
            if(Test-Path($softwareFilePath)){
                Set-Content $installBatFile $_.run
                if($_.name -eq "Microsoft SQL Server 2008 R2 (64-bit)" -and $_.run.EndsWith("temp.ini") ){ # Process SQL Server Configuration File
                        $content = Get-Content ("$softwareFilePath\ddrive_ConfigurationFileTemplate.ini")
                        for($i=0; $i -lt $content.Length; $i++){
                            foreach($paramNode in $_.params.ChildNodes){
                                $key = "["+$paramNode.Name +"]"
                                $value = $paramNode.InnerText
                                $content[$i] = $content[$i].Replace($key,$value)
                            }
                    }
                    Set-Content "$softwareFilePath\temp.ini" $content
                }
                #iftask RunExternal "$installBatFile"
                $_.SetAttribute("status","Installed")
                $elapsedTime = (Get-Date) - $curTime
                $elapsed = $elapsedTime.Hours.ToString("00")+":"+$elapsedTime.Minutes.ToString("00")+":"+$elapsedTime.Seconds.ToString("00")
                $_.SetAttribute("elapsed",$elapsed)
            }
            else{
                Write-Host "Can't Find installation files from $softwareFilePath, Stop Installation" -ForegroundColor:Red
                Write-Host "Please copy the related files to this path by refering installation command line:" 
                Write-Host "  "$_.run
                $_.SetAttribute("status","Skipped")
                break
            }            
        }
        
        #Write-Host "[$curTime] End Install "$_.name $_.version"" -ForegroundColor:Green
        #Write-Host
    }
    else{
        $_.SetAttribute("status","Skipped")
    }
    if($_.name.Length -gt 40){
        $_.SetAttribute("displayname",$_.name.SubString(0,37)+"...")
    }
    else{
        $_.SetAttribute("displayname",$_.name)   
    }
}

Write-Host
Write-Host "##############Install Software Results:###############"
Write-Host "<pre>"
$xmlDoc.SelectNodes("/softwares/software") |  Format-Table displayname,status,elapsed,estimate  -AutoSize
Write-Host "</pre>"
#Copy Portable Tools
