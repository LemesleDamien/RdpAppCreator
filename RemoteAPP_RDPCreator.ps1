
#Création des différentes variables
param (
    
    [string]$username,

    
    [string]$password,

    
    [string]$address,

    
    [string]$application,


    [switch]$Help

)

function Show-Help {
    Write-Host "Utilisation: rdp.ps1 -USERNAME <nom_utilisateur> | -PASSWORD <mot_de_passe> | -address <Adresse_Ip> | -application <nom_de_l_application>"
    Write-Host ""
    Write-Host "Paramètres :"
    Write-Host "-USERNAME <nom_utilisateur> : Spécifie le nom d'utilisateur pour la connexion au Bureau à distance."
    Write-Host "-PASSWORD <mot_de_passe> : Spécifie le mot de passe pour la connexion au Bureau à distance."
    Write-Host "-ADDRESS <Adresse_Ip> : Spécifie l'addresse IP pour la connexion au Bureau à distance."
    Write-Host "-APPLICATION <nom_de_l_application> : Spécifie le nom de l'application mais également le nom du fichier rdp pour la connexion au Bureau à distance."
    Write-Host ""
    Write-Host "Exemple d'utilisation :"
    Write-Host "rdp.ps1 -USERNAME myusername -PASSWORD mysecuredpassword -ADDRESS 192.168.1.100 -APPLICATION TEST"
}
if (-not $username -or -not $password -or -not $address -or -not $application) {
       Show-Help
        exit
}
# Vérification si l'option -Help est spécifiée
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-Help
    exit
}

New-Item rdp.txt
$secureString = ($password | ConvertTo-SecureString -AsPlainText -Force) | ConvertFrom-SecureString

Set-Content rdp.txt "allow desktop composition:i:1
allow font smoothing:i:1
alternate full address:s:$address
alternate shell:s:rdpinit.exe
devicestoredirect:s:*
disableremoteappcapscheck:i:1
drivestoredirect:s:*
full address:s:$address
prompt for credentials on client:i:1
promptcredentialonce:i:0
redirectcomports:i:1
redirectdrives:i:1
remoteapplicationmode:i:1
remoteapplicationname:s:$application
remoteapplicationprogram:s:||$application
span monitors:i:1
use multimon:i:1
username:s:$username
password 51:b:$secureString"

If ((Test-Path "$env:USERPROFILE\Desktop\$application.rdp") -eq $True) {Remove-item $env:USERPROFILE\Desktop\$application.rdp}

Rename-Item -Path "rdp.txt" -NewName "$application.rdp"

Move-Item -Path "$application.rdp" -Destination "$env:USERPROFILE\Desktop\$application.rdp"