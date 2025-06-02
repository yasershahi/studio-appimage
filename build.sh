#!/bin/bash
set -euo pipefail

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    echo "Error: Version parameter required"
    exit 1
fi

# Setup working directories
WORK_DIR="$(pwd)/files"
BUILD_DIR="$WORK_DIR/build"
APPDIR="$WORK_DIR/AppDir"

mkdir -p "$WORK_DIR" "$BUILD_DIR" "$APPDIR"/{usr/{bin,lib},opt/studio}

# Download and extract Studio source
echo "Downloading Studio $VERSION..."
curl -L "https://github.com/Automattic/studio/archive/refs/tags/$VERSION.tar.gz" | tar xz -C "$BUILD_DIR"
mv "$BUILD_DIR"/studio-* "$BUILD_DIR/studio"

# Build Studio
cd "$BUILD_DIR/studio"
echo "Installing dependencies..."
npm ci
echo "Building application..."
NODE_ENV=production npm run cli:build

# Prepare AppDir
echo "Creating AppImage structure..."
cp -r dist/cli/* "$APPDIR/opt/studio/"
cp -r node_modules "$APPDIR/opt/studio/"

# Copy application icon
echo "Copying application icon..."
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps/"
cp "$SCRIPT_DIR/studio.png" "$APPDIR/studio.png"
cp "$SCRIPT_DIR/studio.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/studio.png"

# Create desktop entry
cat > "$APPDIR/studio.desktop" << EOF
[Desktop Entry]
Name=Studio
Exec=studio %U
Icon=studio
Type=Application
Categories=Development;
Version=$VERSION
EOF

# Download and use appimagetool
wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool-x86_64.AppImage

# Build final AppImage
echo "Creating AppImage..."
ARCH=x86_64 ./appimagetool-x86_64.AppImage "$APPDIR" "../Studio-$VERSION-x86_64.AppImage"

echo "Build complete! AppImage created at: Studio-$VERSION-x86_64.AppImage"