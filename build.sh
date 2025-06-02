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
NODE_ENV=production npm run cli:build

echo "=== Creating AppDir structure ==="
# Copy Node.js runtime
cp -r "$WORK_DIR/node/bin" "$APPDIR/opt/studio/"
cp -r "$WORK_DIR/node/lib" "$APPDIR/opt/studio/"

# Copy Studio files
cp -r dist/cli/* "$APPDIR/opt/studio/"
cp -r node_modules "$APPDIR/opt/studio/"

# Create wrapper script
cat > "$APPDIR/usr/bin/studio" << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export APPDIR="$(dirname "$(dirname "$HERE")")"
export PATH="${APPDIR}/opt/studio/bin:${PATH}"
export NODE_PATH="${APPDIR}/opt/studio/node_modules"
exec "${APPDIR}/opt/studio/bin/node" "${APPDIR}/opt/studio/main.js" "$@"
EOF
chmod +x "$APPDIR/usr/bin/studio"

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
EOF

echo "=== Building AppImage ==="
cd "$WORK_DIR"
wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage "$APPDIR" "Studio-$VERSION-x86_64.AppImage"

echo "=== Build Complete ==="
echo "AppImage created at: $WORK_DIR/Studio-$VERSION-x86_64.AppImage"