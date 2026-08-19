# 1. Single `main` branch

Date: 2026-08-19

## Status

Accepted

## Context

The repository accumulated a three-branch model (`main`, `preview`, `release`) plus
dozens of work branches. `main` had been abandoned since the bastion work (#21),
`preview` served as the integration branch (CI triggers, ArgoCD revision), and
`release` was the tagged, protected audit trunk. In practice every release landed on
`preview` via squash-merge PRs and was promoted to `release`, so the two branches were
nearly always identical, while the stale `main` remained GitHub's default branch. The
`dev` environment the model partly existed for no longer exists.

Customer-facing releases are immutable GitHub Releases bound to SHA-pinned tags, and
customers compare releases tag-to-tag — a workflow independent of branch refs.

## Decision

Collapse to a single `main` branch carrying the reconciled newest content
(`release` + `preview`), retarget all CI triggers/guards and all ArgoCD
`targetRevision`/`revision` refs to `main`, and delete every other branch.

Cutover is a **force-push to the existing `main`** rather than a delete-and-rename
dance: the default branch already points at `main`, `main` carries no protection until
after the cutover, and old main's only unique commit is a superseded bastion
implementation. Branch protection moves via a single infrastructure-repo PR
(`providers/github/unique-ag/repos/hello-azure-v2.yaml`): the `release` rules
(enforce admins, signed commits, PR reviews) transfer verbatim to `main`.

`preview` and `release` remain frozen until ArgoCD is verified healthy on `main` and
the protection PR is applied; only then are they deleted.

## Consequences

- One trunk: PRs target `main`; pushes to `main` drive test deploys and mirroring.
- Releases/tags and the tag-to-tag compare workflow are unaffected (verified against a
  pre-migration baseline of every consecutive release pair).
- All changes land via signed, reviewed PRs once protection applies.
- Historic side-branch commits stay reachable via tags (`2026.24.2`,
  `*-pre-realign`) and closed PR refs; the deleted branch tips of `preview`/`release`
  remain ancestors of `main` and can be recreated at any time.
