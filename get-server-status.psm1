
Function Get-ComputerName {
<#
.Synopsis
   Prompts the user for a computername.
.DESCRIPTION
   Validates the computername to make sure it is valid by executing a WMI call against it.
.EXAMPLE
   Get-ComputerName
#>
    Do {
        $ComputerName = Read-Host "Enter the name of the machine to target"
    }
    Until (Get-WmiObject -Class Win32_Bios -ComputerName $ComputerName -ErrorAction SilentlyContinue)
    $ComputerName
}



Function Get-Uptime {
<#
.Synopsis
   Gets the uptime of a computer.
.DESCRIPTION
   Uses WMI to retrieve the last boot time for a computer and calulcates uptime.
.PARAMETER ComputerName
   Mandatory parameter of computer to query.
.PARAMETER Units
   Optional parameter of uptime units.
   Must be either "days" or "hours".
.EXAMPLE
   Get-Uptime -ComputerName server1
.EXAMPLE
   Get-Uptime -ComputerName server1 -Units Hours
.INPUTS
   String computername
.OUTPUTS
   Decimal number of uptime in total days or total hours.
.NOTES
   Default output is in days.  Use the -Units parameter to specify "days" or "hours".
#>
Param(
    [parameter(Mandatory)]
    [String]
    $ComputerName,
    [ValidateSet("Days", "Hours")]
    [String]
    $Units="Days"
)

    $WmiOS  = Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName
    $Uptime = (New-TimeSpan $WmiOS.ConvertToDateTime($WmiOS.LastBootUpTime))

    Switch ($Units) {
        "Days"  { $Uptime.TotalDays  }
        "Hours" { $Uptime.TotalHours }
    }

}



Function Get-LastPatch {
<#
.Synopsis
   Gets the last patch applied to a computer.
.DESCRIPTION
   Uses Get-HotFix to retrieve the last patch applied to a computer.
.PARAMETER ComputerName
   Mandatory parameter of computer to query.
.EXAMPLE
   Get-LastPatch -ComputerName server1
.INPUTS
   String computername
.OUTPUTS
   Hotfix object for last patch applied.
.NOTES
   The date time value of the hotfix InstalledOn property does not have a time value. Therefore it is not convenient to determine the precise last patch applied. The result returned will be one of the patches applied on the last day, not necessarily the exact last one.
#>
Param(
    [String]$ComputerName
)

    Get-HotFix -ComputerName $ComputerName | Sort-Object InstalledOn | Select-Object -Last 1

}



Function Get-Report {
<#
.Synopsis
   Gets the uptime and last patch date for a list of computers in a text file.
.DESCRIPTION
   Gets the uptime and last patch date for a list of computers in a text file.
.PARAMETER Path
   Path to the text file of computer names.
.EXAMPLE
   Get-Report -Path .\servers.txt
.EXAMPLE
   Get-Report -Path .\servers.txt -Verbose
.NOTES
   Use the -Verbose common parameter to echo each computer name as it is processed.
#>
Param(
    [parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_})]
    [String]
    $Path = ".\servers.txt"
)

    # Empty array to hold the report
    $Report = @()


    ForEach ($Target in (Get-Content $Path)) {
        
        Write-Verbose "Collecting data from $Target."

        # Check to see if the computer is online before reporting on it
        If (Get-WmiObject -Class Win32_Bios -ComputerName $Target -ErrorAction SilentlyContinue) {

            $Report += [PSCustomObject]@{
                Server = $Target;
                UptimeHours = (Get-Uptime -Units Hours -ComputerName $Target);
                PatchDate = (Get-LastPatch -ComputerName $Target).InstalledOn.ToShortDateString()
            }

        } Else {
    
            $Report += [PSCustomObject]@{
                Server = $Target;
                UptimeHours = "Offline";
                PatchDate = "Offline"
            }
    
        }
    }


    # Print all the results
    $Report

}


Export-ModuleMember -Function *
