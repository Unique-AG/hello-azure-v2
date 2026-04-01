#!/bin/bash
set -euo pipefail
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE=".github/configs/tfsec.yaml"

# Parse arguments
MODE="${1:-docker}"  # Default to docker mode

usage() {
    echo "Usage: $0 [docker|native]"
    echo ""
    echo "Modes:"
    echo "  docker  - Run tfsec via Docker (default, requires Docker)"
    echo "  native  - Run tfsec via native binary (for WSL2 or local development)"
    exit 1
}

if [[ "$MODE" != "docker" && "$MODE" != "native" ]]; then
    echo "Error: Unknown mode '$MODE'"
    usage
fi

echo "Running tf-sec"
echo "Mode: $MODE"

cd "$REPO_ROOT"

# Function to run tfsec via Docker
run_docker() {
    local cmd="docker run --rm -v $(pwd):/workdir aquasec/tfsec /workdir --config-file /workdir/${CONFIG_FILE}"
    
    # Add SARIF output options only in GitHub Actions
    if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
        # Create the output file with write permissions before mounting
        touch tfsec-results.sarif
        chmod 666 tfsec-results.sarif
        cmd="$cmd --format sarif --out /workdir/tfsec-results.sarif --soft-fail"
    fi
    
    eval "$cmd"
}

# Function to run tfsec natively
run_native() {
    # Check if tfsec is installed
    if ! command -v tfsec &> /dev/null; then
        echo "tfsec not found. Installing..."
        curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
        echo "tfsec installed successfully"
    fi
    
    local cmd="tfsec . --config-file ${CONFIG_FILE}"
    
    # Add SARIF output options only in GitHub Actions
    if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
        cmd="$cmd --format sarif --out tfsec-results.sarif --soft-fail"
    fi
    
    eval "$cmd"
}

# Run in selected mode
if [[ "$MODE" == "docker" ]]; then
    run_docker
else
    run_native
fi
