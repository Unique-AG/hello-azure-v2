#!/bin/bash
set -euo pipefail
# Runnable check for scripts/terraform-layers.sh (path → layer mapping, mode and guard).
cd "$(dirname "$0")"

fail=0
# expect <description> <expected "d0 d1 gh d2 d3 mode guard"> -- env assignments...
expect() {
    local desc="$1" want="$2"; shift 3
    local got
    got="$(env -i PATH="$PATH" "$@" ./terraform-layers.sh | cut -d= -f2 | tr '\n' ' ' | sed 's/ $//')"
    if [[ "$got" != "$want" ]]; then
        echo "FAIL: $desc: want '$want', got '$got'" >&2
        fail=1
    fi
}

PR=(EVENT=pull_request REPO=Unique-AG/hello-azure-v2 PR_REPO=Unique-AG/hello-azure-v2)

expect "day-2 change plans day-2 and day-3" "false false false true true plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'02_infrastructure/day-2/29-postgresql.tf'
expect "day-1 change plans day-1 and everything downstream" "false true true true true plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'02_infrastructure/day-1/20-networking.tf'
expect "day-0 env file plans all" "true true true true true plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'01_bootstrap/environments/test/00-parameters-day-0.auto.tfvars'
expect "gh-test env file plans gh-test only" "false false true false false plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'02_infrastructure/environments/test/00-parameters-gh.auto.tfvars'
expect "prometheus rules plan day-2 and day-3" "false false false true true plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'02_infrastructure/environments/test/prometheus-rules.auto.tfvars'
expect "docs-only change runs no layer" "false false false false false plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'README.md\n03_applications/test/values/argo/argo.yaml'
expect "pipeline change plans all" "true true true true true plan true" -- \
    "${PR[@]}" CHANGED_FILES=$'.github/actions/terraform/action.yaml'
expect "fork PR runs no layer" "false false false false false plan true" -- \
    EVENT=pull_request REPO=Unique-AG/hello-azure-v2 PR_REPO=someone/hello-azure-v2 CHANGED_FILES=$'02_infrastructure/day-2/x.tf'
expect "push to main applies" "false false false true true apply true" -- \
    EVENT=push PUSH_BEFORE=abc PUSH_AFTER=def CHANGED_FILES=$'02_infrastructure/day-2/x.tf'
expect "first push applies all" "true true true true true apply true" -- \
    EVENT=push PUSH_BEFORE=0000000000000000000000000000000000000000
expect "dispatch on main with confirm turns the guard off" "false true false false false apply false" -- \
    EVENT=workflow_dispatch REF=refs/heads/main INPUT_LAYERS="day-1" INPUT_CONFIRM=apply-foundation
expect "dispatch on a branch only plans" "true false true false false plan true" -- \
    EVENT=workflow_dispatch REF=refs/heads/some-branch INPUT_LAYERS="day-0, gh-test"

[[ $fail == 0 ]] && echo "terraform-layers.test.sh: ok"
exit $fail
