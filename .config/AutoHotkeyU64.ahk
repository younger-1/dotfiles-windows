;; How to use it
;; 1. Press `win + R`, and input `shell:startup`. 
;; 2. Put the ink shortcut of this file in the startup fold.
;; 3. Enjoy it.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

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

RemoveTooltip(){
    SetTimer, RemoveTooltip, Off
    Tooltip
    return
}

; Press both shift keys together to toggle Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

ToggleCaps(){
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

