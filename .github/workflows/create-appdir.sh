#!/bin/bash
set -e

APPDIR=AppDir
STUDIO_DIST=studio/dist/cli
STUDIO_NODE_MODULES=studio/node_modules
ICON_SRC=""
ICON_DST1="$APPDIR/usr/share/icons/hicolor/256x256/apps/studio.png"
ICON_DST2="$APPDIR/studio.png"

echo "Creating AppDir structure..."
mkdir -p $APPDIR/usr/bin
mkdir -p $APPDIR/usr/lib
mkdir -p $APPDIR/usr/share/applications
mkdir -p $APPDIR/usr/share/icons/hicolor/256x256/apps
mkdir -p $APPDIR/opt/studio/app
mkdir -p $APPDIR/opt/studio/config

# Create default config file
cat > $APPDIR/opt/studio/config/config.json << 'EOF'
{
    "version": "1.0.0",
    "settings": {
        "preview": {
            "enabled": true
        }
    },
    "paths": {
        "data": "${APPDIR}/opt/studio/data"
    }
}
EOF

# Create data directory in AppDir
mkdir -p $APPDIR/opt/studio/data/preview
mkdir -p $APPDIR/opt/studio/data/cache

# Copy Node.js runtime and built-in modules
echo "Copying Node.js runtime..."
cp -r node-bundle/{bin,lib,include,share} $APPDIR/opt/studio/

# Copy application files
echo "Copying application files..."
cp -r $STUDIO_DIST/* $APPDIR/opt/studio/app/
if [ -d "$STUDIO_NODE_MODULES" ]; then
  cp -r $STUDIO_NODE_MODULES $APPDIR/opt/studio/app/
fi

# Create AppRun
cat > $APPDIR/AppRun << 'EOF'
#!/bin/bash
set -e

# Set up environment
HERE="$(dirname "$(readlink -f "${0}")")"
export APPDIR="$HERE"
export PATH="${APPDIR}/opt/studio/bin:${PATH}"
export LD_LIBRARY_PATH="${APPDIR}/opt/studio/lib:${APPDIR}/usr/lib:${LD_LIBRARY_PATH:-}"
export NODE_PATH="${APPDIR}/opt/studio/app/node_modules"

# Create minimal config
CONFIG_DIR="${HOME}/.config/studio"
mkdir -p "${CONFIG_DIR}"

# Create a minimal config file
cat > "${CONFIG_DIR}/config.json" << 'CONFIGEOF'
{
    "version": "1.0.0",
    "settings": {
        "preview": {
            "enabled": true
        }
    }
}
CONFIGEOF

# Create data directory
DATA_DIR="${HOME}/.local/share/studio"
mkdir -p "${DATA_DIR}"

# Set environment variables
export STUDIO_CONFIG_DIR="${CONFIG_DIR}"
export STUDIO_DATA_DIR="${DATA_DIR}"

# Run the application
cd "${HOME}"
exec "${APPDIR}/opt/studio/bin/node" "${APPDIR}/opt/studio/app/main.js" "$@"
EOF
chmod +x $APPDIR/AppRun

# Create wrapper script
cat > $APPDIR/usr/bin/studio << 'EOF'
#!/bin/bash
set -e

# Set up environment
HERE="$(dirname "$(readlink -f "${0}")")"
export APPDIR="$(dirname "$(dirname "$HERE")")"
export PATH="${APPDIR}/opt/studio/bin:${PATH}"
export LD_LIBRARY_PATH="${APPDIR}/opt/studio/lib:${APPDIR}/usr/lib:${LD_LIBRARY_PATH:-}"
export NODE_PATH="${APPDIR}/opt/studio/app/node_modules"

# Create minimal config
CONFIG_DIR="${HOME}/.config/studio"
mkdir -p "${CONFIG_DIR}"

# Create a minimal config file
cat > "${CONFIG_DIR}/config.json" << 'CONFIGEOF'
{
    "version": "1.0.0",
    "settings": {
        "preview": {
            "enabled": true
        }
    }
}
CONFIGEOF

# Create data directory
DATA_DIR="${HOME}/.local/share/studio"
mkdir -p "${DATA_DIR}"

# Set environment variables
export STUDIO_CONFIG_DIR="${CONFIG_DIR}"
export STUDIO_DATA_DIR="${DATA_DIR}"

# Run the application
cd "${HOME}"
exec "${APPDIR}/opt/studio/bin/node" "${APPDIR}/opt/studio/app/main.js" "$@"
EOF
chmod +x $APPDIR/usr/bin/studio

# Create desktop entry
cat > $APPDIR/studio.desktop << EOF
[Desktop Entry]
Name=Studio
Exec=studio %U
Icon=studio
Type=Application
Categories=Development;
MimeType=x-scheme-handler/wpcom-local-dev;
X-AppImage-Version=$1
EOF

# Copy icon
if [ -f "studio/icon.png" ]; then
  ICON_SRC="studio/icon.png"
elif [ -f "icon.png" ]; then
  ICON_SRC="icon.png"
fi

if [ -n "$ICON_SRC" ]; then
  cp "$ICON_SRC" "$ICON_DST1"
  cp "$ICON_SRC" "$ICON_DST2"
else
  echo "Warning: Icon file not found, using default icon"
  convert -size 256x256 xc:transparent -font DejaVu-Sans -pointsize 24 -gravity center -draw "text 0,0 'Studio'" "$ICON_DST2"
  cp "$ICON_DST2" "$ICON_DST1"
fi 