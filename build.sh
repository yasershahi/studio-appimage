#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run the main build script
"${SCRIPT_DIR}/src/scripts/build.sh"
