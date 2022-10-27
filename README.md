# PsSigParser

## Usage

```powershell
#require -Modules ImportExcel, PsSigParser

$File = 'Sig.csv'
$Path = Join-Path $PSScriptRoot $File

Get-Content -Path $Path | ConvertFrom-Csv |
    Invoke-SigParser |
    # desired column order
    Select-Object Sig,Dose,DoseUnit,Route,Frequency | 
    ConvertTo-Csv | Out-File Parsed.csv
```
