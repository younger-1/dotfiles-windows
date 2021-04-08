$PRO = $PSCommandPath


. $PSScriptRoot/completion-gh.ps1
. $PSScriptRoot/completion-rustup.ps1
. $PSScriptRoot/completion-procs.ps1
. $PSScriptRoot/completion-rg.ps1



#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Users\younger\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

