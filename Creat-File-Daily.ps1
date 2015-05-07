<#
.SYNOPSIS    
    Creat-File-Daily
.DESCRIPTION 
    This task will create file using "yyyy-mm-dd" as the title.
.EXAMPLE     
    ACreat-File-Daily
.EXAMPLE
    Creat-File-Daily -Path "C\Test\" -FileExtension "txt"
.NOTES       
    Please keep above information
#>

function Creat-File-Daily {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Enter ManagedRuntimeVersion, eg 4.0")][string]$RootPath="C:\Users\niliu\OneDrive\LNDocument\Daily\",
    [Parameter(HelpMessage="Enter ManagedPipelineMode, eg 0 or 1")][string]$FileExtension="txt"
)

try{
	$FileExtension = (Get-Date -UFormat "%Y-%m-%d")+".txt";


	if (!(Test-Path -Path ($RootPath+$FileExtension)))
	{
	new-item -ItemType file -Path ($RootPath+$FileExtension)

	"[8:00-9:00]	" >>($RootPath+$FileExtension)

	}

	notepad.exe ($RootPath+$FileExtension)
}
catch{

}
    
}





<#
    .NOTES
        Created on : 2015-05-07
        Created by : Liu Ning
    .SYNOPSIS
        Wrapper function for "svn.exe update"
    .DESCRIPTION
        Bring the latest changes from the repository into the working copy (HEAD revision).
    .EXAMPLE
        Update-SvnWorkingCopy -Path C:\Data\LNSvnProject\serviceagentCen
#>
function Update-SvnWorkingCopy {
    [CmdletBinding()]
    Param (
        # The Path parameter identifies the directory of the working copy.
        [Parameter(Position=0)]
        [String]
        $Path="C:\Data\LNSvnProject\serviceagentCen"
    )
    svn.exe update "$Path"
}

#Example:
Set-Alias -Name udsvnwc -Value Update-SvnWorkingCopy
udsvnwc -Path C:\Data\LNSvnProject\serviceagentCen




