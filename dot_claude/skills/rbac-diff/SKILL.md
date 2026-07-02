---
name: rbac-diff
description: Compare Kubernetes RBAC (Role/ClusterRole/RoleBinding/ClusterRoleBinding) before and after a change to catch permission escalation. Use during security review of manifests or Helm charts that touch RBAC.
---

# RBAC Diff

## Workflow

1. Get the current live RBAC objects, scoped to the relevant namespace/name if known: `kubectl get role,clusterrole,rolebinding,clusterrolebinding -o yaml`.
2. Render the proposed state: `helm template <chart>` for a chart, or read the edited manifests directly.
3. Diff the two, focused on `rules[].verbs`, `resources`, `apiGroups`, and binding `subjects`.
4. Flag: any new wildcard (`*`) grant, any verb/resource addition not explained by the stated task, and any `ClusterRole`/`ClusterRoleBinding` used where a namespaced `Role`/`RoleBinding` would suffice.
5. Report findings in the Security Reviewer's `[SEVERITY]` format.

## Rules

- Report only — do not modify the RBAC objects.
- If no live cluster is reachable, diff against the previous version of the manifest in git history instead and say so.
