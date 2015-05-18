
#11/25/2014
#Return Serive Tag for machines in the lab
#Harry Hoa Huynh 

$script:ErrorActionPreference = "SilentlyContinue"
$DebugPreference = "continue silently"
Set-StrictMode -Version 1

#------------------Functions------------------------------------
#Function: Get list of machines
function get-mach($arguments) {

	#Initialize
	$ou_OBJ 		= $null
	$computer_OBJ 	= $null
	
	foreach ($arg in $arguments) {

		<#
		These variables will be used to check if the argument passed
		is a computer or OU object that exists in Active Directory
		#>
		$ou_OBJ 		= Get-ADOrganizationalUnit -Filter 'name -eq $arg'
		$computer_OBJ 	= Get-ADComputer -Filter 'name -eq $arg'
	
		if ($ou_OBJ){
			#argument is an OU
			$OU_DN = $ou_OBJ.distinguishedname
			$machines += Get-ADComputer -SearchBase $OU_DN -filter * | Select Name | Sort-Object Name
		}
		elseif ($computer_OBJ) {
			#argument is a computer
			$machines += Get-ADComputer $arg
		}
		else {
			#not sure what argument is
			Write-Debug "I don't understand"
		}
	}
	
	return $machines
 }   

#--------------------#Main Program#--------------------------#   
$machines 	= @()
$online 	= @() #list of all offline machines
$offline 	= @() #list of all online machines

funHelp($args) 
$MachineList = get-mach($args)
$localmachine = "LocalMachine"

write-host "--------Good Machines-------" -Foregroundcolor Yellow
foreach ($mach in $MachineList)
    {

    $servicetag = gwmi win32_systemenclosure –computername $mach.name
    write-host $mach.name $servicetag.SerialNumber
    }


    
