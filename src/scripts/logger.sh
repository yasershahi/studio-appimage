#!/bin/bash

# Source configuration
source "$(dirname "${BASH_SOURCE[0]}")/../config/config.sh"

# Log levels
declare -A LOG_LEVELS=(
    ["DEBUG"]=0
    ["INFO"]=1
    ["WARNING"]=2
    ["ERROR"]=3
)

# Get current log level
get_log_level() {
    echo "${LOG_LEVELS[$LOG_LEVEL]:-1}"
}

# Log message with timestamp and level
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Check if we should log this message based on log level
    if [ "${LOG_LEVELS[$level]:-0}" -ge "$(get_log_level)" ]; then
        echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
    fi
}

# Convenience functions for different log levels
debug() {
    log "DEBUG" "$1"
}

info() {
    log "INFO" "$1"
}

warning() {
    log "WARNING" "$1"
}

error() {
    log "ERROR" "$1"
    return 1
}

# Function to check if a command exists
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        error "Required command '$cmd' not found"
        return 1
    fi
    return 0
}

# Function to check if a file exists
check_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        error "Required file '$file' not found"
        return 1
    fi
    return 0
}

# Function to check if a directory exists
check_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        error "Required directory '$dir' not found"
        return 1
    fi
    return 0
}

# Initialize logging
init_logging() {
    # Create log file if it doesn't exist
    touch "$LOG_FILE"
    info "Logging initialized"
} 