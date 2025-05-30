#!/bin/bash
set -e

# Store the original directory
ORIGINAL_DIR=$(pwd)

sudo apt-get update
sudo apt-get install -y git nodejs npm python3 python3-pip libfuse2 wget desktop-file-utils patchelf

# Download appimagetool to the original directory
cd "$ORIGINAL_DIR"
wget -O appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool

git clone https://github.com/Automattic/studio.git
cd studio

# Install dependencies and build
npm install
npm run make

# Create AppDir structure
mkdir -p AppDir/usr/bin

# Copy the built application
cp -r out/Studio-linux-x64/* AppDir/usr/bin/

# Create desktop file
cat > AppDir/com.automattic.Studio.desktop << EOL
[Desktop Entry]
Name=Studio
Comment=WordPress.com Studio
Exec=studio
Icon=com.automattic.Studio
Terminal=false
Type=Application
Categories=Development;WebDevelopment;
StartupWMClass=Studio
MimeType=text/html;
EOL

cat > AppDir/AppRun << EOL
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin/:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib/:${LD_LIBRARY_PATH}"
exec "${HERE}/usr/bin/studio" "$@"
EOL

chmod +x AppDir/AppRun

# Go back to original directory to use appimagetool
cd "$ORIGINAL_DIR"
ARCH=x86_64 ./appimagetool studio/AppDir

# Cleanup
rm -rf studio
rm appimagetool
