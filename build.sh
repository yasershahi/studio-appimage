#!/bin/bash

# Exit on error
set -e

# Check for required files
if [ ! -d "files" ]; then
    echo "Error: 'files' directory not found"
    exit 1
fi

if [ ! -f "com.automattic.Studio.desktop" ]; then
    echo "Error: desktop file not found"
    exit 1
fi

if [ ! -f "com.automattic.Studio.png" ]; then
    echo "Error: icon file not found"
    exit 1
fi

# Debug: Show what we have
echo "Contents of files directory:"
ls -la files/

# Find the studio executable
STUDIO_EXEC=$(find files -type f -executable -name "studio*" | head -n 1)
if [ -z "$STUDIO_EXEC" ]; then
    echo "Error: Could not find studio executable in files directory"
    exit 1
fi

echo "Found studio executable at: $STUDIO_EXEC"
STUDIO_EXEC_NAME=$(basename "$STUDIO_EXEC")

# Clean up any existing AppDir
rm -rf AppDir

# Create AppDir structure
mkdir -p AppDir/usr/{bin,lib,share/{applications,icons/hicolor/256x256/apps,mime/packages}}

# Copy application files
echo "Copying application files..."
cp -r files/* AppDir/usr/bin/

# Make sure the executable is executable
chmod +x AppDir/usr/bin/$STUDIO_EXEC_NAME

# Create desktop file in AppDir root
echo "Creating desktop file..."
cat > AppDir/studio.desktop << EOF
[Desktop Entry]
Name=WordPress Studio
Exec=$STUDIO_EXEC_NAME %u
Icon=com.automattic.Studio
Type=Application
Categories=Development;
StartupWMClass=studio
Comment=WordPress Studio
MimeType=x-scheme-handler/wpcom-local-dev;
X-GNOME-UsesNotifications=true
EOF

# Create MIME type file
echo "Creating MIME type file..."
cat > AppDir/usr/share/mime/packages/wpcom-local-dev.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="x-scheme-handler/wpcom-local-dev">
    <comment>WordPress Studio Local Development</comment>
    <glob pattern="*.wpcom-local-dev"/>
  </mime-type>
</mime-info>
EOF

# Copy icon to both locations
echo "Copying icon..."
cp com.automattic.Studio.png AppDir/usr/share/icons/hicolor/256x256/apps/
cp com.automattic.Studio.png AppDir/com.automattic.Studio.png

# Create AppRun script
echo "Creating AppRun script..."
cat > AppDir/AppRun << EOF
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin/:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib/:${LD_LIBRARY_PATH}"
cd "${HERE}/usr/bin"

# Debug information
echo "Running from: $HERE"
echo "Looking for studio executable in: ${HERE}/usr/bin/"
ls -la "${HERE}/usr/bin/"

# Register URL scheme handler
if [ ! -f "$HOME/.local/share/applications/studio.desktop" ]; then
    mkdir -p "$HOME/.local/share/applications"
    cat > "$HOME/.local/share/applications/studio.desktop" << EOL
[Desktop Entry]
Name=WordPress Studio
Exec="$SELF" %u
Icon=com.automattic.Studio
Type=Application
Categories=Development;
StartupWMClass=studio
Comment=WordPress Studio
MimeType=x-scheme-handler/wpcom-local-dev;
X-GNOME-UsesNotifications=true
EOL
    update-desktop-database "$HOME/.local/share/applications"
fi

# Handle URL scheme
if [ "$1" != "" ]; then
    echo "Handling URL: $1"
    exec "${HERE}/usr/bin/$STUDIO_EXEC_NAME" "$1"
else
    exec "${HERE}/usr/bin/$STUDIO_EXEC_NAME"
fi
EOF

# Make AppRun executable
chmod +x AppDir/AppRun

# Download AppImage runtime if not present
if [ ! -f runtime ]; then
    echo "Downloading AppImage runtime..."
    wget -O runtime https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64
fi

# Debug: Show AppDir structure and file contents
echo "AppDir structure:"
ls -R AppDir
echo "Desktop file contents:"
cat AppDir/studio.desktop

# Create the AppImage
echo "Creating AppImage..."
ARCH=x86_64 appimagetool AppDir Studio-x86_64.AppImage

echo "Done! AppImage created: Studio-x86_64.AppImage"
