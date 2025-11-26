###
#PSReadLine
###
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#Set-PSReadLineKeyHandler -Key Ctrl+A -Function SelectCommandArgument
#WingetNotFound by PowerToys
Import-Module -Name Microsoft.WinGet.CommandNotFound
#Display file icons
# Import-Module -Name Terminal-Icons
###
#Chocolatey
###
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
###
#PSFzf
###
Import-Module PSFzf
# Path search with fzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+e' 
# History search with fzf 
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
# Override default tab completion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion 'Ctrl+Shift+o'
Set-PsFzfOption -GitKeyBindings
Set-PsFzfOption -EnableAliasFuzzySetEverything

# Syntax highlighting
Import-Module syntax-highlighting

. "C:\Users\LENOVO LEGION\OneDrive - Hanoi University of Science and Technology\Documents\PowerShell\Scripts\symlink.ps1"
