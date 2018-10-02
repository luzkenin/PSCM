# PSCM
Powershell module to aid in deploying updates from SCCM.

## Functions
Add-PSCMObjectToCollection
* Simplifies adding computers to collections.

Clear-PSCMSoftwareUpdateGroup
* Clear a software update group of superseded or expired updates.

Connect-PSCMServer
* Loads ConfigurationManager module and creates the PSDrive for the site.

Copy-PSCMSoftwareUpdateGroup
* Copies a software update group. Does not copy deployments.

Find-PSCMUpdates
* Finds updates with simplified query.

Get-PSCMSoftwareUpdateProductCategory
* Shows product categories for specified products. Useful for getting CategoryInstance_UniqueID.

Merge-PSCMSoftwareUpdateGroup
* Merge two software update groups.

New-PSCMCIMSession
* Creates a CIM hash for a CIMSession for SCCM.

Sync-PSCMMetaData
* Wrapper for Sync-CMSoftwareUpdate that will give you output for what is happening and wait until its done.
