function slink {
    [CmdletBinding()]
    param(
        [Alias('f')]
        [switch]$Force,               # Now -Force and -f both work
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Link,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Target
    )

    if ($Force) {
        if (Test-Path $Link) {
            Remove-Item $Link -Force -Recurse
        }
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target -ErrorAction Stop
        Write-Host "Forced overwrite: Replaced `'$Link`' → `'$Target`'"
    }
    else {
        try {
            New-Item -ItemType SymbolicLink -Path $Link -Target $Target -ErrorAction Stop
            Write-Host "Created symlink: `'$Link`' → `'$Target`'"
        }
        catch {
            Write-Warning "Cannot create symlink because `'$Link`' already exists. Use `-Force` (or `-f`) to overwrite."
        }
    }
}
