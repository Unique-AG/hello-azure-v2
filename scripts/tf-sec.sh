#!/bin/bash
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

echo "Running tf-sec"

# Try Docker first, fallback to local tfsec if Docker mount fails
USE_DOCKER=true
if ! docker info &>/dev/null; then
    USE_DOCKER=false
elif ! docker run --rm --volume "$REPO_ROOT:/workdir" alpine:latest test -d /workdir &>/dev/null; then
    # Docker can't access the path, try local installation
    if command -v tfsec &>/dev/null; then
        echo "Docker mount failed, using local tfsec"
        USE_DOCKER=false
    fi
fi

if [ "$USE_DOCKER" = true ]; then
    # Base Docker command
    CMD="docker run --rm --volume \"$REPO_ROOT:/workdir\" aquasec/tfsec /workdir --config-file /workdir/.github/configs/tfsec.yaml"
    
    # Add SARIF output options only in GitHub Actions
    if [ "${GITHUB_ACTIONS}" = "true" ]; then
        # Create the output file with write permissions before mounting, so the docker run command can write to it
        touch tfsec-results.sarif
        chmod 666 tfsec-results.sarif
        CMD="$CMD --format sarif --out /workdir/tfsec-results.sarif --soft-fail"
    fi
    
    # Execute the command
    eval "$CMD" || {
        # If Docker fails, try local if available
        if command -v tfsec &>/dev/null; then
            echo "Docker failed, falling back to local tfsec"
            if [ "${GITHUB_ACTIONS}" = "true" ]; then
                tfsec . --config-file .github/configs/tfsec.yaml --format sarif --out tfsec-results.sarif --soft-fail
            else
                tfsec . --config-file .github/configs/tfsec.yaml
            fi
        else
            echo "Error: Docker mount failed and tfsec not found locally" >&2
            exit 1
        fi
    }
else
    # Use local tfsec
    if [ "${GITHUB_ACTIONS}" = "true" ]; then
        tfsec . --config-file .github/configs/tfsec.yaml --format sarif --out tfsec-results.sarif --soft-fail
    else
        tfsec . --config-file .github/configs/tfsec.yaml
    fi
fi
