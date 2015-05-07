#
# Analyze_LogFile.ps1
#


<#
.SYNOPSIS    
    Analyze_LogFile
.DESCRIPTION 
    This function will seach the log files base on the keyword.
.EXAMPLE     
    Analyze_LogFile
.EXAMPLE
    Analyze_LogFile -FilePath "C:\Test\" -KeyWord "txt"
.NOTES       
    Please keep above information
#>


function Analyze_LogFile {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$FilePath="C:\Logfiles\SA\*.txt",
    [Parameter(HelpMessage="Enter KeyWord Search through the files, eg Error:")][string]$KeyWord="Error|"
)

Select-String -Path $FilePath -Pattern $KeyWord
}



<#
.SYNOPSIS    
    Analyze_LogFile_Daily
.DESCRIPTION 
    This function will seach the log files base on the keyword.
.EXAMPLE     
    Analyze_LogFile_Daily
.EXAMPLE
    Analyze_LogFile_Daily -FilePath "C:\Test\" -KeyWord "*|Error|"
.NOTES       
    Please keep above information
#>


function Analyze_LogFile_Daily {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$RootPath="C:\Logfiles\SA\",
    [Parameter(HelpMessage="Enter KeyWord Search through the files, eg Error:")][string]$KeyWord="|Error|"
)

$date = get-date
$resultFileName = "result"+ $date.ToString("yyyyMMdd")+".txt"
Write-Host ($RootPath + $resultFileName)
Write-Host $resultFileName
if(!(Test-Path ($RootPath+$resultFileName)))
{
    new-item -ItemType file -Path ($RootPath+$resultFileName)
}
    Write-Host ($RootPath+$resultFileName)
    $logpath = $RootPath+"*log"+ $date.ToString("yyyyMMdd")+".txt"
    Clear-Content ($RootPath+$resultFileName)
    Get-Content $logpath | Where-Object { $_.Contains($KeyWord) }|Set-Content ($RootPath+$resultFileName)

}








#
#Parse and Analyze LogFiles V 0.2
# *.txt as the source format
# Usage: Analyze_LogFile_V2 | Export-Csv C:\LogFiles\2.csv


function Analyze_LogFile_V2 {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$DirPath="C:\Logfiles\SA\",
	[Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$FilePattern="*.txt",
    [Parameter(HelpMessage="Enter KeyWord Search through the files, eg Error:")][string]$KeyWord="*|Error|*"
)

	if(Test-Path $DirPath)
	{

	   foreach($file in Get-ChildItem -Filter $FilePattern $DirPath )
	   {
			#variale for the file contents
			$filetext= Get-Content $file.FullName
			Write-Host $file.FullName
			#Loop through each line for the file
			for ($i = 1; $i -lt $filetext.Length; $i++)
			   { 

				   if(($filetext[$i] -like $KeyWord))
				   {
					$output= New-Object psobject
					$output | Add-Member NoteProperty "FileName" $file.Name
					$output | Add-Member NoteProperty "Date" $filetext[$i].Split("|")[0]
					$output | Add-Member NoteProperty "Module" $filetext[$i].Split("|")[1]
					$output | Add-Member NoteProperty "ErrorMessage" $filetext[$i].Split("|")[2]
					#Write-Host $i
					#$output | Export-Csv C:\Logfiles\1.csv
					$output
				   }


			   }
	   }
	}
}

#Analyze the Service Agent DEV server's Log
Analyze_LogFile_V2 -DirPath "\\D9W0602G.houston.hp.com\Logfiles\SA\" |Export-Csv C:\Logfiles\QA_Error_Result.csv
#Analyze the my local's Log
Analyze_LogFile_V2 |Export-Csv C:\Logfiles\Local_Error_Result.csv


#
#Parse and Analyze LogFiles V 0.3
#Include the progress of the parsing.
# *.txt as the source format
# Usage: Analyze_LogFile_V3 | Export-Csv C:\LogFiles\2.csv


