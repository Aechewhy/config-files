# Import aliases
. "$PSScriptRoot\Scripts\aliases.ps1"
# Import modules
. "$PSScriptRoot\Scripts\modules.ps1"
######################################################
#OH MY POSH
###################################################### 
oh-my-posh init pwsh --config "C:\Users\LENOVO LEGION\OneDrive - Hanoi University of Science and Technology\Documents\oh-my-posh-themes\emodipt-extend.omp.json" | Invoke-Expression
#Shell integration, must put below oh my posh init
. "$PSScriptRoot\Scripts\shellIntegration.ps1"
#Zoxide initalization
Invoke-Expression (& { (zoxide init powershell | Out-String) })
