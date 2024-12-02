#WingetNotFound by PowerToys
Import-Module -Name Microsoft.WinGet.CommandNotFound
#Display file icons
Import-Module -Name Terminal-Icons
###
#Chocolatey
###
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
###
#PSFzf
###
Import-Module PSFzf
# Path search with fzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+Shift+f' 
# History search with fzf 
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
# Override default tab completion
Set-PsFzfOption -TabExpansion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }