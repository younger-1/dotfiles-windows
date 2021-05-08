<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Email: younger_321@163.com
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

# Next: PowerShell 7
# https://docs.microsoft.com/en-us/powershell/scripting/install/migrating-from-windows-powershell-51-to-powershell-7

# Reload profile
#. $profile

# Launch without profile
# pwsh -noprofile -c "\"C:\foo\bar\" -replace '\\', '/'"

# TODO
# function or script for curl/wget/aria2 to use hub.fastgit.org

# [Encoding]
# Set encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# $env:LESSCHARSET = 'utf-8'

# [rust]
# $env:RUSTUP_DIST_SERVER = "http://mirrors.rustcc.cn"
# $env:RUSTUP_UPDATE_ROOT = "http://mirrors.rustcc.cn/rustup"

# [python]
$env:PYTHONIOENCODING = 'utf-8'
# $env:PYTHONSTARTUP="$(python -m jedi repl)"
# $env:PYTHONSTARTUP = "$HOME/.pythonrc.py"
# Python 直接执行
$env:PATHEXT += ";.py"

# [julia]
$env:JULIA_PKG_SERVER = 'https://mirrors.tuna.tsinghua.edu.cn/julia'

# [elixir]
function ie { 
    iex.bat --werl
}

# [Mappings]
$PSReadLineOptions = @{
    # EditMode                      = "Vi"
    EditMode                      = "Emacs"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    PredictionSource              = "History"
    Colors                        = @{
        #"Command"   = "#b5f5ec"
        "Parameter" = [ConsoleColor]::Magenta
    }
}
Set-PSReadLineOption @PSReadLineOptions

# Dracula readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
    "Command"   = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator"  = [ConsoleColor]::Magenta
    "Variable"  = [ConsoleColor]::White
    "String"    = [ConsoleColor]::Yellow
    "Number"    = [ConsoleColor]::Blue
    "Type"      = [ConsoleColor]::Cyan
    "Comment"   = [ConsoleColor]::DarkCyan
}

## 设置键盘映射
#-------------------------------  Set Hot-keys BEGIN  -------------------------------
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Ctrl+Spacebar -Function Complete
Set-PSReadLineKeyHandler -Chord Ctrl+UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord Alt+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Alt+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory

# Note: use a character literal: A == Shift + a
# 查看可使用的颜色
# [enum]::getvalues([consolecolor])
# 查看键盘键
# [enum]::getvalues([System.ConsoleKey]) 
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+c -Function RevertLine
Set-PSReadLineKeyHandler -Chord "Escape,Ctrl+w" -Function UnixWordRubout
Set-PSReadLineKeyHandler -Chord "Ctrl+x,Ctrl+w" -Function UnixWordRubout

Set-PSReadLineKeyHandler -Chord Ctrl+A -Function SelectAll
Set-PSReadLineKeyHandler -Chord Ctrl+v -Function Paste
Set-PSReadLineKeyHandler -Chord Ctrl+Z -Function Undo
Set-PSReadLineKeyHandler -Chord Ctrl+Y -Function Redo
Set-PSReadLineKeyHandler -Chord Ctrl+X -Function Cut
Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function NextWord
#-------------------------------  Set Hot-keys END    -------------------------------


# [Sourced file]
. $PSScriptRoot/completion-gh.ps1
. $PSScriptRoot/completion-rustup.ps1
. $PSScriptRoot/completion-procs.ps1
. $PSScriptRoot/completion-rg.ps1
. $PSScriptRoot/completion-starship.ps1

# https://www.tutorialspoint.com/explain-powershell-profile
# . $HOME/Documents/PowerShell/my-alias.ps1
. $PSScriptRoot/my-alias.ps1
. $PSScriptRoot/my-func.ps1
. $PSScriptRoot/my-tool.ps1
. $PSScriptRoot/my-wsl.ps1


# pshazz
# try { $null = gcm pshazz -ea stop; pshazz init 'default' } catch { }

# use conda-hook after pshazz to show conda's env in PS prompt
# & "$env:LOCALAPPDATA/Continuum/anaconda3/shell/condabin/conda-hook.ps1"


#------------------------------- Import Modules BEGIN -------------------------------
#------------------------------- Import Modules END   -------------------------------


# Set-PoshPrompt -Theme Paradox
function printTheme {
    Get-ChildItem -Path "$(scoop prefix oh-my-posh3)/themes/*" -Include '*.omp.json' | Sort-Object Name | ForEach-Object -Process {
        $esc = [char]27
        Write-Host ""
        Write-Host "$esc[1m$($_.BaseName)$esc[0m"
        Write-Host ""
        & "oh-my-posh.exe" -config $($_.FullName) -pwd $PWD
        Write-Host ""
    }
}

# volta: npm helper
(& volta completions powershell) | Out-String | Invoke-Expression

# z.lua
# Different from Search-NavigationHistory
iex ($(lua $env:scoop\apps\z.lua\current\z.lua --init powershell enhanced) -join "`n")
$env:_ZL_HYPHEN = 1
$env:_ZL_ECHO = 1
function zz { z -i $args }
function zf { z -I $args }
function zc { z -c $args }
function zb { z -b $args }
function zh { z -I -t . }

# zoxide
# Invoke-Expression (& {
#         $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#         (zoxide init --hook $hook powershell) -join "`n"
#     })

# scoop-completion
Import-Module "$env:scoop/modules/scoop-completion" -ErrorAction SilentlyContinue

# scoop-search
Invoke-Expression (&scoop-search --hook)

# starship
Invoke-Expression (&starship init powershell)

# oh-my-posh3
# Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/jandedobbeleer.omp.json")
# Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/agnoster.omp.json")
# Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/Paradox.omp.json")
# Invoke-Expression (oh-my-posh --init --shell pwsh --config "$(scoop prefix oh-my-posh3)/themes/marcduiker.omp.json")
