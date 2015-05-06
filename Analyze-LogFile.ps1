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






