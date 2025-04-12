*CapsLock::
    KeyWait, CapsLock, T0.2
    if ErrorLevel  ; held
    {
        Send {Ctrl down}
        KeyWait, CapsLock
        Send {Ctrl up}
    }
    else  ; tapped
    {
        Send {Esc}
    }
return
