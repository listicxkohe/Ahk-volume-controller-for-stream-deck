# AHK Volume Control Script for Ajazz Stream Dock

This is an AHK script i made to control application volume using my Ajazz Stream Dock. I bound the hotkeys to the volume knobs so they directly adjust the volume of specific apps or the currently focused app. It runs pretty well and makes volume control way easier.

## Features

| Feature                      | Description |
|------------------------------|-------------|
| **App-Specific Volume Control** | Adjusts volume for specific apps like Firefox. |
| **Focused App Volume Control** | Controls volume of the currently active app. |
| **Mute/Unmute Support** | Toggle mute for apps individually. |
| **Customizable Hotkeys** | Uses hotkeys that can be changed as needed. |
| **Minimal GUI Feedback** | Shows a small overlay for volume changes. |

## Hotkeys

| Hotkey | Function |
|--------|----------|
| `PgUp` | Increase volume for Firefox. |
| `PgDn` | Decrease volume for Firefox. |
| `End` | Toggle mute for Firefox. |
| `Ctrl + PgUp` | Increase volume for focused app. |
| `Ctrl + PgDn` | Decrease volume for focused app. |
| `Ctrl + End` | Toggle mute for focused app. |

## How It Works

- Uses NirSoft's **SoundVolumeView** to get and change volume.
- Runs commands in the background to adjust app volume.
- Shows a small overlay when volume is changed or muted.
- The script automatically detects the focused app when using the `Ctrl` hotkeys.

## Installation & Setup

1. **Install AHK** – If you don’t have AutoHotkey installed, download it from [autohotkey.com](https://www.autohotkey.com/).
2. **Get SoundVolumeView** – Download it from [NirSoft](https://www.nirsoft.net/utils/sound_volume_view.html) and extract it to `C:\tools\SoundVolumeView.exe` (or update the script with your path).
3. **Run the Script** – Just double-click the `.ahk` file.
4. **Bind the Hotkeys** – In the Ajazz Stream Dock software, set the volume knobs to send the corresponding hotkeys.

## Notes
- Make sure the `SoundVolumeView.exe` path in the script matches where you saved it.
- If the GUI font doesn’t show properly, install **Burbank Big Condensed Bold**.
- The script destroys the volume overlay after 2 seconds automatically.
- You can modify hotkeys easily if needed.

---

That’s pretty much it. It runs in the background and does what i need. If you need changes, just edit the script and reload it.

