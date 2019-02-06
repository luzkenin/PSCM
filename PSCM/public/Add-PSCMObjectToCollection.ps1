function Add-PSCMObjectToCollection
{
    <#
    .SYNOPSIS
    Just an easier way to add an object to a collection. Probably don't even need it.

    .DESCRIPTION
    Just an easier way to add an object to a collection. Probably don't even need it.

    .PARAMETER Collection
    Collection name

    .PARAMETER ComputerName
    Device name

    .EXAMPLE
    You can prob figure this out
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Collection,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $ComputerName
    )

    begin
    {
    }

    process
    {
        Foreach ($Computer in $ComputerName)
        {
            Write-Output "Adding $computer to $collection"
            try
            {
                Add-CMDeviceCollectionDirectMembershipRule -CollectionID (Get-CMCollection -Name $Collection).CollectionID -ResourceId $(Get-CMDevice -Name $Computer).ResourceID
            }
            catch
            {
                Stop-PSFFunction -Message "Could not add $Computer to $collection" -ErrorRecord $_ -Continue
            }
        }
    }
    end
    {
    }
}