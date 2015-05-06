#This scripts will download or copy softwares from Repository
#For L3 Team please use dropzone address
#For L4 IF Team, you could use repository server phpsxdv07
#Please try to access repository manually before you run the scripts

#$repository = "http://sstgs02.tor.omc.hp.com/app.sources/INF/install"
#$repository = "\\phpsxdv07.edev.elabs.eds.com\Repository\work\install"
$repository = "C:\Users\niliu\OneDrive\LNSoftware"
$installdrive = "C:"
$installdir = "$installdrive\work\install"

$wc = New-Object System.Net.WebClient

function Get-File($source,$destination){
    if($destination -eq $Null){
        $destination = $source.Replace($repository,$installdir)
    }
    $destination = $destination.Replace('/','\')
    $destinationFolder = Split-Path -Parent $destination
    if(!(Test-Path($destinationFolder))){
        md $destinationFolder | Out-Null
    }
    if($source.StartsWith("http")){
        $source = $source.Replace('\','/')
        Write-Host "Downloading File $source"
        $wc.DownloadFile($source,$destination) 
    }
    else{
        $source = $source.Replace('/','\')
        Write-Host "Copying File $source"
        Copy-Item $source $destination 
    }
}

function Un-Zip($zipFileName,$destination){
    if(test-path($zipFileName)){   
        if($destination -eq $Null){
            $destination = Split-Path -Parent $zipFileName
            $destination = $destination+"\"
            Write-Host $destination
        }

        $shellApplication = new-object -com shell.application
        $zipPackage = $shellApplication.NameSpace($zipFileName)
        if(!(test-path($destination))){
            $d = New-Item -Path $destination -Type Directory
            Write-Host "Creating Folder "$d.FullName
        }
        $destinationFolder = $shellApplication.NameSpace($destination)
        Write-Host "Extracting "$zipFileName" to "$destination
        $destinationFolder.CopyHere($zipPackage.Items(),16)
    }
}

#This script will copy\download all softwares from repository
#You could comment some lines if you won't copy\download that software
Get-Date
#AppFabric
#Get-File "$repository\Microsoft\AppFabric.zip"
#Un-Zip "$installdir\Microsoft\AppFabric.zip" "$installdir\Microsoft\"
#Remove-Item "$installdir\Microsoft\AppFabric.zip" -Force
#WSE
#Get-File "$repository\Microsoft\WSE.zip"
#Un-Zip "$installdir\Microsoft\WSE.zip" "$installdir\Microsoft\"
#Remove-Item "$installdir\Microsoft\WSE.zip" -Force
#BizTalk 2010
#Get-File "$repository\Microsoft\BizTalk Server\2010\BizTalkRedistributable\Bts2010Win2K8EN64.cab"
#Get-File "$repository\Microsoft\BizTalk Server\2010\BizTalk Server 2010 Enterprise edition EN RTM\BizTalkServer2010EnterpriseENRTM.zip"
#Un-Zip "$installdir\Microsoft\BizTalk Server\2010\BizTalk Server 2010 Enterprise edition EN RTM\BizTalkServer2010EnterpriseENRTM.zip" "$installdrive\"
#Move-Item "$installdrive\BizTalkServer2010EnterpriseENRTM\BizTalk Accelerators" "$installdir\Microsoft\BizTalk Server\2010" -Force
#Move-Item "$installdrive\BizTalkServer2010EnterpriseENRTM\BizTalk Server" "$installdir\Microsoft\BizTalk Server\2010" -Force
#Remove-Item "$installdrive\BizTalkServer2010EnterpriseENRTM\"
#Remove-Item "$installdir\Microsoft\BizTalk Server\2010\BizTalk Server 2010 Enterprise edition EN RTM\" -Recurse -Force
#WebDeploy
#Get-File "$repository\Microsoft\IIS\WebDeploy_amd64_en-US.msi"
#Get-File "$repository\Microsoft\IIS\WebDeploy_2_10_amd64_en-US.msi"
#MSXML
#Get-File "$repository\Microsoft\MSMXL\msxml6_x64.msi" "$installdir\Microsoft\MSXML\msxml6_x64.msi"
#.Net Framework
Get-File "$repository\Microsoft .NET Framework\Microsoft .NET Framework 4.5.1-x86-x64.exe"
#SQL Server 2008
#Get-File "$repository\Microsoft\SQL Server\2008\KBs.zip"
#Get-File "$repository\Microsoft\SQL Server\2008\SqlServerEnt2008R2.zip"
#Get-File "$repository\Microsoft\SQL Server\2008\SQLServer2008R2SP2-KB2630458-x64-ENU.exe"
#Un-Zip "$installdir\Microsoft\SQL Server\2008\KBs.zip" "$installdir\Microsoft\SQL Server\2008\"
#Un-Zip "$installdir\Microsoft\SQL Server\2008\SqlServerEnt2008R2.zip" "$installdir\Microsoft\SQL Server\2008\"
#Remove-Item "$installdir\Microsoft\SQL Server\2008\KBs.zip"
#Remove-Item "$installdir\Microsoft\SQL Server\2008\SqlServerEnt2008R2.zip"
#OPTIMUM
Get-File "$repository\OPTIMUM\ExpressInstallPackage_ITG(2013-9-16).zip"
Un-Zip "$installdir\OPTIMUM\ExpressInstallPackage_ITG(2013-9-16).zip" 
Remove-Item "$installdir\OPTIMUM\ExpressInstallPackage_ITG(2013-9-16).zip" 
#Visual Studio 2010
#Get-File "$repository\Microsoft\Visual Studio\2010\VisualStudioProfessional2010x86.zip"
#Get-File "$repository\Microsoft\Visual Studio\2010\KBs\KB983509.zip"
#Get-File "$repository\Microsoft\Visual Studio\2010\KBs\VS10SP1-KB2600214-x86-x64.exe"
#Un-Zip "$installdir\Microsoft\Visual Studio\2010\KBs\KB983509.zip"
#Un-Zip "$installdir\Microsoft\Visual Studio\2010\VisualStudioProfessional2010x86.zip" "$installdir\Microsoft\Visual Studio\2010\VisualStudioProfessional2010x86"
#Remove-Item "$installdir\Microsoft\Visual Studio\2010\KBs\KB983509.zip"
#Remove-Item "$installdir\Microsoft\Visual Studio\2010\VisualStudioProfessional2010x86.zip"
#Web Platform Installer
#Get-File "$repository\Microsoft\Web Platform Installer\4.5\WebPlatformInstaller_amd64_en-US.msi"
#Powershell 3.0
Get-File "$repository\Powershell\Windows PowerShell 3.0-x64.msu"
#ThirdParty Tools
#Get-File "$repository\ThirdParty\Tools.zip"
#Un-Zip "$installdir\ThirdParty\Tools.zip"
#Remove-Item "$installdir\ThirdParty\Tools.zip"
Get-Date