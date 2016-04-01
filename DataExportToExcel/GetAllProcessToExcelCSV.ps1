#
# GetAllProcessToExcelCSV.ps1
#

Get-Process | Export-Csv -NoType c:\Temp\ps.csv
Invoke-Item c:\Temp\ps.csv
