# PSCM
Powershell module to aid in deploying updates from SCCM.

## Functions
Add-PSCMObjectToCollection
* Simplifies adding computers to collections.

Clear-PSCMSoftwareUpdateGroup.ps1
* Clear a software update group of superseded or expired updates.

Connect-PSCMServer.ps1
* Loads ConfigurationManager module and creates the PSDrive for the site.

Copy-PSCMSoftwareUpdateGroup.ps1
* Copies a software update group. Does not copy deployments.

Find-PSCMUpdates.ps1
* Finds updates with simplified query.

Get-PSCMSoftwareUpdateProductCategory.ps1
* Shows product categories for specified products. Useful for getting CategoryInstance_UniqueID.

Merge-PSCMSoftwareUpdateGroup.ps1
* Merge two software update groups.

New-PSCMCIMSession.ps1
* Creates a CIM hash for a CIMSession for SCCM.

Sync-PSCMMetaData.ps1
* Wrapper for Sync-CMSoftwareUpdate that will give you output for what is happening and wait until its done.
