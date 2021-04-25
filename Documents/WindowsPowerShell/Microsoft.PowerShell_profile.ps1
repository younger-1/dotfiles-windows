. ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1

Import-Module Pscx
function __zoxide_cd($dir) {
    Set-LocationEX $dir -ea Stop
}