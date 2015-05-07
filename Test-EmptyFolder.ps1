## ############################################################
##	
##	Sample function to test whether a folder is empty or not
##
##	Example of calling: Test-Emptyfolder c:\Logs\
## ############################################################


Function Test-EmptyFolder( $FolderName = "C:\Kits")
{
	if ( Test-Path $FolderName)
	{
		$ListItems = Get-Item $FolderName
		$ListFiles = $ListItems.GetFiles()
		$ListDirectories =$ListItems.GetDirectories()
		$result =  ($ListFiles.Count -eq 0 ) -or ($ListDirectories.count -eq 0)
	}
	Else
	{
		$result = $False
		"Folder does not exist"
	}
	
return $result	
}
