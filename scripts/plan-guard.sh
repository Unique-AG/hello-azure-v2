#!/bin/bash
set -euo pipefail
# Foundation guard: fail if a Terraform plan deletes or replaces anything.
#
# Used by apply-on-merge for the foundation layers (day-0, day-1, gh-test), which are hard to re-create.
# Such a change must run by manual dispatch with the explicit confirmation instead.
#
# Usage: scripts/plan-guard.sh <plan.json>   (from `terraform show -json tfplan`)

PLAN_JSON="${1:?usage: plan-guard.sh <plan.json>}"

# A replace shows up as ["delete","create"] or ["create","delete"], so "delete" covers both.
blocked="$(jq -r '.resource_changes[]? | select(.change.actions | index("delete")) | "\(.change.actions | join("/")) \(.address)"' "$PLAN_JSON")"

if [[ -n "$blocked" ]]; then
    count="$(printf '%s\n' "$blocked" | wc -l | tr -d ' ')"
    echo "::error title=Foundation guard::The plan deletes or replaces ${count} resource(s) in a foundation layer. Not applied."
    printf '%s\n' "$blocked" | sed 's/^/  /'
    echo "Review the plan; if the change is intended, run the workflow by dispatch with confirm=apply-foundation."
    exit 1
fi

echo "Foundation guard: no deletes or replaces."