function Analyze_LogFile_V3 {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$DirPath="C:\Logfiles\SA\",
	[Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$FilePattern="*.txt",
    [Parameter(HelpMessage="Enter KeyWord Search through the files, eg Error:")][string]$KeyWord="*|Error|*"
)

	if(Test-Path $DirPath)
	{

	#Variable for file count progress
	$filecounter = 0

	#Variable for count of files to process
	$filecount = (get-Childitem -filter "*.txt" $DirPath | Where {$_.psIsContainer -eq $false}).Count
	   foreach($file in Get-ChildItem -Filter $FilePattern $DirPath | Where {$_.psIsContainer -eq $false})
	   {
			#variale for the file contents
			$filetext= Get-Content $file.FullName
			Write-Host $file.FullName
			#Loop through each line for the file
			for ($i = 1; $i -lt $filetext.Length; $i++)
			   { 

				   if(($filetext[$i] -like $KeyWord))
				   {
					$output= New-Object psobject
					$output | Add-Member NoteProperty "FileName" $file.Name
					$output | Add-Member NoteProperty "Date" $filetext[$i].Split("|")[0]
					$output | Add-Member NoteProperty "Module" $filetext[$i].Split("|")[1]
					$output | Add-Member NoteProperty "ErrorMessage" $filetext[$i].Split("|")[2]
					#Write-Host $i
					#$output | Export-Csv C:\Logfiles\1.csv
					$output
				   }

					 #Display progress bar to show progress
					$filesprocessed = "$filecounter of $filecount"                      
					Write-Progress -Id 1 -activity "Parsing files" -status "Files parsed: $filesprocessed" -percentComplete (($filecounter / $filecount)  * 100) 


			   }

	#Increment file counter used in progress bar
    $filecounter++
	   }
	}
}

Analyze_LogFile_V3 | Export-Csv C:\LogFiles\2.csv



#
#Parse and Analyze log file in xml format.
# *.xml as the source format
# Usage: Analyze_XML_Log_File_V1 | Export-Csv C:\LogFiles\2.csv
function Analyze_XML_Log_File_V1 {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$DirPath="C:\Data\LNGitProject\LN-PS-Functions\",
	[Parameter(HelpMessage="Enter Log File Path, eg C:\Logfiles\*.txt")][string]$FilePattern="*.xml",
    [Parameter(HelpMessage="Enter KeyWord Search through the files, eg Error:")][string]$KeyWord="The physical drive has failed."
)

	if(Test-Path $DirPath)
	{
	   foreach($file in Get-ChildItem -Filter $FilePattern $DirPath | Where {$_.psIsContainer -eq $false} )
	   {
	          #Create new XML object
			  [System.Xml.XmlDocument] $xd = new-object System.Xml.XmlDocument

			  #Load XML file
			  $xd.load($file.FullName)   

			#Get Physical Drives
			$drives = $xd.SelectNodes("//Device") | Where {$_.devicetype -eq "PhysicalDrive"}
			#Loop through each drive
            foreach ($drive in $drives)
			{
				#Create PowerShell object to hold data
				$Output = New-Object psobject

				#Add filename member to PowerShell object
				$Output | add-member NoteProperty "Filename" $file.FullName
            
				#Get device type and add to PowerShell Object      
				$Output | add-member NoteProperty "Devicetype" $drive.devicetype

				#Get drive ID and add to PowerShell Object
				$Output | add-member NoteProperty "Drive ID" $drive.id

				#Get marketing name and add to PowerShell Object
				$Output | add-member NoteProperty "MarketingName" ($drive.marketingName).ToString().ToUpper()

				#check if drive logged a failure
				$driveerror = ($drive.errors).message | where {$_.message -eq $KeyWord}
				if ($driveerror.message -match $KeyWord) 
				{
				$Output | add-member NoteProperty "Marked as Failed" "Yes"
				}                    
				else 
				{
				$Output | add-member NoteProperty "Marked as Failed" "No"
				}

				 #Output the PowerShell object data                          
				$Output

			}    
			
	   }
	}
}

Analyze_XML_Log_File_V1






