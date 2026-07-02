---
name: tf-plan-diff
description: Run terraform plan and summarize the diff (adds/changes/destroys) as input for a plan or review. Use before any terraform apply, or when assessing the blast radius of a proposed change.
---

# Terraform Plan Diff

## Workflow

1. Confirm with the user before running `terraform init`/`plan` against a real backend — it can touch remote state locking.
2. `terraform init -input=false` if `.terraform/` doesn't exist.
3. `terraform plan -out=tfplan -input=false`, then `terraform show -json tfplan` to get structured output.
4. Summarize by action: N to add, N to change, N to destroy. List every destroy explicitly by resource address — these are the ones that need a human look.
5. If plan fails on missing credentials/vars, report exactly what's missing — don't guess values.

## Rules

- Never run `terraform apply` from this skill.
- Always show the plan output (or its summary) to the user before they apply — per project convention, plan always precedes apply.
- Delete the local `tfplan` file when done unless the user wants to apply it.
