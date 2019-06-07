function Set-PSCMSoftwareUpdateGroupDeploymentDeadline {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER UpdateGroupName
    Parameter description

    .PARAMETER DateTime
    Parameter description

    .PARAMETER DayOfWeek
    Parameter description

    .PARAMETER TimeOfDay
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    This function will probably be renamed and reworked
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $UpdateGroupName,
        # Parameter help description
        [Parameter(Mandatory)]
        [datetime]
        $DeadlineDateTime,
        # Parameter help description
        [Parameter(Mandatory)]
        [datetime]
        $AvailableDateTime
        # Parameter help description
        #[ValidateSet('Sunday,''Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')]
        #[Parameter(Mandatory, ParameterSetName = 'Simple')]
        #[string]
        #$DayOfWeek,
        # Parameter help description
        #[ValidatePattern("([0-1][0-9]|2[0-3]):[0-5][0-9]")]
        #[Parameter(ParameterSetName = 'Simple')]
        #[string]
        #$TimeOfDay = "00:00"
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("bleh")) {
            Get-CMUpdateGroupDeployment -Name $UpdateGroupName | Set-CMSoftwareUpdateDeployment -AvailableDateTime $AvailableDateTime -DeploymentExpireDateTime $DeadlineDateTime
        }
    }

    end {
    }
}
