---
name: tf-fmt-validate
description: Run terraform fmt and validate on changed HCL files. Use after writing or editing Terraform code, before handing it back as done.
---

# Terraform Format & Validate

## Workflow

1. Find changed `.tf` files: `git diff --name-only -- '*.tf'` (or the files you just wrote).
2. Check terraform is available: `command -v terraform`. If missing, tell the user to run `mise use -g terraform` — do not assume a system install.
3. Run `terraform fmt -check -diff` on the affected directories. If it reports diffs, run `terraform fmt` to fix them.
4. For each affected module directory: `terraform validate` (run `terraform init -backend=false` first if no `.terraform/` exists — this does not touch remote state).
5. Report pass/fail per module. Fix validate errors directly; do not silently ignore them.

## Rules

- Never run `terraform init` against a real backend without confirming with the user first.
- Never run `terraform apply` or `plan` from this skill — formatting/validation only.
