[CmdletBinding()]
param ()

#require -Modules ImportExcel, PsSigParser

$File = 'Childrens Healthcare of Atlanta - Sig Mapping Utility 2022-07-06 134643.xlsm'
$Path = Join-Path $PSScriptRoot $File

Import-Excel -Path $Path -WorksheetName 'UnmappedUsage' -StartRow 6 |
    Where-Object { $_.Verified -eq 'No' } | 
    # Select-Object -ExcludeProperty Usage,Benefit,Verified | 
    Select-Object Sig,Dose,DoseUnit,Route,Frequency | 
    Invoke-SigParser |
    Select-Object Sig,Dose,DoseUnit,Route,Frequency | 
    ConvertTo-Csv | Out-File UnmappedUsage.csv
    # Format-Table
