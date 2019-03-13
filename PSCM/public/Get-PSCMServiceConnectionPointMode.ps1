function Get-PSCMServiceConnectionPointMode {
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        $OfflineProps = (Get-CMServiceConnectionPoint).Properties.properties.props | where propertyname -eq "OfflineMode"
        if ($OfflineProps.Value -eq "1") {
            $Mode = "Offline"
        }
        elseif ($OfflineProps.Value -eq "0") {
            $Mode = "Online"
        }
        else {
            $Mode = "Unknown"
        }
        $Mode
    }

    end {
    }
}