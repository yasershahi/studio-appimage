#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Constants
APPDIR="AppDir"
ICON_NAME="com.automattic.Studio"
APP_NAME="WordPress Studio"
RUNTIME_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64"

# Function to print error messages
error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to print status messages
status() {
    echo "==> $1"
}

# Function to check required files
check_requirements() {
    status "Checking required files..."
    [ -d "files" ] || error "'files' directory not found"
    [ -f "${ICON_NAME}.desktop" ] || error "desktop file not found"
    [ -f "${ICON_NAME}.png" ] || error "icon file not found"
}

# Function to find and validate studio executable
find_studio_executable() {
    STUDIO_EXEC=$(find files -type f -executable -name "studio*" | head -n 1)
    [ -n "$STUDIO_EXEC" ] || error "Could not find studio executable in files directory"
    status "Found studio executable at: $STUDIO_EXEC"
    echo $(basename "$STUDIO_EXEC")
}

# Function to create AppDir structure
create_appdir_structure() {
    status "Cleaning up existing AppDir..."
    rm -rf "$APPDIR"
    
    status "Creating AppDir structure..."
    mkdir -p "$APPDIR/usr/"{bin,lib,share/{applications,icons/hicolor/256x256/apps,mime/packages}}
}

# Function to copy application files
copy_app_files() {
    local exec_name="$1"
    status "Copying application files..."
    cp -r files/* "$APPDIR/usr/bin/"
    chmod +x "$APPDIR/usr/bin/$exec_name"
}

# Function to create desktop entry
create_desktop_entry() {
    status "Creating desktop file..."
    cat > "$APPDIR/studio.desktop" << EOF
[Desktop Entry]
Name=$APP_NAME
Exec=studio %u
Icon=$ICON_NAME
Type=Application
Categories=Development;
StartupWMClass=studio
Comment=$APP_NAME
MimeType=x-scheme-handler/wpcom-local-dev;
X-GNOME-UsesNotifications=true
EOF
}

# Function to create MIME type file
create_mime_type() {
    status "Creating MIME type file..."
    cat > "$APPDIR/usr/share/mime/packages/wpcom-local-dev.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="x-scheme-handler/wpcom-local-dev">
    <comment>WordPress Studio Local Development</comment>
    <glob pattern="*.wpcom-local-dev"/>
  </mime-type>
</mime-info>
EOF
}

# Function to copy icon files
copy_icons() {
    status "Copying icon..."
    cp "${ICON_NAME}.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/"
    cp "${ICON_NAME}.png" "$APPDIR/${ICON_NAME}.png"
}

# Function to create AppRun script
create_apprun() {
    local exec_name="$1"
    status "Creating AppRun script..."
    cat > "$APPDIR/AppRun" << EOF
#!/bin/bash
set -euo pipefail

SELF=\$(readlink -f "\$0")
HERE=\${SELF%/*}
export PATH="\${HERE}/usr/bin/:\${PATH}"
export LD_LIBRARY_PATH="\${HERE}/usr/lib/:\${LD_LIBRARY_PATH}"
cd "\${HERE}/usr/bin"

# Register URL scheme handler
if [ ! -f "\$HOME/.local/share/applications/studio.desktop" ]; then
    mkdir -p "\$HOME/.local/share/applications"
    cat > "\$HOME/.local/share/applications/studio.desktop" << EOL
[Desktop Entry]
Name=$APP_NAME
Exec="\$SELF" %u
Icon=$ICON_NAME
Type=Application
Categories=Development;
StartupWMClass=studio
Comment=$APP_NAME
MimeType=x-scheme-handler/wpcom-local-dev;
X-GNOME-UsesNotifications=true
EOL
    update-desktop-database "\$HOME/.local/share/applications"
fi

# Handle URL scheme
if [ "\$1" != "" ]; then
    exec "\${HERE}/usr/bin/$exec_name" "\$1"
else
    exec "\${HERE}/usr/bin/$exec_name"
fi
EOF
    chmod +x "$APPDIR/AppRun"
}

# Function to download runtime
download_runtime() {
    if [ ! -f runtime ]; then
        status "Downloading AppImage runtime..."
        wget -O runtime "$RUNTIME_URL"
    fi
}

# Function to build AppImage
build_appimage() {
    status "Creating AppImage..."
    ARCH=x86_64 appimagetool --appimage-extract-and-run "$APPDIR" Studio-x86_64.AppImage
}

# Main execution
main() {
    check_requirements
    STUDIO_EXEC_NAME=$(find_studio_executable)
    create_appdir_structure
    copy_app_files "$STUDIO_EXEC_NAME"
    create_desktop_entry
    create_mime_type
    copy_icons
    create_apprun "$STUDIO_EXEC_NAME"
    download_runtime
    build_appimage
    status "Done! AppImage created: Studio-x86_64.AppImage"
}

# Run main function
main
