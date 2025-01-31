#Persistent
#NoEnv
SendMode Input
SetBatchLines -1
SetWinDelay, -1

global SVVPath := "C:\tools\SoundVolumeView.exe"
global Muted := False

; Hotkeys for Firefox volume control
PgUp::
    AdjustVolume("firefox.exe", 5)
    return

PgDn::
    AdjustVolume("firefox.exe", -5)
    return

End::
    ToggleMute("firefox.exe", Muted)
    Muted := !Muted
    return

; Hotkeys for focused application volume control
^PgUp:: 
    FocusedAppVolume(+5)
    return

^PgDn:: 
    FocusedAppVolume(-5)
    return

^End:: 
    FocusedAppToggleMute()
    return

FocusedAppVolume(Increment) {
    global SVVPath
    ; Get the process name of the focused window
    WinGet, FocusedApp, ProcessName, A
    ; Adjust the volume for the focused application
    if (FocusedApp) {
        AdjustVolume(FocusedApp, Increment)
    }
}

FocusedAppToggleMute() {
    static FocusedMuted := False
    ; Get the process name of the focused window
    WinGet, FocusedApp, ProcessName, A
    ; Toggle mute for the focused application
    if (FocusedApp) {
        ToggleMute(FocusedApp, FocusedMuted)
        FocusedMuted := !FocusedMuted
    }
}

AdjustVolume(AppName, Increment) {
    global SVVPath
    ; Adjust volume for the given application
    RunWait, %SVVPath% /ChangeVolume "%AppName%" %Increment%, , Hide
    DisplayVolume(AppName, Increment > 0 ? "increased" : "decreased")
}

ToggleMute(AppName, IsMuted) {
    global SVVPath
    ; Toggle mute for the given application
    if (IsMuted) {
        RunWait, %SVVPath% /UnMute "%AppName%", , Hide
        DisplayVolume(AppName, "unmuted")
    } else {
        RunWait, %SVVPath% /Mute "%AppName%", , Hide
        DisplayVolume(AppName, "muted")
    }
}

DisplayVolume(AppName, Action) {
    global SVVPath, VolumeText
    ; Get the current volume percentage for the application
    RunWait, %SVVPath% /GetPercent "%AppName%", , Hide
    VolumeLevel := ErrorLevel  ; ErrorLevel contains the volume percentage multiplied by 10
    Volume := Round(VolumeLevel / 10)  ; Adjust it to the actual volume percentage and round it

    ; Display the volume information in a GUI
    Gui, Destroy
    Gui, +AlwaysOnTop +ToolWindow -Caption
    Gui, Color, EEAA99 ; Pastel Pink
    Gui, Font, s20 cBlack, BurbankBigCondensed-bold ; Using the correct Burbank Big Condensed Bold font
    Gui, Add, Text, w300 h50 Center vVolumeText, %AppName%`nVolume %Action%: %Volume%
    Gui, Show, x10 y10 NoActivate
    SetTimer, DestroyGUI, -2000  ; Double the time (2000 ms)
    return
}

DestroyGUI:
    Gui, Destroy
    return
