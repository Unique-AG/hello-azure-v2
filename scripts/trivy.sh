#!/bin/bash
set -euo pipefail
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd
## Reference: https://trivy.dev
#
# Trivy scans of this repository's own code. Findings inside the downloaded terraform-modules are excluded:
# they can only be fixed in that shared repository.
#
#   config - Terraform misconfigurations; fails on HIGH or CRITICAL
#   secret - secrets committed to the repository; fails on HIGH or CRITICAL
#   sarif  - every misconfiguration severity as trivy-results.sarif for code scanning; never fails
#
# Accepted findings live in .trivyignore.yaml, each with the reason.
#
# Usage: scripts/trivy.sh [config|secret|sarif] [docker|native]

# Pinned by digest: the 0.69.4 release and the trivy-action tags were compromised in March 2026.
TRIVY_IMAGE="aquasec/trivy:0.76.1@sha256:790fd66d1697395d8693d1acaa1ea702406a20f109b6fc7bac8db623eca6c06c"

SCAN="${1:-config}"
MODE="${2:-docker}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

trivy_run() {
    if [[ "$MODE" == "docker" ]]; then
        docker run --rm -u "$(id -u):$(id -g)" -e HOME=/tmp \
            -v "$REPO_ROOT:/workdir" -w /workdir "$TRIVY_IMAGE" "$@"
    elif [[ "$MODE" == "native" ]]; then
        trivy "$@"
    else
        echo "Unknown mode '$MODE' (docker|native)" >&2
        exit 2
    fi
}

COMMON=(--cache-dir /tmp/trivy-cache --ignorefile .trivyignore.yaml --skip-dirs "**/.terraform")

case "$SCAN" in
    config)
        trivy_run config "${COMMON[@]}" --tf-exclude-downloaded-modules \
            --severity HIGH,CRITICAL --exit-code 1 .
        ;;
    secret)
        trivy_run fs "${COMMON[@]}" --scanners secret --severity HIGH,CRITICAL --exit-code 1 .
        ;;
    sarif)
        trivy_run config "${COMMON[@]}" --tf-exclude-downloaded-modules \
            --format sarif --output trivy-results.sarif .
        ;;
    *)
        echo "Unknown scan '$SCAN' (config|secret|sarif)" >&2
        exit 2
        ;;
esac
