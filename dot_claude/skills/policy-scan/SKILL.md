---
name: policy-scan
description: Run static policy/security scanners (tfsec for Terraform, kube-score for Kubernetes) over changed infrastructure code. Use as a supplement to manual security review, not a replacement.
---

# Policy Scan

## Workflow

1. Check the relevant scanner is available (`command -v tfsec`, `command -v kube-score`). If missing, tell the user to run `mise use -g tfsec kube-score` — do not assume a system install.
2. For changed `.tf` files: `tfsec <dir>`.
3. For changed Kubernetes manifests or Helm output: `kube-score score <file(s)>` or `helm template <chart> | kube-score score -`.
4. Merge findings into the Security Reviewer's severity-bucketed output. Dedupe against anything already found manually.
5. Treat every scanner hit as a lead, not a verdict — verify it against the actual file and repo context before reporting; scanners produce false positives.

## Rules

- Report findings only — do not modify files.
- If a finding conflicts with an already-noted "possibly intentional" pattern, don't double-report it — reference the existing note.
