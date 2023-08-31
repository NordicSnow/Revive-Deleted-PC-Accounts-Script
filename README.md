# Revive-Deleted-PC-Accounts-Script
A PowerShell script to bring back deleted PCs by providing a part of a name and a canonical name to move the item into.

Finds deleted computers and brings them back to life, moves them to the correct OU, and re-enables their computer accounts
### This fixes the "security database does not have a computer account for this workstation trust relationship" error

## Note: The user running this script needs to have permissions or are in a security group with permissions over the domain and deleted items container. It will fail otherwise. 
You can assign them to a group by running these commands on the DC:
```
dsacls "dc=fmc,dc=inc" /g "fmcinc\groupname:ca;Reanimate Tombstones"
dsacls "cn=deleted objects,dc=fmc,dc=inc" /g fmcinc\groupname:SDRPWOCCDCLCWSWPRC
```
