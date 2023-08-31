#PC Reanimation Script
#Finds deleted computers and brings them back to life, moves them to the correct OU, and re-enables their computer accounts
#This fixes the "security database does not have a computer account for this workstation trust relationship"
#by ross <3


#Note: The user running this script needs to have permissions or are in a security group with permissions over the domain and deleted items container. It will fail otherwise. 
#You can assign them to a group by running these commands on the DC:
#dsacls "dc=fmc,dc=inc" /g "fmcinc\groupname:ca;Reanimate Tombstones"
#dsacls "cn=deleted objects,dc=fmc,dc=inc" /g fmcinc\groupname:SDRPWOCCDCLCWSWPRC


#Input PC Name/Serial # for lookup. 
#Input CN
param ($TargetCN, $pcName)

Write-Output("            PC Revival Script`n        (aka digital necromancy)`n                  _\<`n                 (   >`n                 __)(`n           _____/  //   ___`n          /        \\  /  \\__`n          |  _     //  \     ||`n          | | \    \\  / _   ||`n          | |  |    \\/ | \  ||`n          | |_/     |/  |  | ||`n          | | \     /|  |_/  ||`n          | |  \    \|  |     >_ )`n          | |   \. _|\  |    < _|=`n          |          /_.| .  \/`n  *       | *   **  / * **  |\)/)    **`n   \))ejm97/.,(//,,..,,\||(,wo,\ ).((//`n                             -  \)`n          made with love by ross`n")



#Sets up search  
 
$pcSearchTerm = "*" + $pcName + "*"  
#Checked deleted objects folder for deleted computer objects matching search term  
$deletedPC = Get-ADObject -Filter {((ObjectClass -eq "Computer") -and (isDeleted -eq "TRUE")) -and (Name -like $pcSearchTerm)} -IncludeDeletedObjects -Properties *  
#Lists some info about PC  
$deletedPC | Format-List Name, LastKnownParent, Modified, objectSID, ms-Mcs-AdmPwd  
#Attempts to restore object  
try { $deletedPC | Restore-ADObject -TargetPath $TargetCN}
catch{"PC couldn't be reanimated"}

$revivedPC = Get-ADObject -Filter {Name -like $pcSearchTerm}
try{$revivedPC | Enable-ADAccount}
catch{"Could not re-enable AD Computer Account."}