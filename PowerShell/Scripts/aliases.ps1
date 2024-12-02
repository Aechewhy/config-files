###
#cd
###
Function cd {z}
Function .. {Set-Location ..}
Function ... {
    Set-Location ..
    Set-Location ..
}
###
#$PROFILE
###
function edipro{code $PROFILE}
function relpro{.$PROFILE}
###
#EZA
###
Set-Alias -Name l -Value eza
Function ll {eza -l --color=always --icons=always}
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
