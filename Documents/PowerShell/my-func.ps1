
# https://stackoverflow.com/questions/817198/how-can-i-get-the-current-powershell-executing-file
$myfunc = $PSCommandPath

#-------------------------------    Functions BEGIN   -------------------------------
#-------------------------------    Functions END     -------------------------------

<# Usage:
    1. which vim
    2. which vim d
    3. which *.cmd
#>
function which($name) { 
    if ($args[0] -eq 'd') {
        # Get-Command $name | Select-Object Definition
        (Get-Command $name).Definition | bat --language=ps1
    }
    else {
        Get-Command $name
    }
}
function what($name) {
    bat (Get-Command $name).Definition
}

function wan ($name) { 
    if ($args[0] -eq 'o') {
        Get-Help -Online $name 
    }
    elseif ($args[0] -eq 'w') {
        Get-Help -ShowWindow $name 
    }
    elseif ($args[0] -eq 'f') {
        Get-Help -Full $name | bat --language=ps1
    }
    elseif ($args[0] -eq 'e') {
        Get-Help -Examples $name | bat --language=ps1
    }
    else {
        Get-Help -Detailed $name | bat --language=ps1  
    }
}


function .. { cd .. }
function ... { cd ..\.. }
function cd- { cd - }
function cd+ { cd + }
function cdd($name) {
    # https://stackoverflow.com/questions/9725521/how-to-get-the-parents-parent-directory-in-powershell
    # cd (Get-Item $args[0]).Directory.parent.FullName
    cd (Split-Path -Path $name -Parent)
}

function killall {
    $commands = Get-Process -Name $args[0]
    foreach ($command in $commands) {
        Stop-Process $command.Id
    }
}

<# Usage:
    1. ef
    2. ef $SCOOP
    3. ef $HOSTS
#>
function ef($name) {
    if ($null -eq $name) { 
        explorer.exe . 
        return
    }
    $name = $name -replace '/', '\'
    if (Test-Path -Path $name -PathType Container) { 
        explorer.exe $name
    }
    elseif (Test-Path -Path $name -PathType Leaf) {
        explorer.exe (Split-Path -Path $name -Parent)
    }
}

# Get alias of a cmdlet
function gcl ($cmdletname) {
    Get-Alias |
    Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
    Format-Table -Property Definition, Name -AutoSize
}

# test for `man about_Profiles`
function colorConsole {
    $host.ui.rawui.backgroundcolor = "white"
    $host.ui.rawui.foregroundcolor = "black"
    $hosttime = (Get-ChildItem $pshome\PowerShell.exe).creationtime
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell $hostversion ($hosttime)"
    clear-host
}

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

# thefuck
# iex "$(thefuck --alias)"

function visualCode {
    $installPath = &"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -version 16.0 -property installationpath
    Import-Module (Join-Path $installPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    $null = Enter-VsDevShell -VsInstallPath $installPath -SkipAutomaticLocation
    #Enter-VsDevShell -VsInstallPath $installPath -SkipAutomaticLocation
    code -n .
}

function visual {
    $installPath = &"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -version 16.0 -property installationpath
    Import-Module (Join-Path $installPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstallPath $installPath -SkipAutomaticLocation
}


# SpaceVim
function svi($path) { 
    # Don't use following:
    # $env:XDG_CONFIG_HOME = "$HOME/.cache"
    # $env:XDG_CONFIG_HOME = "$HOME/.SpaceVim.d"
    # Put nvim symlink under it:
    $env:XDG_CONFIG_HOME = "$HOME/blogs"
    nvim $path
    $env:XDG_CONFIG_HOME = ""
}

function condaIt { powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\younger\AppData\Local\Continuum\anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\younger\AppData\Local\Continuum\anaconda3' " }
function condaCmd { cmd.exe /K %LocalAppData%/Continuum/Anaconda3/Scripts/activate.bat %LocalAppData%/Continuum/Anaconda3 }

function cai {
    conda activate
    ipython.exe
    conda deactivate
}

function jsh {
    $env:java_tool_options = '-Dfile.encoding=utf-8'
    $env:JSHELLEDITOR = 'code'
    jshell.exe $args
    $env:java_tool_options = ''
    $env:JSHELLEDITOR = ''
}

function Update-Packages {
    # update pip
    Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
    $a = pip list --outdated
    $num_package = $a.Length - 2
    for ($i = 0; $i -lt $num_package; $i++) {
        $tmp = ($a[2 + $i].Split(" "))[0]
        pip install -U $tmp
    }

    # update TeX Live
    $CurrentYear = Get-Date -Format yyyy
    Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
    tlmgr update --self
    tlmgr update --all
}

# Note: git is fun and git.exe/ps1 is the exectable
# This can omit: $git_init = $false
function git {
    if ($global:git_init) {
        git.exe $args
    }
    else {
        Import-Module posh-git
        $global:git_init = $true
        git.exe $args
    }
}


# [proxy]
$HostIP = "127.0.0.1"
$HttpPort = 10809
$SocksPort = 10808

function showproxy {
    Write-Host ""
    Write-Host "Show Proxy:"
    Write-Host "http_proxy=$env:http_proxy"
    Write-Host "https_proxy=$env:https_proxy"
    Write-Host "ALL_proxy=$env:ALL_proxy"
    Write-Host ""
    echo "curl --connect-timeout 2 baidu.com"
    curl --connect-timeout 2 baidu.com
    Write-Host ""
    echo "curl --connect-timeout 2 google.com"
    curl --connect-timeout 2 google.com
}

function setproxy  {
    $env:http_proxy="http://${HostIP}:$HttpPort"
    $env:https_proxy="http://${HostIP}:$HttpPort"
    $env:ALL_proxy="socks5://${HostIP}:$SocksPort"
}

function unsetproxy {
    $env:http_proxy=""
    $env:https_proxy=""
    $env:ALL_proxy=""
}

setproxy

