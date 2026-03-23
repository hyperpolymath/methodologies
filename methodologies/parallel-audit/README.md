# SPDX-License-Identifier: PMPL-1.0-or-later
# Parallel Audit Methodology v2

## Overview

Send multiple agents to audit the same repo from different angles with
exclusive scoping. Each agent goes deep in their domain (~200 files total
vs ~80 for a single pass). Triple-confirmation on critical findings.

## When to Use

- Pre-milestone comprehensive audit (NLnet submission, awesome-list PR, Show HN)
- Any time a repo needs thorough review before external visibility
- Large repos where a single agent can't cover everything in one pass

## Prompt Template (v2)

1. **Exclusive scoping** — "You OWN: [dirs]. You SKIP: [dirs]."
   Eliminates overlap completely.
2. **Standardized output format** — Force:
   `[SEVERITY] file:line — description / Evidence / Impact / Fix`
3. **Severity definitions** — Define MUST/SHOULD/COULD/STALE precisely
   upfront (not left to agent interpretation).
4. **"Read files FRESH" instruction** — Important when the repo was
   modified in-session.
5. **Concrete task lists** — "Count exact unwrap() calls with line
   numbers" beats "check for issues".
6. **Include negative checks** — "Are there files NOT included in any
   Cargo.toml?" catches orphans.

## What v3 Should Add

- **Execution testing** — one agent should actually RUN `just build`,
  `just test`, not just verify files exist
- **Temporal marking** — distinguish "this was like this before our
  session" vs "we introduced this"
- **Confidence levels** — "HIGH: read the file" vs "MEDIUM: inferred
  from name" vs "LOW: couldn't find"
- **Cross-agent summary format** — agents end with a machine-parseable
  findings list for automatic reconciliation

## What Parallel Audits Catch Well

- License inconsistencies (found by all 3 from different angles — high confidence)
- Stale metadata (TOPOLOGY.md, STATE.a2ml, arXiv papers vs actual proof status)
- Orphan files (not in module tree)
- Template variable leaks (`{{OWNER}}` in workflow)
- Count accuracy (78 unwraps, not "~35")

## Validated

Tested 2026-03-22 on typed-wasm. Three agents covered ~200 files total
with zero overlap. Triple-confirmation on license inconsistencies gave
high confidence in findings.
