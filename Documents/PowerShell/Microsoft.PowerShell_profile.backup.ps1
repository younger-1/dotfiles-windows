# Set encoding
# $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)

## you must set encoding to UTF-16 LE because that's what Powershell expects for its profile file
## https://github.com/microsoft/terminal/issues/814#issuecomment-492907982
# function prompt {"PS $pwd 🍚 >" }

#chcp 437 #美国英语 
#chcp 936 #换回默认的GBK
#chcp 65001 #UTF-8

#Import-Module scoop-completion
#Import-Module DirColors
#Import-Module posh-git
#Import-Module oh-my-posh
#Update-DirColors ~\Documents\0-Windows\PowerShell.git\dircolors-solarized\dircolors.ansi-universal
Update-DirColors ~\Documents\0-Windows\PowerShell.git\dircolors-solarized\dircolors.ansi-dark


function Set-CurrentWorkingDirectory {
    param
    (
        $Path,
        $LiteralPath,
        $PassThru,
        $StackName,
        $UseTransaction
    )
    if ($Path -and ($Path.Contains('...'))) {
        $a = [System.Text.RegularExpressions.Regex]::Split($Path, "(\.{3,})");
        for ($i = 0; $i -lt $a.Length; $i++) {
            $e = $a[$i];
            $l = $e.Length;
            if (($l -gt 2) -and ($e -eq "".PadRight($l, '.'))) {
                $a[$i] = ".." + [System.String]::Concat([System.Linq.Enumerable]::Repeat("\..", $l - 2))
            }
        }
        $PSBoundParameters['Path'] = [System.String]::Concat($a)
    }
    return Set-Location @PSBoundParameters
}
#Set-Alias cd Set-CurrentWorkingDirectory -Option "AllScope"


#if (!(Get-SshAgent)) {
#    Start-SshAgent
#}

# Set-Theme Paradox
# set-theme robbyrussell
# Set-Theme Sorin
# Set-Theme PowerLine
# Set-Theme Fish
# Set-Theme spencer

#New-PSDrive -Name "web" -PSProvider "FileSystem" -Root "C:\Users\younger\Documents\0-test\web-projects" -Description "Maps to my My web-projects folder."
#New-PSDrive -Name "app" -PSProvider "FileSystem" -Root "C:\Users\younger\scoop\cache" -Description "Maps to my My app cache folder."


### PSReadLine 

## 查看所有设置
#Get-PSReadLineOption

## old 输入的命令，参数，操作符的颜色
# Set-PSReadlineOption -TokenKind Command -ForegroundColor Blue
# Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Yellow
# Set-PSReadlineOption -TokenKind Operator -ForegroundColor green

## new 输入的命令，参数，操作符的颜色

# Set-PSReadLineOption -Colors @{
#     # Use a ConsoleColor enum
#     "Error"   = [ConsoleColor]::DarkRed
#     # 24 bit color escape sequence
#     "String"  = "$([char]0x1b)[38;5;100m"
#     # RGB value
#     "Command" = "#8181f7"
# }


$PSReadLineOptions = @{
    #EditMode = "Vi"
    #EditMode = "Emacs"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    Colors                        = @{
        # RGB value
        "Command"   = [ConsoleColor]::Green
        "Parameter" = [ConsoleColor]::Magenta
        "Operator"  = [ConsoleColor]::Green
        # Use a ConsoleColor enum
        "Error"     = [ConsoleColor]::Red

        # 24 bit color escape sequence
        #"String" = "$([char]0x1b)[38;5;100m"
    }
}
Set-PSReadLineOption @PSReadLineOptions


## This command returns all key mappings
# Get-PSReadLineKeyHandler -Bound -Unbound

# Alt+Shift+?: 输入快捷键就会显示用法

# Ctrl+]: GotoBrace - Go to matching brace
# Ctrl+{w}: BackwardKillWord - Move the text from the start of the current or previous word to the cursor to the kill ring
# Ctrl+{h}/{Backspace}
# Ctrl+r: ReverseSearchHistory - Search history backwards interactively
# Ctrl+y: Redo - Redo an undo
# {Ctrl+i}/{@}/{Tab}: MenuComplete - Complete the input if there is a single completion, otherwise complete the input by selecting from a menu of possible completions.
# Ctrl+a: SelectAll - Select the entire line. Moves the cursor to the end of the line
# Ctrl+s: ForwardSearchHistory - Search history forward interactively
# Backspace: BackwardDeleteChar - Delete the character before the cursor
# Ctrl+{j}/{Enter}: InsertLineAbove - Inserts a new empty line above the current line without attempting to execute the input
# Ctrl+l: ClearScreen - Clear the screen and redraw the current line at the top of the screen
# Ctrl+z: Undo - Undo a previous edit
# Ctrl+x: Cut - Delete selected region placing deleted text in the system clipboard
# Ctrl+c: CopyOrCancelL	ine - Either copy selected text to the clipboard, or if no text is selected, cancel editing the line with CancelLine.
# Ctrl+v: Paste - Paste text from the system clipboard
# {Ctrl+m}/{Enter}: AcceptLine - Accept the input or move to the next line if input is missing a closing token.
# {Ctrl+[}/{Escape}: RevertLine - Equivalent to undo all edits (clears the line except lines imported from history)
# Ctrl+Home: BackwardDeleteLine - Delete text from the cursor to the start of the line
# Ctrl+End: ForwardDeleteLine - Delete text from the cursor to the end of the line
# Ctrl+Enter: InsertLineAbove - Inserts a new empty line above the current line without attempting to execute the input
# {Alt+d}/{Ctrl+Delete}: KillWord - Move the text from the cursor to the end of the current or next word to the kill ring
# Alt+.: YankLastArg - Copy the text of the last argument to the input
# Alt+-: DigitArgument - Start or accumulate a numeric argument to other functions