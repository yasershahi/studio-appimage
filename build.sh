#!/bin/bash
set -e
sudo apt-get update
sudo apt-get install -y git nodejs npm python3 python3-pip libfuse2 wget desktop-file-utils patchelf
wget -O appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x appimagetool
git clone https://github.com/Automattic/studio.git
cd studio
npm install
npm run make
mkdir -p AppDir/usr/bin AppDir/usr/share/applications AppDir/usr/share/icons/hicolor/256x256/apps
cp -r out/make/* AppDir/usr/bin/
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
cat > AppDir/AppRun << EOL
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin/:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib/:${LD_LIBRARY_PATH}"
exec "${HERE}/usr/bin/studio" "$@"
EOL
chmod +x AppDir/AppRun
ARCH=x86_64 ./appimagetool AppDir
cd ..
rm -rf studio
rm appimagetool
