# Studio AppImage Builder

Unofficial AppImage packaging for [Studio by WordPress.com](https://github.com/Automattic/studio).

## 🚀 Quick Install

```bash
# Download latest release
wget https://github.com/yasershahi/studio-appimage/releases/latest/download/Studio-*-x86_64.AppImage

# Make it executable
chmod +x Studio-*-x86_64.AppImage

# Run it!
./Studio-*-x86_64.AppImage
```

## 📋 System Requirements

- Linux x86_64
- FUSE2 library

### Installing FUSE

Choose your distribution:

```bash
# Debian/Ubuntu
sudo apt-get install libfuse2

# Fedora
sudo dnf install fuse

# Arch Linux
sudo pacman -S fuse2
```

## 🛠️ Building Locally

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

## ⚡ Features

- Standalone application - no installation required
- Includes all dependencies
- Auto-updates via GitHub releases
- XZ compressed for smaller file size

## 📝 License

This packaging project is provided under GNU General Public License v3.0. Studio itself is licensed under [GNU GPL v2](https://github.com/Automattic/studio/blob/trunk/LICENSE).

## ⚠️ Disclaimer

This is not an official package and is not affiliated with WordPress.com or Automattic Inc.
