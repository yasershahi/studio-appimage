#!/bin/bash
set -euo pipefail

# Check arguments
VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    echo "Error: Version parameter required"
    exit 1
fi

# Configuration
WORK_DIR="$(pwd)/workspace"
APPDIR="$WORK_DIR/AppDir"
NODE_VERSION="22.12.0"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

echo "=== Preparing workspace ==="
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
mkdir -p "$APPDIR"/{usr/{bin,lib},opt/studio}

echo "=== Downloading Studio $VERSION ==="
cd "$WORK_DIR"
curl -L "https://github.com/Automattic/studio/archive/refs/tags/$VERSION.tar.gz" | tar xz
mv studio-* studio-src

echo "=== Setting up Node.js ==="
curl -L "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar xJ
mv node-v${NODE_VERSION}-linux-x64 node

echo "=== Building Studio ==="
cd studio-src
export PATH="$WORK_DIR/node/bin:$PATH"
npm ci
npm run make package
npm prune --production # Remove development dependencies

# Patch Studio source to disable native title bar
echo "=== Patching Studio to disable native title bar ==="
MAIN_JS_PATH=$(jq -r '.main' studio-src/package.json)
if [ -f "studio-src/$MAIN_JS_PATH" ]; then
    sed -i '/new BrowserWindow({/a \ \ \ \ \ \ \ \ frame: false,' "studio-src/$MAIN_JS_PATH" || echo "Warning: Could not patch $MAIN_JS_PATH for title bar. Manual intervention may be required."
else
    echo "Warning: Could not find main entry point at studio-src/$MAIN_JS_PATH. Manual intervention may be required."
fi

# Debug: List output directory
echo "=== Checking build output ==="
ls -la out/Studio-linux-x64/

echo "=== Creating AppDir structure ==="
# Copy all binary files from the output directory
cp -r out/Studio-linux-x64/* "$APPDIR/usr/bin/"
chmod +x "$APPDIR/usr/bin/studio"

# Remove unnecessary files
find "$APPDIR" -name "*.a" -delete
find "$APPDIR" -name "*.la" -delete
find "$APPDIR" -name "*.pdb" -delete
find "$APPDIR" -name "*.dll.lib" -delete
find "$APPDIR" -type f -name "LICENSE*" -delete
find "$APPDIR" -type f -name "README*" -delete

# Create AppRun
ln -sf usr/bin/studio "$APPDIR/AppRun"

# Copy icon from our repo
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
MimeType=x-scheme-handler/wpcom-local-dev;
Version=1.0
X-AppImage-Version=$VERSION
X-AppImage-UpdateInformation=github-releases-with-tag-based-channels:Automattic/studio
EOF

echo "=== Building AppImage ==="
cd "$WORK_DIR"
wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool-x86_64.AppImage

# Set update information for AppImage
export UPDATE_INFORMATION="github-releases-with-tag-based-channels:Automattic/studio"

# Build compressed AppImage
export APPIMAGE_COMPRESS_TYPE="xz"
export APPIMAGE_COMPRESS_LEVEL="9"
ARCH=x86_64 ./appimagetool-x86_64.AppImage --comp xz "$APPDIR" "Studio-$VERSION-x86_64.AppImage"

echo "=== Build Complete ==="
echo "AppImage created at: $WORK_DIR/Studio-$VERSION-x86_64.AppImage"