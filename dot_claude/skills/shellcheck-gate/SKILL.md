---
name: shellcheck-gate
description: Run shellcheck on any bash script that was written or edited. Use before handing back a bash script as done.
---

# Shellcheck Gate

## Workflow

1. Identify changed shell scripts: `git diff --name-only -- '*.sh'` (or the specific file just written/edited).
2. Check shellcheck is available: `command -v shellcheck`. If missing, tell the user to run `mise use -g shellcheck` — do not assume a system install.
3. Run `shellcheck -x <file>` on each script.
4. Fix findings that align with this repo's bash conventions (`set -euo pipefail`, `IFS=$'\n\t'` on loops, `[[ ]]`, quoted variables). Re-run until clean.
5. If a finding is a deliberate deviation (e.g. an intentionally unquoted glob), leave it and note why in one line — do not suppress with `# shellcheck disable` unless asked.

## Rules

- Do not rewrite scripts beyond what shellcheck flags — no unrelated cleanup.
- Report any findings you did not fix, with the reason.
