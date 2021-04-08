# Reload profile
#. $profile
# Launch without profile
# powershell -noprofile -c "\"C:\foo\bar\" -replace '\\', '/'"

# [Encoding]
# Set encoding
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# $env:LESSCHARSET = 'utf-8'

# [Directory]
# $env:APPDATA
$roamData = "$HOME\AppData\Roaming"
# $env:LOCALAPPDATA
$localData = "$HOME\AppData\Local"

$notes = "$HOME/desktop/Notes"
$math = "C:\Users\didi\Desktop\数模\2020数学建模试题\2020年C题--面向康复工程的脑电信号分析和判别模型\附件1-P300脑机接口数据\S1"
$book = "C:\Users\didi\Desktop\source\rust\vrp\docs\src"

# [dotfiles]
# https://seankilleen.com/2020/04/how-to-create-a-powershell-alias-with-parameters/
# https://stackoverflow.com/questions/62861665/powershell-pass-all-parameters-received-in-function-and-handle-parameters-with
function dot {
   git --git-dir=$HOME/dotfiles.git --work-tree=$HOME $args
}

# [File]
$HOSTS = "$env:SystemRoot\system32\drivers\etc\hosts";

# [rust]
$env:RUSTUP_DIST_SERVER = "http://mirrors.rustcc.cn"
$env:RUSTUP_UPDATE_ROOT = "http://mirrors.rustcc.cn/rustup"

# [python]
$env:PYTHONIOENCODING = 'utf-8'
# $env:PYTHONSTARTUP="$(python -m jedi repl)"
# $env:PYTHONSTARTUP = "$HOME/.pythonrc.py"

# [java]
function j8 {
    $env:JAVA_TOOL_OPTIONS = '-Dfile.encoding=UTF-8'
    #	$env:JSHELLEDITOR='code'
}
#function jshell{
#	$env:JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF-8'
#	jshell
#	$env:JAVA_TOOL_OPTIONS=''
#}

# [source file]
# https://www.tutorialspoint.com/explain-powershell-profile
. $HOME/Documents/WindowsPowerShell/my_pwsh_profile.ps1

# [Mappings]
## 设置键盘映射
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+DownArrow -Function HistorySearchForward

$PSReadLineOptions = @{
    #EditMode = "Vi"
    #EditMode = "Emacs"
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

# pshazz
# try { $null = gcm pshazz -ea stop; pshazz init 'default' } catch { }

# use conda-hook after pshazz to show conda's env in PS prompt
# & "$env:LOCALAPPDATA/Continuum/anaconda3/shell/condabin/conda-hook.ps1"

# z.lua
# Different from Search-NavigationHistory
# iex ($(lua $env:scoop\apps\z.lua\current\z.lua --init powershell once enhanced) -join "`n")
# $env:_ZL_HYPHEN = 1
# $env:_ZL_ECHO = 1
# function zc($name) { z -c $name }
# function zb($name) { z -b $name }
# function zz($name1, $name2) { z -i $name1 $name2 }
# function zf($name1, $name2) { z -I $name1 $name2 }

# zoxide
Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell) -join "`n"
    })


# thefuck
# iex "$(thefuck --alias)"

# fzf
# $env:FZF_DEFAULT_COMMAND = 'procs.exe --color=always'
# $env:FZF_DEFAULT_COMMAND = 'rg --hidden --no-ignore --files'
$env:FZF_DEFAULT_COMMAND = 'fd --color=always --hidden --exclude .git'

# $env:FZF_DEFAULT_OPTS = '--layout=reverse --border'
$env:FZF_DEFAULT_OPTS = "--ansi --multi --cycle `
        --height 110 --layout=reverse --border=sharp `
        --bind='ctrl-a:toggle-all' `
        --bind='ctrl-l:clear-screen' `
        --bind='ctrl-d:half-page-down' `
        --bind='ctrl-u:half-page-up' `
        --bind='ctrl-f:page-down' `
        --bind='ctrl-b:page-up' "

# $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
# $env:FZF_CTRL_T_COMMAND = "cmd /c dir /s/b/a:-d-h"
$env:FZF_CTRL_T_OPTS = "--ansi --layout=reverse --border=sharp --prompt='>>> ' --marker='| ' -m  --header='Younger Searching' --color=16 --preview='bat --color=always --number {}' --preview-window=right:sharp --bind 'ctrl-y:execute-silent(bat {} | clip)+abort'"

