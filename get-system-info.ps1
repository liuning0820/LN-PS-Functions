<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.Parameter ComputerName
This is for remote computers
.EXAMPLE
DiskInfo -ComputerName localhost
#>
Function Get-diskInfo{
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)]
    [string[]] $ComputerName='localhost',
    [String]$Drive='c:'
)

Get-WmiObject -Class win32_logicaldisk -Filter "DeviceID='$Drive'" -ComputerName $ComputerName
}

function get-system-info () {
    Get-diskInfo -ComputerName localhost
}





