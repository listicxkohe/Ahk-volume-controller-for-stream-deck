#Persistent  ; Keeps the script running indefinitely
#NoEnv       ; Avoids checking for unnecessary environment variables
SendMode Input
SetBatchLines -1  ; Maximizes script execution speed
SetWinDelay, -1   ; Reduces delay for window interactions

; Improve hotkey responsiveness
#HotkeyInterval 50  ; Reduce delay between hotkey presses
#MaxHotkeysPerInterval 200  ; Allow more rapid hotkey activations

; Global Variables
global SVVPath := "C:\tools\SoundVolumeView.exe"
global Muted := False
global VolumeGuiOpen := False

;----------------------------
; Hotkeys for Firefox Volume Control
;----------------------------
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

;----------------------------
; Hotkeys for Focused Application Volume Control
;----------------------------
^PgUp:: 
    FocusedAppVolume(+5)
    return

^PgDn:: 
    FocusedAppVolume(-5)
    return

^End:: 
    FocusedAppToggleMute()
    return

;----------------------------
; Functions for Focused Application Volume Control
;----------------------------
FocusedAppVolume(Increment) {
    global SVVPath
    WinGet, FocusedApp, ProcessName, A
    if (FocusedApp) {
        AdjustVolume(FocusedApp, Increment)
    }
}

FocusedAppToggleMute() {
    static FocusedMuted := False
    WinGet, FocusedApp, ProcessName, A
    if (FocusedApp) {
        ToggleMute(FocusedApp, FocusedMuted)
        FocusedMuted := !FocusedMuted
    }
}

;----------------------------
; Core Volume Control Functions
;----------------------------
AdjustVolume(AppName, Increment) {
    global SVVPath
    Run, %SVVPath% /ChangeVolume "%AppName%" %Increment%, , Hide  ; Run asynchronously for faster response
    DisplayVolume(AppName, Increment > 0 ? "increased" : "decreased")
}

ToggleMute(AppName, IsMuted) {
    global SVVPath
    if (IsMuted) {
        Run, %SVVPath% /UnMute "%AppName%", , Hide
        DisplayVolume(AppName, "unmuted")
    } else {
        Run, %SVVPath% /Mute "%AppName%", , Hide
        DisplayVolume(AppName, "muted")
    }
}

;----------------------------
; GUI Feedback Function
;----------------------------
DisplayVolume(AppName, Action) {
    global SVVPath, VolumeText, VolumeGuiOpen
    RunWait, %SVVPath% /GetPercent "%AppName%", , Hide
    VolumeLevel := ErrorLevel
    Volume := Round(VolumeLevel / 10)

    ; Update existing GUI if it's already open
    if (VolumeGuiOpen) {
        GuiControl,, VolumeText, %AppName%`nVolume %Action%: %Volume%
        SetTimer, DestroyGUI, -2000  ; Reset close timer
        return
    }

    VolumeGuiOpen := True
    Gui, Destroy
    Gui, +AlwaysOnTop +ToolWindow -Caption
    Gui, Color, EEAA99
    Gui, Font, s20 cBlack, BurbankBigCondensed-bold
    Gui, Add, Text, w300 h50 Center vVolumeText, %AppName%`nVolume %Action%: %Volume%
    Gui, Show, x10 y10 NoActivate
    SetTimer, DestroyGUI, -2000
    return
}

DestroyGUI:
    VolumeGuiOpen := False
    Gui, Destroy
    return