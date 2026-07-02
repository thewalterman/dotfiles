---
name: k8s-dry-run
description: Validate Kubernetes manifests or Helm charts with a server-side dry run before considering the change complete. Use after writing or editing any Kubernetes YAML or Helm template.
---

# Kubernetes Dry Run

## Workflow

1. Determine what changed: raw manifest(s) or a Helm chart/template.
2. For a Helm chart: `helm template <chart> [-f values.yaml] | kubectl apply --dry-run=server -f -`.
3. For raw manifests: `kubectl apply --dry-run=server -f <file-or-dir>`.
4. Server-side dry run requires a reachable cluster via `$KUBECONFIG`. If none is configured or reachable, fall back to `--dry-run=client` and explicitly say server-side (schema/admission) validation was skipped.
5. Report any schema errors, missing CRDs, or admission webhook rejections. Fix the manifest and re-run.

## Rules

- Never drop `--dry-run` and apply for real from this skill.
- Never switch kube-context — use whatever `$KUBECONFIG` / current context is already set.
