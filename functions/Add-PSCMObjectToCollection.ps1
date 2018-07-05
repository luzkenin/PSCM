function Add-PSCMObjectToCollection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Collection,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $ComputerName
    )
    
    begin {
    }
    
    process
    {
        Foreach($Computer in $ComputerName)
        {
            Write-Output "Adding $computer to $collection"
            Add-CMDeviceCollectionDirectMembershipRule -CollectionID (Get-CMCollection -Name $Collection).CollectionID -ResourceId $(Get-CMDevice -Name $Computer).ResourceID -ErrorAction Continue
        }
    }
    end {
    }
}