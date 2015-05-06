function Get-HardwareInfo
{
<#
.Synopsis
   This script is an example of how to collect hardware infomration from one or more computers using WMI.
.DESCRIPTION
   This script is an example of how to collect hardware infomration from one or more computers using WMI. The script will accept a single computer name or an array of computer names to collect from.

   This script is dependent on accessing WMI on the local or remote computer.  As such the user executing the script must have permissions to access WMI on the local or remote computer.  When calling remote computers, the remote host must allow for remote WMI calls.  By default Windows Server 2003 hosts have no firewall and will therefore respond to WMI queries.  However, by default newer Windows OS versions have the Winows Firewall enabled and will not allow such access.  Opening the inbound firewall rule "Windows Management Instrumentation (WMI-In)" should be sufficient to provide access.
.EXAMPLE
   .\Collect-HardwareInfo.ps1
.EXAMPLE
   .\Collect-HardwareInfo.ps1 -ComputerName Computer1
.EXAMPLE
   .\Collect-HardwareInfo.ps1 -ComputerName Computer1,Computer2
.EXAMPLE
    Get-Content .\Computers.txt | .\Collect-HardwareInfo.ps1
.EXAMPLE
    Get-Content .\Computers.txt | .\Collect-HardwareInfo.ps1 | Export-Csv -Path .\ComputerInfo.csv -Force -Encoding ASCII -NoTypeInformation
#>
[CmdletBinding()]
Param (
        [Parameter(Position=0,
            Mandatory=$false, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName
    )

begin{   

}
process{
    $ComputerNames += $ComputerName
}
end{
    if(!($ComputerNames)){$ComputerNames="localhost"}
    $ComputerInfo = @()
    Foreach($ComputerName in $ComputerNames)
    {
        $System = Get-WmiObject -ComputerName $ComputerName -Class Win32_ComputerSystem -Property DNSHostName,Domain,DomainRole,Manufacturer,Model,NumberOfProcessors,PartOfDomain,PrimaryOwnerContact,PrimaryOwnerName,SystemType,TotalPhysicalMemory,UserName,Workgroup
        $OS = Get-WmiObject -ComputerName $ComputerName -Class Win32_OperatingSystem -Property Version,Caption,Organization,RegisteredUser,OSLanguage,ServicePackMajorVersion,ServicePackMinorVersion
        $CPUs = Get-WmiObject -ComputerName $ComputerName -Class Win32_Processor -Property Caption,Manufacturer,Name
        $LogicalDisks = Get-WmiObject -ComputerName $ComputerName -Class Win32_LogicalDisk -Property DeviceID,BlockSize,Caption,Description,FileSystem,FreeSpace,Name,NumberOfBlocks,Size,VolumeName
        $DiskPartitions = Get-WmiObject -ComputerName $ComputerName -Class Win32_DiskPartition -Property Name,Caption,DeviceID,BlockSize,BootPartition,Description,NumberOfBlocks,PrimaryPartition,Size
        $DiskDrives = Get-WmiObject -ComputerName $ComputerName -Class Win32_DiskDrive -Property Name,DeviceID,Caption,Model,Description,Manufacturer,MediaType,InterfaceType,Partitions,Size
        $NICs = Get-WmiObject -ComputerName $ComputerName -Class Win32_NetworkAdapterConfiguration -Property Description,Caption,MACAddress,DHCPEnabled,DHCPServer,IPAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder,DNSDomain  | Where-Object{$_.MACAddress}
        $Shares = Get-WmiObject -ComputerName $ComputerName -Class Win32_Share -Property Name,Caption,Description,Path,AccessMask,AllowMaximum,MaximumAllowed

        $Props=[ordered]@{
            "SystemDNSHostName"=$System.DNSHostName;
            "SystemDomain"=$System.Domain;
            "SystemDomainRole"=$System.DomainRole;
            "SystemWorkgroup"=$System.Workgroup;
            "SystemManufacturer"=$System.Manufacturer;
            "SystemModel"=$System.Model;
            "SystemNumberOfProcessors"=$System.NumberOfProcessors;
            "SystemPartOfDomain"=$System.PartOfDomain;
            "SystemPrimaryOwnerContact"=$System.PrimaryOwnerContact;
            "SystemPrimaryOwnerName"=$System.PrimaryOwnerName;
            "SystemUserName"=$System.UserName;
            "SystemType"=$System.SystemType;
            "SystemTotalPhysicalMemory"=$System.TotalPhysicalMemory;
            "OSVersion"=$OS.Version;
            "OSCaption"=$OS.Caption;
            "OSOrganization"=$OS.Organization;
            "OSRegisteredUser"=$OS.RegisteredUser;
            "OSLanguage"=$OS.OSLanguage;
            "OSServicePackMajorVersion"=$OS.ServicePackMajorVersion;
            "OSServicePackMinorVersion"=$OS.ServicePackMinorVersion
        }
        $i=0
        foreach($CPU in $CPUs){
            $Props+=@{
                "CPU$($i)Caption"=$CPU.Caption;
                "CPU$($i)Manufacturer"=$CPU.Manufacturer;
                "CPU$($i)Name"=$CPU.Name
            }
            $i++
        }
        $i=0
        foreach($LogicalDisk in $LogicalDisks){
            $Props+=@{
                "LogicalDisk$($i)DeviceID"=$LogicalDisk.DeviceID;
                "LogicalDisk$($i)Caption"=$LogicalDisk.Caption;
                "LogicalDisk$($i)Description"=$LogicalDisk.Description;
                "LogicalDisk$($i)Name"=$LogicalDisk.Name;
                "LogicalDisk$($i)VolumeName"=$LogicalDisk.VolumeName;
                "LogicalDisk$($i)FileSystem"=$LogicalDisk.FileSystem;
                "LogicalDisk$($i)Size"=$LogicalDisk.Size;
                "LogicalDisk$($i)FreeSpace"=$LogicalDisk.FreeSpace;
                "LogicalDisk$($i)BlockSize3"=$LogicalDisk.BlockSize;
                "LogicalDisk$($i)NumberOfBlocks"=$LogicalDisk.NumberOfBlocks
            }
            $i++   
        }    
        $i=0
        foreach($DiskPartition in $DiskPartitions){
            $Props+=@{
                "DiskPartition$($i)Name"=$LogicalDisk.Name;
                "DiskPartition$($i)Caption"=$LogicalDisk.Caption;
                "DiskPartition$($i)DeviceID"=$LogicalDisk.DeviceID;
                "DiskPartition$($i)BlockSize"=$LogicalDisk.BlockSize;
                "DiskPartition$($i)BootPartition"=$LogicalDisk.BootPartition;
                "DiskPartition$($i)Description"=$LogicalDisk.Description;
                "DiskPartition$($i)NumberOfBlocks"=$LogicalDisk.NumberOfBlocks
            }
            $i++  
        }    
        $i=0
        foreach($DiskDrive in $DiskDrives){
            $Props+=@{
                "DiskDrive$($i)Name"=$DiskDrive.Name;
                "DiskDrive$($i)DeviceID"=$DiskDrive.DeviceID;
                "DiskDrive$($i)Caption"=$DiskDrive.Caption;
                "DiskDrive$($i)Model"=$DiskDrive.Model;
                "DiskDrive$($i)Description"=$DiskDrive.Description;
                "DiskDrive$($i)Manufacturer"=$DiskDrive.Manufacturer;
                "DiskDrive$($i)MediaType"=$DiskDrive.MediaType;
                "DiskDrive$($i)InterfaceType"=$DiskDrive.InterfaceType;
                "DiskDrive$($i)Partitions"=$DiskDrive.Partitions;
                "DiskDrive$($i)Size"=$DiskDrive.Size
            }
            $i++ 
        }    
        $i=0
        foreach($NIC in $NICs){
            $Props+=@{
                "NIC$($i)Description"=$NIC.Description;
                "NIC$($i)Caption"=$NIC.Caption;
                "NIC$($i)MACAddress"=$NIC.MACAddress;
                "NIC$($i)DHCPEnabled"=$NIC.DHCPEnabled;
                "NIC$($i)DHCPServer"=$NIC.DHCPServer;
                "NIC$($i)DNSDomain"=$NIC.DNSDomain
            }
            $j=0
            foreach($address in $NIC.IPAddress){$Props+=@{"NIC$($i)IPAddress$($j)"=$address};$j++}
            $j=0
            foreach($mask in $NIC.IPSubnet){$Props+=@{"NIC$($i)IPSubnetMask$($j)"=$mask};$j++}
            $j=0
            foreach($gateway in $NIC.DefaultIPGateway){$Props+=@{"NIC$($i)DefaultIPGateway$($j)"=$gateway};$j++}
            $j=0
            foreach($dnsserver in $NIC.DNSServerSearchOrder){$Props+=@{"NIC$($i)DNSServerSearchOrder$($j)"=$dnsserver};$j++}
            $i++
        }
        $i=0
        foreach($Share in $Shares){
            $Props+=@{
                "Share$($i)Name"=$Share.Name;
                "Share$($i)Caption"=$Share.Caption;
                "Share$($i)Description"=$Share.Description;
                "Share$($i)Path"=$Share.Path;
                "Share$($i)AccessMask"=$Share.AccessMask;
                "Share$($i)AllowMaximum"=$Share.AllowMaximum;
                "Share$($i)MaxiumAllowed"=$Share.MaxiumAllowed
            }
            $i++
        }
        $object = [pscustomobject]$Props
        $object
    }
}
}



#Example
Get-HardwareInfo