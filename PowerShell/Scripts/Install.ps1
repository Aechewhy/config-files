#This file is the script to install everything needed for pwsh
#Install scoop first
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop update
#add a nerdfont to run oh my posh
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF-Mono
#Import apps fromt installers
winget import WingetApps.json
scoop import scoopfile.json
#Update apps from installers
winget upgrade --all --Force
scoop update *
#Update all modules
."$PSScriptRoot/Update-AllPowerShellModules.ps1"
.$PROFILE