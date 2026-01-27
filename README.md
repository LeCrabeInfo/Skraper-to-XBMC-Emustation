# XBMC-Emustation-Organizer

**XBMC-Emustation-Organizer** is a set of scripts designed to adapt and organize files exported from [Skraper](https://www.skraper.net/) for compatibility with XBMC-Emustation on the OG Xbox. These scripts automates the process of moving media files, generating detailed synopsis files, and renaming game files to ensure seamless integration with XBMC-Emustation.

A full guide is available on [LeCrabeInfo](https://lecrabeinfo.net/tutoriels/transformer-sa-xbox-1re-gen-en-console-retrogaming-avec-xbmc-emustation/) (French website but nowadays browsers are able to translate on the fly).

## Usage - Windows

### Option 1: Command Line

```powershell
.\XBMC-Emustation-Organizer.ps1 -EmustationPath "C:\path\to\your\emustation"
```

### Option 2: Drag-and-Drop

You can simply drag and drop your emustation directory onto the `XBMC-Emustation-Organizer.bat` file.
This batch script will automatically pass the path of the dropped directory to the PowerShell script, making it easy to start the process without needing to open PowerShell or type any commands.

## Usage - Linux (and probably macOS)

**Requirement: xmllint**
- `xmllint` is included in the libxml2 package
- Check if it is already installed: `xmllint --version`
- If not installed, use your favorite package manager
  - Arch Linux / CachyOS: `sudo pacman -S libxml2`
  - Debian/Ubuntu: `sudo apt-get install libxml2-utils`
  - Fedora/RHEL: `sudo dnf install libxml2 or sudo yum install libxml2`
  - macOS (Homebrew): `brew install libxml2`

**Download and Run the Script**
1. Download the script `xbmc_emustation_organizer.sh`
2. Grant execution permission
```bash
chmod +x .\xbmc_emustation_organizer.sh
```
3. Run the script with the path to your EmuStation directory
```bash
.\xbmc_emustation_organizer.sh "/path/to/your/emustation"
```

## License

This project is licensed under the GNU General Public License v3.0. See the LICENSE file for more details.
