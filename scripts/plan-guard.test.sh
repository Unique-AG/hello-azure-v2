#!/bin/bash
set -euo pipefail
# Runnable check for scripts/plan-guard.sh: a clean plan passes, a delete and a replace both fail.
cd "$(dirname "$0")"

./plan-guard.sh testdata/plan-clean.json >/dev/null

for f in testdata/plan-delete.json testdata/plan-replace.json; do
    if ./plan-guard.sh "$f" >/dev/null; then
        echo "FAIL: plan-guard.sh accepted $f" >&2
        exit 1
    fi
done

echo "plan-guard.test.sh: ok"
