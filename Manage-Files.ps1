#
# Compare_Files.ps1
#


Function Compare-Files{
param(
    [Parameter(Mandatory=$True)]
    [string] $referenceobject,
    [Parameter(Mandatory=$True)]
    [string] $differenceobject
)

$source = Get-Content -Path $referenceobject
$targe = Get-Content -Path $differenceobject

Compare-Object $source $targe -IncludeEqual



}


#Example
#Compare-Strings -referenceobject "C:\Users\niliu\Downloads\old.txt" -differenceobject "C:\Users\niliu\Downloads\new.txt"


Function Rename-Files-In-Bunch{
param(
    [Parameter(Mandatory=$False)]
    [string] $prefix="[www.2tu.cc]",
	[Parameter(Mandatory=$false)]
    [string] $FileRoot = "G:\"
)


#(ls *.mp4).count


$prefix =  [regex]::escape($prefix)
echo $prefix

cd $FileRoot
ls *.mp4 | %{ Move-Item -literalpath $_ ($_.name -replace "^$prefix",'') }

}

#Example:

Rename-Files-In-Bunch

