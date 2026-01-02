#f3:: {
    Send "{Media_Play_Pause}"
}

#^f4:: { 
    MsgBox(4, "", "Are you sure you want to shut down?")  ; Show confirmation dialog with Yes/No buttons
    if (MsgBox() == 6)  ; If user clicked "Yes" (6 is the Yes button's ID)
    {
        Shutdown(1)  ; Shutdown the computer
    }
}
#+f4:: {
    Shutdown(2)
}
#f1:: {
    Send("{Volume_Up}")
}
#+f1:: {
    Send("{Volume_Down}")
}
