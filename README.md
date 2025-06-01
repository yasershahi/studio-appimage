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

## Quick Start

1. Download the latest `Studio-x86_64.AppImage` from the [Releases](https://github.com/yasershahi/studio-appimage/releases) page
2. Make it executable:
   ```bash
   chmod +x Studio-x86_64.AppImage
   ```
3. Run it:
   ```bash
   ./Studio-x86_64.AppImage
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

## Requirements

- Linux operating system
- FUSE (required to run AppImages)
  - For Debian/Ubuntu: `sudo apt-get install libfuse2`
  - For Fedora: `sudo dnf install fuse`
  - For Arch Linux: `sudo pacman -S fuse2`

## Updates

This AppImage is automatically built whenever a new version of Studio is released. The build process:

1. Checks for new Studio releases daily
2. Builds a new AppImage when updates are available
3. Creates a GitHub Release with the new version
4. Maintains version compatibility with official Studio releases

You can:
- Watch this repository to get notified of new releases
- Use Gear Lever to manage updates automatically
- Check the [Releases](https://github.com/yasershahi/studio-appimage/releases) page manually

## Troubleshooting

If you encounter any issues:

1. Make sure you have FUSE installed
2. Check if your system meets the requirements
3. Try running the AppImage from the terminal to see error messages:
   ```bash
   ./Studio-x86_64.AppImage --verbose
   ```
4. Check the [Studio issues](https://github.com/Automattic/studio/issues) for known problems
5. Open an issue on this repository

## Development

This project uses:
- GitHub Actions for automated builds
- AppImageKit for packaging
- Environment variables for configuration
- Modular workflow design

The build process is fully automated and includes:
- Version checking
- Application building
- AppImage packaging
- Release creation
- System integration

## License

This project is licensed under the GPL-2.0 license, the same as the original Studio project.

## Disclaimer

This is not an official package and is not affiliated with, authorized, maintained, sponsored, or endorsed by WordPress.com or Automattic Inc. This AppImage is provided "as is", without warranty of any kind, express or implied. Use at your own risk. 