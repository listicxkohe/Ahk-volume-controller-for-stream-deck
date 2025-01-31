#Persistent  ; Keeps the script running indefinitely
#NoEnv       ; Avoids checking for unnecessary environment variables
SendMode Input
SetBatchLines -1  ; Maximizes script execution speed
SetWinDelay, -1   ; Reduces delay for window interactions

; Global Variables
; Path to NirSoft's SoundVolumeView utility
global SVVPath := "C:\tools\SoundVolumeView.exe"
; Keeps track of mute status for Firefox
global Muted := False

;----------------------------
; Hotkeys for Firefox Volume Control
;----------------------------
PgUp::
    AdjustVolume("firefox.exe", 5)  ; Increase Firefox volume by 5%
    return

PgDn::
    AdjustVolume("firefox.exe", -5)  ; Decrease Firefox volume by 5%
    return

End::
    ToggleMute("firefox.exe", Muted)  ; Toggle mute for Firefox
    Muted := !Muted  ; Invert mute status
    return

;----------------------------
; Hotkeys for Focused Application Volume Control
;----------------------------
^PgUp:: 
    FocusedAppVolume(+5)  ; Increase volume for the currently active app
    return

^PgDn:: 
    FocusedAppVolume(-5)  ; Decrease volume for the currently active app
    return

^End:: 
    FocusedAppToggleMute()  ; Toggle mute for the currently active app
    return

;----------------------------
; Functions for Focused Application Volume Control
;----------------------------
FocusedAppVolume(Increment) {
    global SVVPath
    WinGet, FocusedApp, ProcessName, A  ; Get the process name of the active window
    if (FocusedApp) {
        AdjustVolume(FocusedApp, Increment)  ; Adjust volume for the focused application
    }
}

FocusedAppToggleMute() {
    static FocusedMuted := False
    WinGet, FocusedApp, ProcessName, A  ; Get the process name of the active window
    if (FocusedApp) {
        ToggleMute(FocusedApp, FocusedMuted)  ; Toggle mute state
        FocusedMuted := !FocusedMuted  ; Invert mute status
    }
}

;----------------------------
; Core Volume Control Functions
;----------------------------
AdjustVolume(AppName, Increment) {
    global SVVPath
    RunWait, %SVVPath% /ChangeVolume "%AppName%" %Increment%, , Hide  ; Adjust volume using SoundVolumeView
    DisplayVolume(AppName, Increment > 0 ? "increased" : "decreased")
}

ToggleMute(AppName, IsMuted) {
    global SVVPath
    if (IsMuted) {
        RunWait, %SVVPath% /UnMute "%AppName%", , Hide  ; Unmute application
        DisplayVolume(AppName, "unmuted")
    } else {
        RunWait, %SVVPath% /Mute "%AppName%", , Hide  ; Mute application
        DisplayVolume(AppName, "muted")
    }
}

;----------------------------
; GUI Feedback Function
;----------------------------
DisplayVolume(AppName, Action) {
    global SVVPath, VolumeText
    RunWait, %SVVPath% /GetPercent "%AppName%", , Hide  ; Get current volume level
    VolumeLevel := ErrorLevel  ; ErrorLevel stores volume percentage * 10
    Volume := Round(VolumeLevel / 10)  ; Convert to actual percentage

    ; Display GUI notification for volume change
    Gui, Destroy
    Gui, +AlwaysOnTop +ToolWindow -Caption
    Gui, Color, EEAA99  ; Pastel Pink background
    Gui, Font, s20 cBlack, BurbankBigCondensed-bold  ; Custom font for better readability
    Gui, Add, Text, w300 h50 Center vVolumeText, %AppName%`nVolume %Action%: %Volume%
    Gui, Show, x10 y10 NoActivate  ; Position GUI at top-left corner without activating window
    SetTimer, DestroyGUI, -2000  ; Auto-close GUI after 2 seconds
    return
}

DestroyGUI:
    Gui, Destroy  ; Close volume display GUI
    return
