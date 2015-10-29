#
# Get_EventLog.ps1
#
Get-EventLog -LogName Application -Newest 1

Get-EventLog -LogName Application -Newest 1 |select Message

Get-EventLog -LogName Application -Newest 10 -Message "*Microsoft*" |select Message

Get-EventLog -LogName Application -Newest 10 -Message "*Microsoft*" |select -expandproperty Message