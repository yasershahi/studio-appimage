# Studio AppImage Builder

Unofficial AppImage packaging for [Studio by WordPress.com](https://github.com/Automattic/studio).

## Quick Install

You can download the latest AppImage from the [releases page](https://github.com/yasershahi/studio-appimage/releases) and just run it!.

Alternatively, you can use [Gear Lever](https://flathub.org/apps/com.rafaelmardojai.GearLever), a Flatpak application for managing AppImages.

If AppImages do not run on your system, you might be missing `fuse` (Filesystem in Userspace). Install it using your distribution's package manager:

```bash
# Debian/Ubuntu
sudo apt-get install libfuse2

# Fedora
sudo dnf install fuse

# Arch Linux
sudo pacman -S fuse2
```

## Building Locally

If you want to build the AppImage yourself:

```bash
# Clone this repository
git clone https://github.com/yasershahi/studio-appimage.git
cd studio-appimage

# Make build script executable
chmod +x build.sh

# Build specific version
./build.sh v1.5.2  # Replace with desired version
```

The AppImage will be created in `workspace/Studio-v1.5.2-x86_64.AppImage`.

## Features

- Standalone application - no installation required
- Includes all dependencies
- Auto-updates via GitHub releases
- XZ compressed for smaller file size

## Disclaimer

This is not an official package and is not affiliated with WordPress.com or Automattic Inc.
