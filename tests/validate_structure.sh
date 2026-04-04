#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# validate_structure.sh — CRG C structural tests for methodologies
#
# Validates the methodologies documentation repository structure.
#
# Usage: bash tests/validate_structure.sh [repo-root]

set -euo pipefail

ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
PASS=0; FAIL=0

check() {
    local desc="$1"; local path="$2"
    if [ -e "$ROOT/$path" ]; then
        echo "  PASS: $desc"
        ((PASS++)) || true
    else
        echo "  FAIL: $desc — missing $path"
        ((FAIL++)) || true
    fi
}

echo "=== methodologies structure validation ==="
echo ""

check "README.adoc"                 "README.adoc"
check "EXPLAINME.adoc"              "EXPLAINME.adoc"
check "0-AI-MANIFEST.a2ml"         "0-AI-MANIFEST.a2ml"
check "methodologies/ directory"   "methodologies"
check "decisions/ directory"       "decisions"
check "CHANGELOG.md"               "CHANGELOG.md"

# methodologies/ should have at least one doc
if [ -d "$ROOT/methodologies" ]; then
    count=$(find "$ROOT/methodologies" -type f | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "  PASS: methodologies/ has $count file(s)"
        ((PASS++)) || true
    else
        echo "  FAIL: methodologies/ is empty"
        ((FAIL++)) || true
    fi
fi

# decisions/ should have at least one ADR
if [ -d "$ROOT/decisions" ]; then
    adr_count=$(find "$ROOT/decisions" -type f | wc -l)
    if [ "$adr_count" -gt 0 ]; then
        echo "  PASS: decisions/ has $adr_count ADR(s)"
        ((PASS++)) || true
    else
        echo "  WARN: decisions/ is empty — add ADRs"
    fi
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