function f {
    $files = fd --color=always --type f --hidden --no-ignore --exclude .git | `
        fzf --ansi --multi --cycle `
        --height=110 --layout=reverse --border=sharp `
        --prompt='>>> ' --marker='| ' --info='inline' `
        --header='Younger Searching' `
        --preview='bat --color=always --number {}' `
        --preview-window=right:sharp `
        --bind 'ctrl-y:execute-silent(bat {} | clip)+abort' `
        --bind='ctrl-a:toggle-all' `
        --bind='ctrl-p:toggle-preview' `
        --bind='ctrl-l:clear-screen' `
        --bind='ctrl-d:preview-half-page-down' `
        --bind='ctrl-u:preview-half-page-up' `
        --bind='ctrl-f:page-down' `
        --bind='ctrl-b:page-up' `
        # --color='fg:#af5fff,bg:#121212,hl:#f74204' `
        # --color='info:#cf5300,prompt:#ff0511,pointer:#afd7ff' `
    # --color='fg+:#85e63a,bg+:#262626,hl+:#ae11d1' `
    # --color='marker:#14f73e,spinner:#2c81d1,header:#00ffff' `
    # --color='preview-fg:#d426cb,border:#bb9167' `
    # --color='preview-bg:#0e001f' `

    $files
    # [Microsoft.PowerShell.PSConsoleReadLine]::Insert($files)
}
function d {
    fd --color=always --type d --hidden --no-ignore --exclude .git | `
        fzf --ansi --color=16 --multi --cycle `
        --height=110 --layout=reverse --border=sharp `
        --prompt='>>> ' --marker='| ' --info='inline' `
        --header='Younger Searching' `
        --preview='lsd -l --color=always --icon=always --blocks=permission,inode,size,date,name {}' `
        --preview-window=right:sharp `
        --bind 'ctrl-y:execute-silent(bat {} | clip)+abort' `
        --bind='ctrl-a:toggle-all' `
        --bind='ctrl-p:toggle-preview' `
        --bind='ctrl-l:clear-screen' `
        --bind='ctrl-d:preview-half-page-down' `
        --bind='ctrl-u:preview-half-page-up' `
        --bind='ctrl-f:page-down' `
        --bind='ctrl-b:page-up' `

}
function df {
    fd --color=always --hidden --no-ignore | `
        fzf --ansi --color=16 --multi --cycle `
        --height=110 --layout=reverse --border=sharp `
        --prompt='>>> ' --marker='| ' --info='inline' `
        --header='Younger Searching' `
        --preview='bat --color=always --number {} 2> nul || lsd -l --color=always --icon=always --blocks=permission,inode,size,date,name {} && lsd -A --color=always --icon=always --tree --depth=2 {}' `
        --preview-window=right:sharp:55% `
        --bind 'ctrl-y:execute-silent(bat {} | clip)+abort' `
        --bind='ctrl-a:toggle-all' `
        --bind='ctrl-p:toggle-preview' `
        --bind='ctrl-l:clear-screen' `
        --bind='ctrl-d:preview-half-page-down' `
        --bind='ctrl-u:preview-half-page-up' `
        --bind='ctrl-f:page-down' `
        --bind='ctrl-b:page-up' `

}

# PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }


<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>

# Import-Module "PowerTab" -ArgumentList "C:\Users\didi\AppData\Roaming\PowerTab\PowerTabConfig.xml"
################ End of PowerTab Initialization Code ##########################


<#
Install-Module -Name powershellget  -Force -Scope CurrentUser
Install-Module -Name psreadline  -Force -Scope CurrentUser
#>

# scoop-completion
Import-Module 'C:\Users\younger\scoop\modules\scoop-completion' -ErrorAction SilentlyContinue

# scoop-search
Invoke-Expression (&scoop-search --hook)

# starship
Invoke-Expression (&starship init powershell)

# function prompt {
#     $p = $($executionContext.SessionState.Path.CurrentLocation)
#     $converted_path = Convert-Path $p
#     $ansi_escape = [char]27
#     Write-Host $Env:CONDA_PROMPT_MODIFIER -NoNewline
#     Write-Host $env:USERNAME -ForegroundColor Green -NoNewline
#     Write-Host "@" -ForegroundColor White -NoNewLine
#     Write-Host $env:COMPUTERNAME -ForegroundColor Blue -NoNewLine
#     Write-Host " " -NoNewLine
#     Write-Host $p -NoNewLine
#     "PS $('>' * ($nestedPromptLevel + 1)) ";
#     Write-Host "$ansi_escape]7;file://$env:COMPUTERNAME/$converted_path$ansi_escape\" -NoNewline
#     Write-Host "$ansi_escape]9;9;$converted_path$ansi_escape\"
# }
