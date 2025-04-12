; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
; Recommended for new scripts due to its superior speed and reliability.
SendMode Input
; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%

; Mentioned in the hotkeys docs for UP
Space & F1::Return

; Send it explicitly when no other key is pressed before letting go
; (including any modifiers being held)
*Space::Send {Blind}{Space}

; Autohotkey_L directive for enabling following mappings when key is physically down
#If GetKeyState("Space", "p")

j::Down
l::Right
h::Left
k::Up

#If