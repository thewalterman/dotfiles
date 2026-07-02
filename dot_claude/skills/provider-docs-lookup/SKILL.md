---
name: provider-docs-lookup
description: Fetch current documentation for a Terraform provider resource, Kubernetes API object, or Helm chart values schema. Use whenever unsure about exact argument names, defaults, or version-specific behavior instead of relying on training data.
---

# Provider / API Docs Lookup

## Workflow

1. Identify the exact target and the version pinned in this repo (provider version in `required_providers`, `apiVersion` in the manifest, chart version in `Chart.yaml`/`Chart.lock`).
2. Terraform: WebFetch `https://registry.terraform.io/providers/<namespace>/<provider>/<version>/docs/resources/<resource>`.
3. Kubernetes: WebFetch the Kubernetes API reference for the pinned version (`https://kubernetes.io/docs/reference/generated/kubernetes-api/<version>/`) for the specific kind.
4. Helm: fetch the chart's `values.yaml` / README from its source repo at the pinned chart version — not `latest`.
5. Summarize only the fields relevant to the current task. Cite the exact URL and version fetched so the answer is traceable.

## Rules

- Never answer from memory when a pinned version is available to check — provider/API behavior changes across versions.
- If the installed/pinned version can't be determined, ask rather than assuming `latest`.
