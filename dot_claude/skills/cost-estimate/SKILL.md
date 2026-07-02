---
name: cost-estimate
description: Estimate the cost impact of a Terraform change using infracost. Use during planning for changes that add or resize cloud resources.
---

# Terraform Cost Estimate

## Workflow

1. Check infracost is available: `command -v infracost`. If missing, tell the user to run `mise use -g infracost` — do not assume a system install.
2. Confirm `INFRACOST_API_KEY` is set (`infracost configure get api_key`). If not, tell the user how to set it and stop — don't attempt without it.
3. `infracost breakdown --path <dir>` for the current/proposed cost.
4. If a baseline plan exists (before the change), `infracost diff --path <dir> --compare-to <baseline.json>` to show the delta.
5. Fold the monthly delta into the plan's Risks section. Call out the raw number; let the user judge whether it's significant — don't editorialize with an arbitrary threshold.

## Rules

- Read-only against cloud cost data — never modifies infrastructure or state.
