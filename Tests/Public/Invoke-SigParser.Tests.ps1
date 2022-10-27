BeforeAll {
    # . $PSCommandPath.Replace('.Tests.ps1','.ps1')

    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsSigParser/Public/"

    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)
}

Describe 'Invoke-SigParser' {

    Context 'when the Sig parameter is supplied' {
        
        BeforeDiscovery {
            $FixtureDirectory = Join-Path (Split-Path -Path $PSScriptRoot -Parent) 'Fixtures'
            $TestCases = Get-Content (Join-Path $FixtureDirectory 'Sigs.csv') -Raw | ConvertFrom-Csv
        }

        It "Finds the Dose in <Sig>" -TestCases $TestCases {
            # act
            $Actual = $_.Sig | Invoke-SigParser -Debug

            # assert
            $Actual.Dose | Should -Be $_.Dose
        }

        It 'Finds the DoseUnit in <Sig>' -TestCases $TestCases {
            # act
            $Actual = $_.Sig | Invoke-SigParser

            # assert
            $Actual.DoseUnit | Should -Be $_.DoseUnit
        }

        It 'Finds the Route in <Sig>' -TestCases $TestCases {
            # act
            $Actual = $_.Sig | Invoke-SigParser

            # assert
            $Actual.Route | Should -Be $_.Route
        }

        It "Finds the Frequency in <Sig>" {
            # act
            $Actual = $_.Sig | Invoke-SigParser

            # assert
            $Actual.Frequency | Should -Be $_.Frequency
        }

    }

}