#
# FindFilesAndExportToCsv.ps1
#

"`n"
write-Host  -Verbose  "---------------------------------------------" -ForegroundColor Yellow
$filePath = Read-Host -Verbose "Please Enter File Path to Search"
write-Host "---------------------------------------------" -ForegroundColor Green
$fileName = Read-Host -Verbose "Please Enter File Name to Search"
write-Host "---------------------------------------------" -ForegroundColor Yellow
"`n"



$filePath= "C:\Users\niliu\Documents\LNPicture"
$fileName = "*.mov"

Get-ChildItem -Recurse -Force $filePath -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and  ( $_.Name -like "*$fileName*") } | Select-Object Directory,Name| Export-Csv C:\1.csv -Encoding UTF8

write-Host "------------END of Result--------------------" -ForegroundColor Magenta

# end of the script



# Read file list and convert them into another format in a bunch.
Import-Csv C:\1.csv | foreach {
	$oldFileName= ($_.Directory +'\'+ $_.Name);
	write-Host $oldFileName
	$newExtension="mp4"
    $newFileName= [io.path]::ChangeExtension($oldFileName,$newExtension)
	
	C:\Users\niliu\Downloads\ffmpeg-20151105-git-a8b254e-win64-static\ffmpeg-20151105-git-a8b254e-win64-static\bin\ffmpeg.exe -i $oldFileName, -threads 2 $newFileName

	timeout(30)
	Write-Host $newFileName
	

}
