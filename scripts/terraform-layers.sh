#!/bin/bash
set -euo pipefail
# Decide which Terraform layers a run of test.terraform.yaml touches, and whether it plans or applies.
# Prints GITHUB_OUTPUT lines: day-0/day-1/gh-test/day-2/day-3=true|false, mode=plan|apply, guard=true|false.
#
# A changed layer also runs every layer downstream of it:
#   day-0 → all · day-1 → day-1, gh-test, day-2, day-3 · day-2 → day-2, day-3 · gh-test, day-3 → themselves.
#
# Input (env): EVENT, REF, PR_BASE, PR_HEAD, PR_REPO, REPO, PUSH_BEFORE, PUSH_AFTER, INPUT_LAYERS, INPUT_CONFIRM.
# CHANGED_FILES (newline-separated) replaces the git diff; scripts/terraform-layers.test.sh uses it.

d0=false d1=false gh=false d2=false d3=false
mode=plan
guard=true

mark() {
    local l
    for l in "$@"; do
        case "$l" in
            day-0) d0=true ;; day-1) d1=true ;; gh-test) gh=true ;; day-2) d2=true ;; day-3) d3=true ;;
            *) echo "Unknown layer '$l'" >&2; exit 2 ;;
        esac
    done
}

with_downstream() {
    case "$1" in
        day-0) mark day-0 day-1 gh-test day-2 day-3 ;;
        day-1) mark day-1 gh-test day-2 day-3 ;;
        day-2) mark day-2 day-3 ;;
        gh-test | day-3) mark "$1" ;;
    esac
}

map_path() {
    case "$1" in
        01_bootstrap/day-0/* | 01_bootstrap/environments/*) with_downstream day-0 ;;
        02_infrastructure/day-1/* | 02_infrastructure/environments/test/*day-1*) with_downstream day-1 ;;
        02_infrastructure/gh-test/* | 02_infrastructure/environments/test/*-gh*) with_downstream gh-test ;;
        02_infrastructure/day-2/* | 02_infrastructure/environments/test/*day-2* | \
            02_infrastructure/environments/test/prometheus-rules.auto.tfvars) with_downstream day-2 ;;
        02_infrastructure/day-3/* | 02_infrastructure/environments/test/*day-3*) with_downstream day-3 ;;
        # The pipeline itself or the Terraform version changed: plan everything.
        .github/workflows/test.terraform.yaml | .github/actions/terraform/* | .terraform-version | \
            scripts/plan-guard.sh | scripts/terraform-layers.sh) with_downstream day-0 ;;
    esac
}

files=""
case "${EVENT:-}" in
    pull_request)
        if [[ "${PR_REPO:-}" != "${REPO:-}" ]]; then
            echo "Pull request from a fork: no Azure login is possible, so no layer runs." >&2
        else
            files="${CHANGED_FILES-$(git diff --name-only "$PR_BASE...$PR_HEAD")}"
        fi
        ;;
    push)
        mode=apply
        if [[ -z "${PUSH_BEFORE:-}" || "$PUSH_BEFORE" =~ ^0+$ ]]; then
            with_downstream day-0
        else
            files="${CHANGED_FILES-$(git diff --name-only "$PUSH_BEFORE" "$PUSH_AFTER")}"
        fi
        ;;
    workflow_dispatch)
        [[ "${REF:-}" == "refs/heads/main" ]] && mode=apply
        [[ "${INPUT_CONFIRM:-}" == "apply-foundation" ]] && guard=false
        if [[ -z "${INPUT_LAYERS:-}" || "$INPUT_LAYERS" == "all" ]]; then
            with_downstream day-0
        else
            IFS=',' read -ra wanted <<< "$INPUT_LAYERS"
            for l in "${wanted[@]}"; do mark "$(echo "$l" | tr -d '[:space:]')"; done
        fi
        ;;
    *)
        echo "Unsupported event '${EVENT:-}'" >&2
        exit 2
        ;;
esac

while IFS= read -r f; do
    [[ -n "$f" ]] && map_path "$f"
done <<< "$files"

echo "day-0=$d0"
echo "day-1=$d1"
echo "gh-test=$gh"
echo "day-2=$d2"
echo "day-3=$d3"
echo "mode=$mode"
echo "guard=$guard"
