#!/bin/bash
set -e

# Create files directory
mkdir -p files

# Download the latest Studio release
LATEST_VERSION=$(curl -s https://api.github.com/repos/Automattic/studio/releases/latest | jq -r '.tag_name' | sed 's/^v//')
echo "Downloading Studio version $LATEST_VERSION..."

# Download the Linux x64 release
wget -O studio.zip "https://github.com/Automattic/studio/releases/download/v${LATEST_VERSION}/Studio-${LATEST_VERSION}-linux-x64.zip"

# Extract the files
unzip studio.zip -d files/

# Create desktop file
cat > com.automattic.Studio.desktop << EOF
[Desktop Entry]
Name=WordPress Studio
Exec=studio %u
Icon=com.automattic.Studio
Type=Application
Categories=Development;
StartupWMClass=studio
Comment=WordPress Studio
MimeType=x-scheme-handler/wpcom-local-dev;
X-GNOME-UsesNotifications=true
EOF

# Download icon
wget -O com.automattic.Studio.png "https://raw.githubusercontent.com/Automattic/studio/main/assets/studio-app-icon.png"

# Make build script executable
chmod +x build.sh

echo "Files prepared successfully!" 