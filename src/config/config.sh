#!/bin/bash

# Application Information
APP_NAME="WordPress Studio"
APP_ID="com.automattic.Studio"
APP_VERSION="1.0.0"

# Directory Structure
APPDIR="AppDir"
SRC_DIR="src"
TEMPLATES_DIR="${SRC_DIR}/templates"
SCRIPTS_DIR="${SRC_DIR}/scripts"

# File Paths
ICON_FILE="${APP_ID}.png"
DESKTOP_FILE="${APP_ID}.desktop"
MIME_FILE="wpcom-local-dev.xml"

# URLs
RUNTIME_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64"

# Desktop Integration
DESKTOP_CATEGORIES="Development;"
DESKTOP_MIME_TYPE="x-scheme-handler/wpcom-local-dev"
DESKTOP_STARTUP_WM_CLASS="studio"

# Build Settings
ARCH="x86_64"
OUTPUT_FILE="Studio-${ARCH}.AppImage"

# Logging
LOG_LEVEL="INFO"  # DEBUG, INFO, WARNING, ERROR
LOG_FILE="build.log" 