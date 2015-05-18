
#11/14/2014
#Return the list of machines that are good (Pingable) and down machines; 
#Also indicate either the machine is logged (Yellow Background) into or not (Green) Background
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
        $pingStatus1 = Test-Connection -ComputerName $mach.name -count 1 -BufferSize 16 -quiet              #send out pings of 1 bit

        if ($pingStatus1 -eq "True") #If Machine is ONLINE
            {
                $online += $mach
            
                $currentstatus = Get-WmiObject -Class win32_process  -computer $mach.name -Filter "name='explorer.exe'" | Foreach-Object {  $_.GetOwner() }  #check the currentstatus of machine
                if ($currentstatus.Domain -eq "AD") #if Machine is Logged Into there will be returned parameters (AD; Username, etc)/ if its not logged into, the returned would be null.
                {Write-Host $mach.name -ForegroundColor Yellow} #Yellow = Logged Into
                else
                {Write-Host $mach.name -ForegroundColor Green} # Gree = Not Logged Into
            }
        else 
            {
            $offline +=$mach
            } 
     }       

       write-host "--------Bad machines--------" -Foregroundcolor RED
       foreach ( $mach in $offline)
       {
                write-host $mach.name -Foregroundcolor Red
       } 
      

    
