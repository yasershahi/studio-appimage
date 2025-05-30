# Studio AppImage

This repository contains the build configuration for creating an AppImage of [Studio by WordPress.com](https://github.com/Automattic/studio).

## What is Studio?

Studio is a desktop application for creating local WordPress environments, powered by WordPress.com and WordPress Playground.

## Important Note

Since Studio does not provide an official Linux package, this AppImage provides a convenient way to run Studio on most Linux distributions. However, please note that you will need to have FUSE installed on your system to run the AppImage. You can install it using your distribution's package manager:

- For Debian/Ubuntu: `sudo apt-get install libfuse2`
- For Fedora: `sudo dnf install fuse`
- For Arch Linux: `sudo pacman -S fuse2`

## Building the AppImage

### Prerequisites

- Linux system with the following packages installed:
  - git
  - nodejs
  - npm
  - python3
  - python3-pip
  - libfuse2
  - wget
  - desktop-file-utils
  - patchelf

### Building Locally

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/studio-appimage.git
   cd studio-appimage
   ```

2. Make the build script executable:
   ```bash
   chmod +x build.sh
   ```

3. Run the build script:
   ```bash
   ./build.sh
   ```

The resulting AppImage will be created in the current directory.

### Automated Builds

This repository includes GitHub Actions workflows that automatically build the AppImage on:
- Every push to the main branch
- Every pull request to the main branch
- Manual trigger through the GitHub Actions interface

The built AppImage will be available as an artifact in the GitHub Actions run. You can download it from the [Actions](https://github.com/yasershahi/studio-appimage/actions) page:
1. Click on the latest successful workflow run
2. Scroll down to the "Artifacts" section
3. Download the AppImage file

## Using the AppImage

1. Download the AppImage from the [Actions](https://github.com/yasershahi/studio-appimage/actions) page or build it yourself
2. Make it executable:
   ```bash
   chmod +x Studio-*.AppImage
   ```
3. Run it:
   ```bash
   ./Studio-*.AppImage
   ```

## License

This project is licensed under the GPL-2.0 license, the same as the original Studio project. 