###
#cd
###
Function cd {z}
Function .. {Set-Location ..}
Function ... {
    Set-Location ..
    Set-Location ..
}
#exit
Invoke-Expression "function q { exit }"
Invoke-Expression "function quit { exit }"
###
#$PROFILE
###
function epro{code $PROFILE}
function rpro{.$PROFILE}
###
#EZA
###
Set-Alias -Name l -Value eza
Function ll {eza -la --color=always --icons=always}
Function lt {eza -T}
Function la {eza -a}
### 
#YAZI
###
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}
###
#GIT
###
Set-Alias -Name g -Value git
Set-Alias -Name lgit -Value lazygit
###
#PsFzf
###
Function fscoop{Invoke-FuzzyScoop}
Function fk{Invoke-FuzzyKillProcess}
Function fh{Invoke-FuzzyHistory}
Function fg{Invoke-PsFzfRipgrep}
Function fe{Invoke-FuzzyEdit}
Function fcd{Invoke-FuzzySetLocation}
###For short
Set-Alias -Name yt -Value yt-dlp
Set-Alias -Name n -Value nvim
Set-Alias -Name c -Value code