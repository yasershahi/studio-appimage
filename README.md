# Studio AppImage for Linux

This repository provides an AppImage package of [Studio by WordPress.com](https://github.com/Automattic/studio) for Linux users. Studio is a desktop application for creating local WordPress environments, powered by WordPress.com and WordPress Playground.

## Download

You can download the latest Studio AppImage from the [Releases](https://github.com/yasershahi/studio-appimage/releases) page.

## Installation

1. Download the latest `Studio-x86_64.AppImage` from the [Releases](https://github.com/yasershahi/studio-appimage/releases) page
2. Make it executable:
   ```bash
   chmod +x Studio-x86_64.AppImage
   ```
3. Run it:
   ```bash
   ./Studio-x86_64.AppImage
   ```

## Requirements

- Linux operating system
- FUSE (required to run AppImages)
  - For Debian/Ubuntu: `sudo apt-get install libfuse2`
  - For Fedora: `sudo dnf install fuse`
  - For Arch Linux: `sudo pacman -S fuse2`

## Features

- Create local WordPress environments
- Powered by WordPress.com
- Built on WordPress Playground
- Works on most Linux distributions
- No installation required - just download and run

## Updates

The AppImage is automatically built every week to ensure you have the latest version of Studio. You can download the latest version from the [Releases](https://github.com/yasershahi/studio-appimage/releases) page.

## Support

If you encounter any issues:
1. Make sure you have FUSE installed
2. Check if your system meets the requirements
3. Open an issue on this repository

## License

This project is licensed under the GPL-2.0 license, the same as the original Studio project. 