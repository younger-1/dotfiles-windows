﻿$myalias = $PSCommandPath

# [Alias]
#-------------------------------   Set Alias Begin    -------------------------------
Set-Alias open Invoke-Item
Set-Alias lg lazygit
Set-Alias smap Set-PSReadLineKeyHandler
Set-Alias gmap Get-PSReadLineKeyHandler
Set-Alias ww which
Set-Alias ss scoop 
Set-Alias nvi nvim 
#-------------------------------    Set Alias END     -------------------------------

# [Directory]
# $env:LOCALAPPDATA
$localData = "$HOME\AppData\Local"
# $env:APPDATA
$roamData = "$HOME\AppData\Roaming"

# $env:XDG_CONFIG_HOME="$env:LOCALAPPDATA"
# $env:XDG_DATA_HOME="$env:APPDATA"
# $env:XDG_CACHE_HOME="$env:TEMP"

$scoop = $env:SCOOP
# Note: $scoop is using backslash: C:\Users\younger\scoop
$apps = "$scoop\apps"
$cache = "$scoop\cache"
$bucket = "$scoop\buckets"
$shims = "$scoop\shims"
$persist = "$scoop\persist"

$config = "$HOME/.config"
$icon = "$config/oh-my-icon"
$code = "$roamData/Code/User"
$wt = "$localData/Microsoft/Windows Terminal/"
$nvim = "$localData/nvim"

$notes = "$HOME/desktop/Notes"
$math = "C:\Users\didi\Desktop\数模\2020数学建模试题\2020年C题--面向康复工程的脑电信号分析和判别模型\附件1-P300脑机接口数据\S1"
$book = "~/Documents/0-Book and Materials/"


# [File]
$HOSTS = "$env:SystemRoot\system32\drivers\etc\hosts";
$AHK = "$config/AutoHotkeyU64.ahk"

# [env]
$env:QV2RAY_CONFIG_PATH = "$config/qv2ray"
