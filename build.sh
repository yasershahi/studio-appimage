#!/bin/bash

# Exit on error
set -e

# Install dependencies
sudo apt-get update
sudo apt-get install -y \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    libfuse2 \
    wget \
    desktop-file-utils \
    patchelf

# Install appimagetool
wget -O appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool

# Clone the repository
git clone https://github.com/Automattic/studio.git
cd studio

# Install dependencies and build
npm install
npm run build

# Create AppDir structure
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy the built application
cp -r dist/* AppDir/usr/bin/

# Create desktop file
cat > AppDir/usr/share/applications/studio.desktop << EOL
[Desktop Entry]
Name=Studio
Comment=WordPress.com Studio
Exec=studio
Icon=studio
Terminal=false
Type=Application
Categories=Development;
EOL

# Copy icon (you'll need to add the actual icon file)
# cp assets/icon.png AppDir/usr/share/icons/hicolor/256x256/apps/studio.png

# Create AppRun
cat > AppDir/AppRun << EOL
#!/bin/bash
SELF=\$(readlink -f "\$0")
HERE=\${SELF%/*}
export PATH="\${HERE}/usr/bin/:\${PATH}"
export LD_LIBRARY_PATH="\${HERE}/usr/lib/:\${LD_LIBRARY_PATH}"
exec "\${HERE}/usr/bin/studio" "\$@"
EOL

chmod +x AppDir/AppRun

# Create AppImage
ARCH=x86_64 ./appimagetool AppDir

# Cleanup
cd ..
rm -rf studio
rm appimagetool 