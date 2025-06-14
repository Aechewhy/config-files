#Requires AutoHotkey v2.0

; List of URLs
urls := [
    "https://www.google.com",
    "https://www.github.com",
    "https://www.stackoverflow.com",
    "https://www.reddit.com",
    "https://www.youtube.com"
]

; Create GUI with a ListBox to display the URLs
Gui, Add, ListBox, vURLList w400 h200, % JoinURLs(urls)
Gui, Add, Button, gOpenURL, Open URL
Gui, Show, w420 h240, Select a URL

; Start with the first item selected
currentIndex := 1
GuiControl, Choose, URLList, currentIndex

; Hotkeys for navigating the list
^Up:: {  ; Ctrl + Up to go up in the list
    if (currentIndex > 1) {
        currentIndex--
        GuiControl, Choose, URLList, currentIndex
    }
}

^Down:: {  ; Ctrl + Down to go down in the list
    if (currentIndex < urls.MaxIndex()) {
        currentIndex++
        GuiControl, Choose, URLList, currentIndex
    }
}

; Function to open the selected URL
OpenURL:
    selectedURL := urls[currentIndex]
    Run, % selectedURL
    GuiClose:
        ExitApp

; Helper function to join the list of URLs into a format suitable for ListBox
JoinURLs(list) {
    result := ""
    for index, url in list {
        result .= url "`n"
    }
    return result
}
