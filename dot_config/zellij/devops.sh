#!/usr/bin/env bash

set -euo pipefail

SESSION="${1:-devops}"
CWD="${2:-$PWD}"

cd "$CWD"
exec zellij attach --create --force-run-commands "$SESSION" options --default-layout devops
