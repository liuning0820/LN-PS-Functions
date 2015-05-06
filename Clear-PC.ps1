function Clear-All-EventLog
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $computername
    

    )
    
    Begin
    {
        $logs = get-eventlog -computername $computername -list | foreach {$_.Log}
            
    }
    Process
    {
        $logs | foreach {clear-eventlog -comp $computername -log $_ }
    }
    End
    {
    }
}


#Example:Clear-All-EventLog
Clear-All-EventLog -computername "niliu18"
	
	
	
<#
	.SYNOPSIS
		Clears Internet Explorer Cached Data
	
	.DESCRIPTION
		A detailed description of the Clear-IECachedData function.
	
	.PARAMETER AddOnSettings
		Delete Files and Settings Stored by Add-Ons
	
	.PARAMETER All
		Delete All
	
	.PARAMETER Cookies
		Delete Cookies
	
	.PARAMETER FormData
		Delete Form Data
	
	.PARAMETER History
		Delete History
	
	.PARAMETER Passwords
		Delete Passwords
	
	.PARAMETER PipelineVariable
		A description of the PipelineVariable parameter.
	
	.PARAMETER TempIEFiles
		Delete Temporary Internet Files
	
	.EXAMPLE 1
		PS C:\> Clear-IECachedData -TempIEFiles
	
	.EXAMPLE 2
		PS C:\> Clear-IECachedData -Cookies

	.EXAMPLE 3
		PS C:\> Clear-IECachedData -History

	.EXAMPLE 4
		PS C:\> Clear-IECachedData -FormData

	.EXAMPLE 5
		PS C:\> Clear-IECachedData -Passwords

	.EXAMPLE 6
		PS C:\> Clear-IECachedData -All

	.EXAMPLE 7
		PS C:\> Clear-IECachedData -AddOnSettings
			
	.NOTES
		Feedback: Chendrayan.exchange@hotmail.com
#>
function Clear-IECachedData
{
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[Parameter(Mandatory = $false,
				   HelpMessage = ' Delete Temporary Internet Files')]
		[switch]
		$TempIEFiles,
		[Parameter(HelpMessage = 'Delete Cookies')]
		[switch]
		$Cookies,
		[Parameter(HelpMessage = 'Delete History')]
		[switch]
		$History,
		[Parameter(HelpMessage = 'Delete Form Data')]
		[switch]
		$FormData,
		[Parameter(HelpMessage = 'Delete Passwords')]
		[switch]
		$Passwords,
		[Parameter(HelpMessage = 'Delete All')]
		[switch]
		$All,
		[Parameter(HelpMessage = 'Delete Files and Settings Stored by Add-Ons')]
		[switch]
		$AddOnSettings
	)
	if ($TempIEFiles) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8}
	if ($Cookies) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2}
	if ($History) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 1}
	if ($FormData) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 16}
	if ($Passwords) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 32 }
	if ($All) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 255}
	if ($AddOnSettings) { RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351 }
}


#Example:
Clear-IECachedData -All


  <# 
   .Synopsis 
    This function empty Folder Deleted items from default Outlook profile 
   .Description 
    This function empty Folder Deleted items from default Outlook profile. It 
    uses the Outlook interop assembly to use the olFolderInBox enumeration. 
       
    NAME:  Clear-OutlookDeletedItems
 #> 

Function Clear-OutlookDeletedItems 
{ 

 Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null 
 $olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type]  
 $outlook = new-object -comobject outlook.application 
 $namespace = $outlook.GetNameSpace("MAPI") 
 $folder = $namespace.getDefaultFolder($olFolders::olFolderDeletedItems) 
 $folder.items |  
 Select-Object -Property Subject, ReceivedTime, Importance, SenderName 

 foreach ($item in $folder.items)
 {
     $item.Delete()
 }
}


#Example:
Clear-OutlookDeletedItems 