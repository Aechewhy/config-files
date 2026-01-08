# Import modules
# . "$PSScriptRoot\Scripts\modules.ps1"
# Import aliases
. "$PSScriptRoot\Scripts\aliases.ps1"
. "$PSScriptRoot\Scripts\symlink.ps1"
######################################################
#OH MY POSH
###################################################### 
oh-my-posh init pwsh --config "C:\Users\LENOVO LEGION\OneDrive - Hanoi University of Science and Technology\Documents\oh-my-posh-themes\emodipt-extend.omp.json" | Invoke-Expression
#Shell integration for windows terminal, must put below oh my posh init
. "$PSScriptRoot\Scripts\shellIntegration.ps1"
#Zoxide initalization
Invoke-Expression (& { (zoxide init powershell | Out-String) })
function syml {
    param($link, $target)
    New-Item -ItemType SymbolicLink -Path $link -Target $target
}