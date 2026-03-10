#!/bin/bash
set -euo pipefail
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd
## Reference: https://github.com/norwoodj/helm-docs
TF_DOCS_VERSION="0.20.0"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Parse arguments
MODE="${1:-docker}"  # Default to docker mode

usage() {
    echo "Usage: $0 [docker|native]"
    echo ""
    echo "Modes:"
    echo "  docker  - Run terraform-docs via Docker (default, requires Docker)"
    echo "  native  - Run terraform-docs via native binary (for WSL2 or local development)"
    exit 1
}

if [[ "$MODE" != "docker" && "$MODE" != "native" ]]; then
    echo "Error: Unknown mode '$MODE'"
    usage
fi

echo "Repo root: $REPO_ROOT"
echo "Mode: $MODE"
echo "Running tf-docs"

cd "$REPO_ROOT"

# Function to run terraform-docs via Docker
run_docker() {
    local config_file="$1"
    local dir="$2"
    
    docker run \
        --rm --volume "$(pwd):/workdir" \
        -u "$(id -u)" "quay.io/terraform-docs/terraform-docs:${TF_DOCS_VERSION}" "/workdir/$dir" \
        --config "/workdir/$config_file"
}

# Function to run terraform-docs natively
run_native() {
    local config_file="$1"
    local dir="$2"
    
    # Check if terraform-docs is installed
    if ! command -v terraform-docs &> /dev/null; then
        echo "terraform-docs not found. Installing version ${TF_DOCS_VERSION}..."
        curl -sSLo /tmp/terraform-docs.tar.gz "https://terraform-docs.io/dl/v${TF_DOCS_VERSION}/terraform-docs-v${TF_DOCS_VERSION}-$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz"
        tar -xzf /tmp/terraform-docs.tar.gz -C /tmp
        sudo mv /tmp/terraform-docs /usr/local/bin/
        rm /tmp/terraform-docs.tar.gz
        echo "terraform-docs installed successfully"
    fi
    
    terraform-docs --config "$config_file" "$dir"
}

# Find all tfdocs.yaml files and process each one
# Exclude .terraform directories (downloaded module dependencies)
find . -name "tfdocs.yaml" -not -path "*/.terraform/*" | while read -r config_file; do
    # Get the directory containing the tfdocs.yaml file
    dir=$(dirname "$config_file")
    
    echo "Processing $dir with config $config_file"
    
    if [[ "$MODE" == "docker" ]]; then
        run_docker "$config_file" "$dir"
    else
        run_native "$config_file" "$dir"
    fi
done
