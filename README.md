# Studio AppImage

This repository contains the build configuration for creating an AppImage of [Studio by WordPress.com](https://github.com/Automattic/studio).

## What is Studio?

Studio is a desktop application for creating local WordPress environments, powered by WordPress.com and WordPress Playground.

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

The built AppImage will be available as an artifact in the GitHub Actions run.

## Using the AppImage

1. Download the AppImage from the latest release or build it yourself
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