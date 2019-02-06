function Merge-PSCMSoftwareUpdateGroup
{
    <#
	.SYNOPSIS
	Merge software update groups

	.DESCRIPTION
	Merge software update groups 

	.PARAMETER Source
	Source SUG

	.PARAMETER Target
	Target SUG. Must already exist.

	.PARAMETER KeepSource
	Keep the source

	.EXAMPLE
	Merge-PSCMSoftwareUpdateGroup -Source oldone -Target newone -Confirm:$false

	.NOTES
	This is still a work in progress

	#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript( {Get-CMSoftwareUpdateGroup -name $_})]
        [String]$Source,
        [Parameter(Mandatory, Position = 1)]
        [ValidateScript( {Get-CMSoftwareUpdateGroup -name $_})]
        [String]$Target,
        [switch]$KeepSource
    )

    begin
    {
        if (-not $PSBoundParameters.ContainsKey('Confirm'))
        {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf'))
        {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    process
    {
        foreach ($SourceSUG in $Source)
        {
            $UpdatesInSource = Get-CMSoftwareUpdateGroup -Name $SourceSUG | Get-CMSoftwareUpdate -fast
            $UpdatesInTarget = Get-CMSoftwareUpdateGroup -Name $Target | Get-CMSoftwareUpdate -fast
            Write-PSFMessage "Adding $($UpdatesInSource.count) updates from $SourceSUG to $Target" -Level Important
            foreach ($Update in $UpdatesInSource)
            {
                if ($Update -notin $UpdatesInTarget)
                {
                    Write-PSFMessage "Adding $($Update.LocalizedDisplayName) to $Target SUG" -Level Important
                    $Update | Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $Target
                }
            }
            #delete source
            if ($KeepSource)
            {
                Write-PSFMessage -Message "$SourceSUG was not removed" -Level Important
            }
            elseif (-not($KeepSource) -and $PSCmdlet.ShouldProcess("Removing SUG $SourceSUG"))
            {
                Write-PSFMessage "Removing source SUG $SourceSUG" -Level Important
                Remove-CMSoftwareUpdateGroup -Name $SourceSUG -force
            }
        }
    }

    end
    {
    }
}
