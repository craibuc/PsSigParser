
function Invoke-SigParser 
{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$Sig
    )

    begin {

        $Components = @{
            Dose = @{
                Mass = "(?'qty'\d*,?\.?\d+)\s(?'unit'MCG|MG|G|UNITS)"
                Piece = "(?'qty'\d+\-?\d*)\s(?'unit'TABLET|PUFF|SPRAY|DROP|PACKET|EACH|VIAL)"
                Volume = "(?'qty'\d*,?\.?\d+)\s(?'unit'ML)"
            }
            Route = @{
                # lungs
                Inhalation = 'INHALE|INTO LUNGS'
                Nebulization = 'BY NEBULIZATION'
                # skin
                Topical = 'APPLY TOPICALLY'
                # muscle
                Injection = 'INJECTION'
                IM = 'INTO.*MUSCLE'
                # ears
                'Both Ears' = 'BOTH EARS'
                'Left Ear' = 'LEFT EAR'
                'Right Ear' = 'RIGHT EAR'
                # eyes
                'Both Eyes' = 'BOTH EYES'
                'Left Eye' = 'LEFT EYE'
                'Right Eye' = 'RIGHT EYE'
                # nose
                Intranasal = 'INTO.*NOSE'
                # mouth
                Sublingual = 'UNDER.*TONGUE'
                Oral = 'BY MOUTH'
                # misc
                'Miscell. (Med.Supl.;Non-Drugs)' = 'MISCELL MED SUPL'
            }
            # using an ordered dictionary to ensure that PRN is the last frequency entry
            Frequency = [ordered]@{
                # once
                X1 = 'ONCE FOR 1 DOSE'
                # once/day
                QAM = 'EVERY MORNING'
                QPM = 'EVERY EVENING'
                QHS = 'BEDTIME'
                # hourly
                BID = '2 TIMES A DAY|EVERY 12 HOURS'
                TID = '3 TIMES A DAY'
                QID = '4 TIMES A DAY'
                '5XDAY' = '5 TIMES A DAY'
                Q3H = 'EVERY 3 HOURS'
                Q4H = '6 TIMES A DAY|EVERY 4 HOURS'
                Q6H = 'EVERY 6 HOURS'
                Q8H = 'EVERY 8 HOURS'
                # daily
                QD = 'ONCE A DAY|EVERY DAY|DAILY|NOON'
                # weekly
                QW = 'EVERY WEEK'
                Q2W = 'EVERY 2 WEEKS'
                Q10D = 'EVERY 10 DAYs'
                Q90DAYS = 'EVERY 90 DAYS'
                CONTINUOUS = 'CONTINUOUS'
                PRN = 'AS NEEDED'
            }
        }

    }
    
    process {

        Write-Verbose "Process Sig: $Sig..."

        $Data = @{
            Sig = $Sig
            Dose = $null
            DoseUnit = $null
            Route = $null
            Frequency = $null
        }

        #
        # dosage and units
        #

        $Quantity,$Unit = 
            if ( $Sig -match $Components.Dose.Mass ) { [single]$Matches['qty'], $Matches['unit'] }
            elseif ( $Sig -match $Components.Dose.Piece ) { $Matches['qty'], $Matches['unit'] }
            elseif ( $Sig -match $Components.Dose.Volume ) { [single]$Matches['qty'], $Matches['unit'] }

        if ( $null -ne $Quantity -and $null -ne $Unit ) { 
            $Data.Dose = $Quantity
            $Data.DoseUnit = $Unit
        }

        #
        # route
        #

        foreach($Key in $Components.Route.Keys)
        {
            if ( $Sig -match $Components.Route[$Key] ) { $Data.Route = $Key; break }
        }
        
        #
        # frequency
        #

        $Frequency = @()

        foreach($Key in $Components.Frequency.Keys)
        {
            # add any match
            $Frequency += if ( $Sig -match $Components.Frequency[$Key] ) { $Key }   
        }

        # join the frequency elements
        if ( $Frequency.count -ne 0 ) { $Data.Frequency = $Frequency -join ' ' }

        #
        # return data to pipeline
        #

        [pscustomobject]$Data

    }
    
    end {}

}
