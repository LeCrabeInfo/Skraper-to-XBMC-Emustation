# XBMC-Emustation-Organizer

**XBMC-Emustation-Organizer** is a PowerShell script designed to adapt and organize files exported from [Skraper](https://www.skraper.net/) for compatibility with XBMC-Emustation on the OG Xbox. This script automates the process of moving media files, generating detailed synopsis files, and renaming game files to ensure seamless integration with XBMC-Emustation.

## Usage

### Option 1: Command Line

```powershell
.\XBMC-Emustation-Organizer.ps1 -EmustationPath "C:\path\to\your\emustation"
```

### Option 2: Drag-and-Drop

You can simply drag and drop your emustation directory onto the `XBMC-Emustation-Organizer.bat` file.
This batch script will automatically pass the path of the dropped directory to the PowerShell script, making it easy to start the process without needing to open PowerShell or type any commands.

## License

This project is licensed under the GNU General Public License v3.0. See the LICENSE file for more details.
