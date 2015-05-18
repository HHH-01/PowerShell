###Get user profile's size. And delete it as an input command from user

#Get-Directory Function / Still get an access denied in some folders (Application Data, History, Temporary Internet Files)
function Get-DirectorySize() {
  param ([string]$root = $(resolve-path .))
  gci -ErrorAction SilentlyContinue -Force -re $root |
    ?{ -not $_.PSIsContainer }  | 
    measure-object -sum -property Length 
}

#Show Hidden files, folders, and all drivers
function Show_HiddenItem() {
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
}

###General Information of The Current Computer/ User
$whois = [Environment]::UserName
$whichcomp = [Environment]::MachineName

###Create the string of location foloder
$strlocation = "C:\Users\" + $whois + "\AppData"

### Show all hidden folders
Show_HiddenItem

###Get the size of AppData Folder
#Get-ChildItem $strlocation | Measure-Object -property length -sum
$maximum_size = 500
#$used_size = (Get-DirectorySize $strlocation).sum
$used_size = [math]::round((((Get-DirectorySize $strlocation).Sum)/ 1e6) , 4)
$free_size = [math]::round($maximum_size - $used_size, 4)



###Power Shell Output
Write-Host $strlocation
Write-Host "User Name:" $whois
Write-Host "Host Name:" $whichcomp
Write-Host "Maximum Space You Can Have (MB):" $maximum_size
Write-Host "Used Space (MB):"$used_size
Write-Host "Available Space (MB):" $free_size
Write-Host "-------------------------------------"

###Follow Up with Suggestion
if ($free_size -gt 0)
    {
        Write-Host "Please Maintain Your Profile Under" $maximum_size "MB! `nCSE Systems Staff\operator@cselabs.umn.edu" -ForegroundColor Yellow

    }
else
    { 
        $temp = [math]::abs($free_size)
        write-host "Your Profile Is Over the Quota by" $temp "MB, Please Clean Up Your Profile In Order To Avoid Data Loss `nCSE Systems Staff\operator@cselabs.umn.edu" -ForegroundColor Red
        }

###HTML Output Result
#$output |Select-Object Name, Value | ConvertTo-Html | Out-File C:\PowerShell\UserProfile\User\Test.htm 
#Invoke-Expression C:\PowerShell\UserProfile\User\Test.htm
