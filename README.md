# PsSigParser
Parses a Sig[netur] into its component parts (i.e. dose, unit, route, frequency).

## Installation

### Generate an Azure DevOps (ADO) personal-access token (PAT)
Create a Azure DevOps personal-access token (PAT).

- Profile menu (colored circle with your initials at top-right corner in ADO) > Security > New Token
![Alt text](./ADO%20PAT.png "Create token")
- Give it a name and set its duration
- Click `Create`
- When the success window opens, copy the token
![Alt text](./ADO%20PAT%20success.png "Success")
- Store the token in a secure location

### Add the repository

```powershell
# create a credential
$Credential = [pscredential]::new('[email address]',('[ADO PAT]' | ConvertTo-SecureString -AsPlainText))

# define the repository
$Uri='https://server.domain.tld/_packaging/[RepositoryName]/nuget/v2'
$Repository = @{
    Name='[RepositoryName]'
    InstallationPolicy='Trusted'
    SourceLocation=$Uri
    PublishLocation=$Uri
    ScriptSourceLocation=$Uri
    ScriptPublishLocation=$Uri
}

# register the repo
Register-PSRepository @Repository -Credential $Credential
```

### Install the module
```powershell
Install-Module PsSigParser -Repository [RepositoryName] -Scope CurrentUser
```

### Add the module to PowerShell session
```powershell
Import-Module PsSigParser
```

## Usage

```powershell
#require PsSigParser

'INJECT 0.3 ML (0.15 MG) INTO THE MUSCLE ONCE FOR 1 DOSE',
'TAKE 0.5 TABLETS (2 MG) BY MOUTH EVERY 12 HOURS AS NEEDED FOR NAUSEA/VOMITING',
'TAKE 9 ML (720 MG) BY MOUTH 2 TIMES A DAY FOR 10 DAYS',
'GIVE 1 EACH BY INJECTION AS NEEDED (FOR INSULIN PENS PREMEALS SNACKS BEDTIME AND PRN MAX DAILY 6-9 TIMES)',
'TAKE 1 TABLET BY MOUTH 2 TIMES A DAY ON SUN AND SAT',
'TAKE 10 ML (30 MG) BY MOUTH 2 TIMES A DAY FOR 5 DAYS',
'TAKE 2 TABLETS (8 MG) BY MOUTH EVERY 8 HOURS AS NEEDED FOR NAUSEA/VOMITING',
'TAKE 1 TABLET (1,000 UNITS) BY MOUTH ONCE A DAY',
'TAKE 1 PACKET (17 G) BY MOUTH ONCE A DAY',
'TAKE 8.5 G BY MOUTH ONCE A DAY',
'TAKE 1 TABLET (75 MCG) BY MOUTH ONCE A DAY',
'TAKE 1 ML BY MOUTH ONCE A DAY',
'TAKE 1 CAPSULE (50,000 UNITS) BY MOUTH ONCE EVERY WEEK',
'1 VIAL EVERY 3 HOURS AS NEEDED FOR COUGH OR WHEEZE' |
    Invoke-SigParser |
    Select-Object Sig,Dose,DoseUnit,Route,Frequency | 
    Format-Table

Sig                                                                                                        Dose DoseUnit Route     Frequency
---                                                                                                        ---- -------- -----     ---------     
INJECT 0.3 ML (0.15 MG) INTO THE MUSCLE ONCE FOR 1 DOSE                                                    0.15 MG       IM        X1
TAKE 0.5 TABLETS (2 MG) BY MOUTH EVERY 12 HOURS AS NEEDED FOR NAUSEA/VOMITING                                 2 MG       Oral      BID PRN       
TAKE 9 ML (720 MG) BY MOUTH 2 TIMES A DAY FOR 10 DAYS                                                       720 MG       Oral      BID
GIVE 1 EACH BY INJECTION AS NEEDED (FOR INSULIN PENS PREMEALS SNACKS BEDTIME AND PRN MAX DAILY 6-9 TIMES)     1 EACH     Injection QHS QD PRN    
TAKE 1 TABLET BY MOUTH 2 TIMES A DAY ON SUN AND SAT                                                           1 TABLET   Oral      BID
TAKE 10 ML (30 MG) BY MOUTH 2 TIMES A DAY FOR 5 DAYS                                                         30 MG       Oral      BID
TAKE 2 TABLETS (8 MG) BY MOUTH EVERY 8 HOURS AS NEEDED FOR NAUSEA/VOMITING                                    8 MG       Oral      PRN
TAKE 1 TABLET (1,000 UNITS) BY MOUTH ONCE A DAY                                                            1000 UNITS    Oral      QD
TAKE 1 PACKET (17 G) BY MOUTH ONCE A DAY                                                                     17 G        Oral      QD
TAKE 8.5 G BY MOUTH ONCE A DAY                                                                              8.5 G        Oral      QD
TAKE 1 TABLET (75 MCG) BY MOUTH ONCE A DAY                                                                   75 MCG      Oral      QD
TAKE 1 ML BY MOUTH ONCE A DAY                                                                                 1 ML       Oral      QD
TAKE 1 CAPSULE (50,000 UNITS) BY MOUTH ONCE EVERY WEEK                                                    50000 UNITS    Oral      QW
1 VIAL EVERY 3 HOURS AS NEEDED FOR COUGH OR WHEEZE                                                            1 VIAL               PRN
```
