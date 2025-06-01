# Studio AppImage for Linux

This repository provides an AppImage package of [Studio by WordPress.com](https://github.com/Automattic/studio) for Linux users. Studio is a desktop application for creating local WordPress environments, powered by WordPress.com and WordPress Playground.

## Features

- Create local WordPress environments
- Powered by WordPress.com
- Built on WordPress Playground
- Works on most Linux distributions
- No installation required - just download and run
- Automatic updates through GitHub Releases
- URL scheme handler for `wpcom-local-dev://` links
- System integration with desktop menus and notifications
- Daily checks for new Studio releases
- Automated build and release process

## Project Structure

```
.
├── src/
│   ├── config/         # Configuration files
│   ├── scripts/        # Build and utility scripts
│   └── templates/      # Template files for AppImage
├── tests/             # Test files
├── files/            # Application files to be packaged
├── build.sh          # Main build script
└── README.md         # This file
```

## Building from Source

### Prerequisites

1. Install required dependencies:
   ```bash
   # Debian/Ubuntu
   sudo apt-get install wget fuse libfuse2

   # Fedora
   sudo dnf install wget fuse

   # Arch Linux
   sudo pacman -S wget fuse2
   ```

2. Install AppImage tools:
   ```bash
   wget -O appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
   chmod +x appimagetool
   sudo mv appimagetool /usr/local/bin/
   ```

### Build Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/studio-appimage.git
   cd studio-appimage
   ```

2. Place the Studio application files in the `files` directory:
   ```bash
   mkdir -p files
   # Copy your Studio application files here
   ```

3. Run the build script:
   ```bash
   ./build.sh
   ```

4. The resulting AppImage will be created as `Studio-x86_64.AppImage`

## Quick Start

1. Download the latest `Studio-x86_64.AppImage` from the [Releases](https://github.com/yourusername/studio-appimage/releases) page
2. Make it executable:
   ```bash
   chmod +x Studio-x86_64.AppImage
   ```
3. Run it:
   ```bash
   ./Studio-x86_64.AppImage
   ```

## System Requirements

### Required Dependencies
- FUSE (required to run AppImages)
  - For Debian/Ubuntu: `sudo apt-get install libfuse2`
  - For Fedora: `sudo dnf install fuse`
  - For Arch Linux: `sudo pacman -S fuse2`

### Additional Dependencies
The AppImage includes most dependencies, but some systems might need:
- GTK3
- GLib
- NSS
- X11 libraries
- ALSA

Install them with:
```bash
# Debian/Ubuntu
sudo apt-get install libgtk-3-0 libglib2.0-0 libnss3 libxss1 libxtst6 libasound2

# Fedora
sudo dnf install gtk3 glib2 nss libXScrnSaver libXtst alsa-lib

# Arch Linux
sudo pacman -S gtk3 glib2 nss libxss libxtst alsa-lib
```

## System Integration

### Using Gear Lever (Recommended)

For better integration with your system and easier AppImage management, we recommend using [Gear Lever](https://flathub.org/apps/it.mijorus.gearlever). Gear Lever helps you:
- Integrate AppImages into your system menus
- Manage multiple AppImage versions
- Update AppImages in-place
- Generate proper desktop entries and app metadata

To install Gear Lever:
1. Visit [Gear Lever on Flathub](https://flathub.org/apps/it.mijorus.gearlever)
2. Click "Install" to get it from Flathub
3. Use Gear Lever to manage your Studio AppImage

### Manual Integration

If you prefer to integrate manually:

1. Create a desktop entry:
   ```bash
   mkdir -p ~/.local/share/applications
   cat > ~/.local/share/applications/com.automattic.Studio.desktop << EOF
   [Desktop Entry]
   Name=WordPress Studio
   Exec=/path/to/Studio-x86_64.AppImage %u
   Icon=com.automattic.Studio
   Type=Application
   Categories=Development;
   StartupWMClass=studio
   Comment=WordPress Studio
   MimeType=x-scheme-handler/wpcom-local-dev;
   X-GNOME-UsesNotifications=true
   EOF
   ```

2. Update the desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications
   ```

## Development

### Project Structure

- `src/config/`: Contains configuration files and constants
- `src/scripts/`: Contains build and utility scripts
- `src/templates/`: Contains template files for AppImage components
- `tests/`: Contains test files
- `files/`: Contains the application files to be packaged

### Build Process

1. The build process starts from `build.sh`
2. Configuration is loaded from `src/config/config.sh`
3. Templates are processed from `src/templates/`
4. The AppImage is built using AppImageKit
5. Logs are written to `build.log`

### Adding New Features

1. Add new configuration variables to `src/config/config.sh`
2. Create new templates in `src/templates/` if needed
3. Add new build steps in `src/scripts/build.sh`
4. Update documentation in `README.md`

## Troubleshooting

### Common Issues

1. **AppImage won't run**
   - Make sure FUSE is installed
   - Check if the file is executable: `chmod +x Studio-x86_64.AppImage`
   - Try running from terminal to see errors: `./Studio-x86_64.AppImage --verbose`

2. **Missing dependencies**
   - Install required system libraries (see System Requirements)
   - Check system logs: `journalctl -f`

3. **URL scheme not working**
   - Make sure desktop integration is working
   - Check if the desktop file is properly installed
   - Try reinstalling the desktop file

4. **AppImage crashes on startup**
   - Run with debug output: `./Studio-x86_64.AppImage --verbose`
   - Check system logs: `journalctl -f`
   - Make sure all dependencies are installed

### Debug Information

To get more information about issues:

1. Run with verbose output:
   ```bash
   ./Studio-x86_64.AppImage --verbose
   ```

2. Check system logs:
   ```bash
   journalctl -f
   ```

3. Test AppImage integrity:
   ```bash
   ./Studio-x86_64.AppImage --appimage-extract
   ```

## License

This project is licensed under the GPL-2.0 license, the same as the original Studio project.

## Disclaimer

This is not an official package and is not affiliated with, authorized, maintained, sponsored, or endorsed by WordPress.com or Automattic Inc. This AppImage is provided "as is", without warranty of any kind, express or implied. Use at your own risk. 