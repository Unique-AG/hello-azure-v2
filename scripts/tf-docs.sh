#!/bin/bash
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd
## Reference: https://github.com/norwoodj/helm-docs
TF_DOCS_VERSION="0.20.0"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "Repo root: $REPO_ROOT"

# Change to repo root to ensure consistent paths
cd "$REPO_ROOT" || exit 1

echo "Running tf-docs"

# Try Docker first, fallback to local terraform-docs if Docker mount fails
USE_DOCKER=true
if ! docker info &>/dev/null; then
    USE_DOCKER=false
elif ! docker run --rm --volume "$REPO_ROOT:/workdir" alpine:latest test -d /workdir &>/dev/null; then
    # Docker can't access the path, try local installation
    if command -v terraform-docs &>/dev/null; then
        echo "Docker mount failed, using local terraform-docs"
        USE_DOCKER=false
    fi
fi

# Find all tfdocs.yaml files and process each one (excluding .terraform directories)
find . -path "*/.terraform" -prune -o -name "tfdocs.yaml" -print | while read -r config_file; do
    # Get the directory containing the tfdocs.yaml file
    dir=$(dirname "$config_file")
    
    echo "Processing $dir with config $config_file"
    
    if [ "$USE_DOCKER" = true ]; then
        docker run \
            --rm --volume "$REPO_ROOT:/workdir" \
            -u "$(id -u)" \
            -w /workdir \
            quay.io/terraform-docs/terraform-docs:$TF_DOCS_VERSION "/workdir/$dir" \
            --config "/workdir/$config_file" || {
            # If Docker fails, try local if available
            if command -v terraform-docs &>/dev/null; then
                echo "Docker failed, falling back to local terraform-docs"
                config_basename=$(basename "$config_file")
                (cd "$dir" && terraform-docs . --config "$config_basename")
            else
                echo "Error: Docker mount failed and terraform-docs not found locally" >&2
                exit 1
            fi
        }
    else
        config_basename=$(basename "$config_file")
        (cd "$dir" && terraform-docs . --config "$config_basename")
    fi
done
