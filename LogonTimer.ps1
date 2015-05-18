### Measuer the time it takes for a user to logon to a machine
##Bat File Command: Powershell.exe -noexit -executionpolicy remotesigned -File  C:\Logon_Data\LogonTimer.ps1 

###General Information of The Current Computer/ User
$whois = [Environment]::UserName
$whichcomp = [Environment]::MachineName

###Collect LogonTime
$temp =
Get-WmiObject Win32_NetworkLoginProfile |
Sort -Descending LastLogon |
Select * -First 1 

$LoggedOnTime = $temp.LastLogon.substring(0,14)
$LoggedOnTime_converted = [datetime]::ParseExact($LoggedOnTime, “yyyyMMddHHmmss”, $null)


###Collect the time that the machine is ready to use
$details2 = Get-Date 


###Calculate the amount of time it needs for the whole process
$time = $details2.TimeOfDay.TotalSeconds - $LoggedOnTime_converted.TimeOfDay.TotalSeconds 



$output = "Hostname: $($whichcomp)  Name:$($whois) Log-On Time:$($time) = $($details2.TimeOfDay.TotalSeconds) - $($LoggedOnTime_converted.TimeOfDay.TotalSeconds)///$($LoggedOnTime_converted) "

#write-host $output
$output | Out-File -Append C:\templastuser.txt
