---
name: secrets-scan
description: Scan a diff or file tree for committed secrets, tokens, and credentials before reporting it clean. Use as part of a security review or before staging files for commit.
---

# Secrets Scan

## Workflow

1. Check gitleaks is available: `command -v gitleaks`. If missing, tell the user to run `mise use -g gitleaks` — do not assume a system install.
2. For a working tree: `gitleaks detect --source <path> --no-git`. For staged changes: `gitleaks protect --staged`.
3. Cross-check each finding against context — test fixtures, example values — rather than silently dropping it. Note ambiguous ones as "possibly intentional — verify", matching the security-reviewer's convention for false positives.
4. Report `file:line` and the secret type/rule matched. Never print the actual secret value in output.

## Rules

- Report findings only — this skill does not remove secrets or rewrite history.
- If a real secret is found, flag it as CRITICAL and recommend rotation, not just removal from the file.
