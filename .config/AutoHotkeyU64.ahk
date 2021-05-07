;; How to use it
;; 1. Press `win + R`, and input `shell:startup`. 
;; 2. Put the ink shortcut of this file in the startup fold.
;; 3. Enjoy it.

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;; Global Variables
EnvGet, lad, LocalAppData
layout_id := 1
wt_layout_width := [0.6, 0.75, 0.95, 0.75]
wt_layout_height := [0.5, 0.4, 0.3, 0.65]

;; Show the clipped text
#`::
MsgBox, 262144, Clip-board, %clipboard%
return

; Right button: right-ctrl + space
>^Space::
    Send {RButton}
return
; Middle button: right-alt + space
>!Space::
    Send {MButton}
return

; Map Capslock to Control
; Map press & release of Capslock with no other key to Esc
*Capslock::
    Send {Blind}{LControl down}
return

*Capslock up::
    Send {Blind}{LControl up}
    ; Tooltip, %A_PRIORKEY%
    ; SetTimer, RemoveTooltip, 1000
    if A_PRIORKEY = CapsLock
    {
        Send {Esc}
    }
return

RemoveTooltip() {
    SetTimer, RemoveTooltip, Off
    Tooltip
return
}

; Press both shift keys together to toggle Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

ToggleCaps() {
    ; this is needed because by default, AHK turns CapsLock off before doing Send
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
return
}

; Map <CR> to <Ctrl>
; And side-effect: shift+enter is like press enter continually
; https://usman.io/emacs-ergonomics-using-caps-and-enter-as-ctrls/
KeyPress=0

^enter::^enter
enter::
    KeyWait enter, D
    KeyPress++
    SendInput {ctrl down}
    KeyWait, enter, t1000
    if errorlevel = 1
    {
        SendInput {ctrl up}
        KeyPress=0
        Timeout=1
        return
    }
    if Timeout != 1
    {
        SendInput {ctrl up}
        if (a_priorkey = "enter") && (KeyPress >= 1)
            send,{enter}
    }
    Timeout=
    SendInput {ctrl up}
    KeyPress=0
return

;; Windows Terminal appear/disappear
;; https://gist.github.com/andrewgodwin/89920ee02501ab12d09b02500897066c
#enter::ToggleTerminal()
ShowAndPositionTerminal(flag := 0)
{
    WinShow ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    WinActivate ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    SysGet, WorkArea, MonitorWorkArea
    global layout_id ,wt_layout_width ,wt_layout_height
    if (flag == 1) {
        layout_id := Mod(layout_id, wt_layout_height.Length())
        layout_id += 1
    }
    TerminalWidth := A_ScreenWidth * wt_layout_width[layout_id]
    TerminalHeight := A_ScreenHeight * wt_layout_height[layout_id]
    ; TerminalWidth := A_ScreenWidth * 0.6
    ; TerminalHeight := A_ScreenHeight * 0.5
    WinMove, ahk_class CASCADIA_HOSTING_WINDOW_CLASS,, (A_ScreenWidth - TerminalWidth) / 2, WorkAreaTop - 2, TerminalWidth, TerminalHeight
}

ToggleTerminal()
{
    WinMatcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    DetectHiddenWindows, On

    if WinExist(WinMatcher)
        ; Window Exists
    {
        DetectHiddenWindows, Off

        ; Check if its hidden
        if !WinExist(WinMatcher) || !WinActive(WinMatcher)
        {
            ShowAndPositionTerminal()
        }
        else if WinExist(WinMatcher)
        {
            ; Script sees it without detecting hidden windows, so..
            WinHide ahk_class CASCADIA_HOSTING_WINDOW_CLASS
            Send !{Esc}
        }
    }
    else
    {
        ; Run, "%LocalAppData%\Microsoft\WindowsApps\wt.exe"
        global lad
        Run, % lad . "\Microsoft\WindowsApps\wt.exe"
        Sleep, 1000
        ShowAndPositionTerminal()
    }
}

; Resize the WindowsTerminal
#+enter::ShowAndPositionTerminal(1)

; Launch/Restore the Windows Terminal.
#\::SwitchToWindowsTerminal()
SwitchToWindowsTerminal()
{
    windowHandleId := WinExist("ahk_exe WindowsTerminal.exe")
    windowExistsAlready := windowHandleId > 0

    ; If the Windows Terminal is already open, determine if we should put it in focus or minimize it.
    if (windowExistsAlready = true)
    {
        activeWindowHandleId := WinExist("A")
        windowIsAlreadyActive := activeWindowHandleId == windowHandleId

        if (windowIsAlreadyActive)
        {
            ; Minimize the window.
            WinMinimize, "ahk_id %windowHandleId%"
        }
        else
        {
            ; Put the window in focus.
            WinActivate, "ahk_id %windowHandleId%"
            WinShow, "ahk_id %windowHandleId%"
        }
    }
    ; Else it's not already open, so launch it.
    else
    {
        global lad
        Run, % lad . "\Microsoft\WindowsApps\wt.exe"
        ; The *RunAs will launch the Windows Terminal as Admin.
        ; Run, *RunAs wt
    }
}
