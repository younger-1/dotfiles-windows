$mytool = $PSCommandPath

function suu { scoop update; scoop update * }

# Set-Alias ls lsd -Option "AllScope"
function l { lsd -l $args }
function la { lsd -A $args }
function ll { lsd -lA $args }
function lt { lsd --tree $args }

# Set-Alias cat bat -Option "AllScope"
function b { bat $args }
function ba { bat -A $args }
function bd { bat -d $args }

# Change working dir in powershell to last dir in lf on exit.
function lf($name, $argument) {
    if ($name) {
        cd $name; 
    }
    $tmp = [System.IO.Path]::GetTempFileName()
    lf.ps1 -last-dir-path="$tmp" $argument
    if (test-path -pathtype leaf "$tmp") {
        $dir = Get-Content "$tmp"
        remove-item -force "$tmp"
        if (test-path -pathtype container "$dir") {
            if ("$dir" -ne "$pwd") {
                cd "$dir"
            }
        }
    }
}

# [dotfiles]
# https://seankilleen.com/2020/04/how-to-create-a-powershell-alias-with-parameters/
# https://stackoverflow.com/questions/62861665/powershell-pass-all-parameters-received-in-function-and-handle-parameters-with
function dot {
    # git --git-dir=$HOME/dotfiles.git --work-tree=$HOME $args
    git --git-dir=$HOME/dotfiles.git --work-tree=$HOME @args
}


# z.lua
# Different from Search-NavigationHistory
# iex ($(lua $env:scoop\apps\z.lua\current\z.lua --init powershell once enhanced) -join "`n")
# $env:_ZL_HYPHEN = 1
# $env:_ZL_ECHO = 1
# function zc($name) { z -c $name }
# function zb($name) { z -b $name }
# function zz($name1, $name2) { z -i $name1 $name2 }
# function zf($name1, $name2) { z -I $name1 $name2 }


# PSFzf
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' 
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }


<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>

# Import-Module "PowerTab" -ArgumentList "C:\Users\didi\AppData\Roaming\PowerTab\PowerTabConfig.xml"
################ End of PowerTab Initialization Code ##########################


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

<# Usage:   
    1. vim (f)
    2. bat (f)
    3. (f) | bat 
    4. f (ss prefix trojan-go)
    5. vim (f (ss prefix trojan-go))
#>
function f {
    # fd [FLAGS/OPTIONS] [<pattern>] [<path>...]
    $files = fd --color=always --type f --hidden --no-ignore --exclude .git . $args | `
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
    fd --color=always --type d --hidden --no-ignore --exclude .git . $args | `
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
    fd --color=always --hidden --no-ignore --exclude .git . $args| `
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
