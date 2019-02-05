function Get-NextDay {
    [CmdletBinding()]
    param (
        # Parameter help description
        [ValidateSet('Sunday,''Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')]
        [Parameter(Mandatory)]
        [string]
        $Day,
        # Parameter help description
        [Parameter()]
        [string]
        $Time
    )
    
    begin {
    }
    
    process {
        if($Time) {
            $SplitTime = $Time.Split(":")
            $date = Get-Date -Hour $SplitTime[0] -Minute $SplitTime[1] -Second 00
        }
        else {
            $date = Get-Date
        }

        for($i=1; $i -le 7; $i++)
        {        
            if($date.AddDays($i).DayOfWeek -eq $Day)
            {
                $date.AddDays($i)
                break
            }
        }
    }
    
    end {
    }
}