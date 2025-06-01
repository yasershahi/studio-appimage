#!/bin/bash

# Source configuration and utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../config/config.sh"
source "${SCRIPT_DIR}/logger.sh"

# Initialize logging
init_logging

# Function to check build requirements
check_requirements() {
    info "Checking build requirements..."
    
    # Check required commands
    check_command "wget" || return 1
    check_command "appimagetool" || return 1
    
    # Check required files and directories
    check_directory "files" || return 1
    check_file "${ICON_FILE}" || return 1
    
    info "All requirements satisfied"
    return 0
}

# Function to find studio executable
find_studio_executable() {
    info "Looking for studio executable..."
    local studio_exec
    studio_exec=$(find files -type f -executable -name "studio*" | head -n 1)
    
    if [ -z "$studio_exec" ]; then
        error "Could not find studio executable in files directory"
        return 1
    fi
    
    info "Found studio executable at: $studio_exec"
    echo "$(basename "$studio_exec")"
}

# Function to create AppDir structure
create_appdir_structure() {
    info "Creating AppDir structure..."
    rm -rf "$APPDIR"
    mkdir -p "$APPDIR/usr/"{bin,lib,share/{applications,icons/hicolor/256x256/apps,mime/packages}}
}

# Function to copy application files
copy_app_files() {
    local exec_name="$1"
    info "Copying application files..."
    cp -r files/* "$APPDIR/usr/bin/"
    chmod +x "$APPDIR/usr/bin/$exec_name"
}

# Function to process template files
process_template() {
    local template="$1"
    local output="$2"
    info "Processing template: $template -> $output"
    
    # Read template and replace variables
    envsubst < "$template" > "$output"
}

# Function to copy and process templates
process_templates() {
    info "Processing templates..."
    
    # Process desktop entry
    process_template "${TEMPLATES_DIR}/desktop.template" "$APPDIR/studio.desktop"
    
    # Process MIME type
    process_template "${TEMPLATES_DIR}/mime.template" "$APPDIR/usr/share/mime/packages/${MIME_FILE}"
    
    # Process AppRun
    process_template "${TEMPLATES_DIR}/apprun.template" "$APPDIR/AppRun"
    chmod +x "$APPDIR/AppRun"
}

# Function to copy icons
copy_icons() {
    info "Copying icons..."
    cp "${ICON_FILE}" "$APPDIR/usr/share/icons/hicolor/256x256/apps/"
    cp "${ICON_FILE}" "$APPDIR/${APP_ID}.png"
}

# Function to download runtime
download_runtime() {
    if [ ! -f runtime ]; then
        info "Downloading AppImage runtime..."
        wget -O runtime "$RUNTIME_URL" || {
            error "Failed to download AppImage runtime"
            return 1
        }
    fi
}

# Function to build AppImage
build_appimage() {
    info "Creating AppImage..."
    ARCH="$ARCH" appimagetool --appimage-extract-and-run "$APPDIR" "$OUTPUT_FILE" || {
        error "Failed to create AppImage"
        return 1
    }
}

# Main execution
main() {
    info "Starting build process..."
    
    # Check requirements
    check_requirements || exit 1
    
    # Find studio executable
    STUDIO_EXEC_NAME=$(find_studio_executable) || exit 1
    
    # Create AppDir structure
    create_appdir_structure
    
    # Copy application files
    copy_app_files "$STUDIO_EXEC_NAME"
    
    # Process templates
    process_templates
    
    # Copy icons
    copy_icons
    
    # Download runtime
    download_runtime || exit 1
    
    # Build AppImage
    build_appimage || exit 1
    
    info "Build completed successfully: $OUTPUT_FILE"
}

# Run main function
main 