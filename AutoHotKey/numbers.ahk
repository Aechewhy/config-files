; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Prevent default behavior when [ is combined with other keys
[ & F1::Return

; Allow [ to send itself when tapped
*[::Send {Blind}{[}

; Enable remapping only when [ is physically held down
#If GetKeyState("[", "p")

x::Send {Numpad1}
c::Send {Numpad2}
v::Send {Numpad3}
s::Send {Numpad4}
d::Send {Numpad5}
f::Send {Numpad6}
w::Send {Numpad7}
e::Send {Numpad8}
r::Send {Numpad9}
a::Send {0}
z::Send {NumpadDot}

#If
