# https://stackoverflow.com/questions/817198/how-can-i-get-the-current-powershell-executing-file
$MY = $PSCommandPath

Set-Alias cd Set-LocationEX -Option "AllScope"
# cd .. cd ...
function .. { Set-LocationEX .. }
function ... { Set-LocationEX ..\.. }

Set-Alias open Invoke-Item
Set-Alias lg lazygit
Set-Alias cat bat -Option "AllScope"
Set-Alias ss scoop 

Set-Alias ls lsd -Option "AllScope"
function l($name) { lsd -l ($name) }
function la { lsd -A }
function ll { lsd -lA }
function lt { lsd --tree }

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

function condad { powershell.exe -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\younger\AppData\Local\Continuum\anaconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\younger\AppData\Local\Continuum\anaconda3' " }
function condacmd { cmd.exe /K %LocalAppData%/Continuum/Anaconda3/Scripts/activate.bat %LocalAppData%/Continuum/Anaconda3 }


function which($name) { Get-Command $name | Select-Object Definition }
function whichs($name) { Get-Command $name | Select-Object }

function suu { scoop update; scoop update * }


function arc($name) { wsl -d Arch $name }
function ubt($name) { wsl -d Ubuntu-18.04 $name }

# Change working dir in powershell to last dir in lf on exit.
function lf($name, $argument) {
    cd $name
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

function arcEmacs($name) {
    wsl -d Arch emacs $name 
}

function rar($name) { 
    cd $name;
    $temp = [System.IO.Path]::GetTempFileName()
    $temp = $temp.Replace("\", "/")
    $wsl_temp = wsl.exe -d Arch wslpath $temp
    wsl.exe -d Arch ranger --choosedir=$wsl_temp
    if (test-path -pathtype leaf "$temp") {
        $wsl_dir = Get-Content "$temp"
        $dir = wsl.exe -d Arch wslpath -m $wsl_dir
        remove-item -force "$temp"
        if (test-path -pathtype container "$dir") {
            if ("$dir" -ne "$pwd") {
                cd "$dir"
            }
        }
    } 
}

function ra($name) { 
    cd $name; 
    wsl.exe -d Arch ranger --choosedir=/home/young/.rangerdir
    $dir = wsl.exe -d Arch cat /home/young/.rangerdir
    $dir = wsl.exe -d Arch wslpath -m $dir
    cd $dir
}


# 神奇的是：$arg可以，$args不行
function killall($arg) {
    $commands = Get-Process -Name $arg
    foreach ($command in $commands) {
        Stop-Process $command.Id
    }
}

function ef($name) {
    if ($name) { explorer.exe $name }
    else { explorer.exe . }
}

function coded {
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

# Get alias of a cmdlet
function gcl ($cmdletname) {
    Get-Alias |
    Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
    Format-Table -Property Definition, Name -AutoSize
}

# test for `man about_Profiles`
function Color-Console {
    $host.ui.rawui.backgroundcolor = "white"
    $host.ui.rawui.foregroundcolor = "black"
    $hosttime = (dir $pshome\PowerShell.exe).creationtime
    $Host.UI.RawUI.WindowTitle = "Windows PowerShell $hostversion ($hosttime)"
    clear-host
}

# [elixir]
function ie { 
    iex.bat --werl
}
