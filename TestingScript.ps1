#
# TestingScript.ps1
#

$fileName = "2015-04-22_SA_Incident_IM2314532.txt"



$output= New-Object psobject
$output | Add-Member NoteProperty "Date" $fileName.Split("_")[0]
$output | Add-Member NoteProperty "Application" $fileName.Split("_")[1]
$output | Add-Member NoteProperty "Module" $fileName.Split("_")[2]
$output | Add-Member NoteProperty "TicketNumber" $fileName.Split("_")[3]





