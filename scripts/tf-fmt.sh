#!/bin/bash
set -euo pipefail
# SPDX-SnippetBegin
# SPDX-License-Identifier: Proprietary
# SPDX-SnippetCopyrightText: 2024 © Unique AG
# SPDX-SnippetEnd

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "Repo root: $REPO_ROOT"
echo "Running tf-fmt"

cd "$REPO_ROOT"

terraform fmt -recursive 01_bootstrap
terraform fmt -recursive 02_infrastructure
terraform fmt -recursive 03_applications
