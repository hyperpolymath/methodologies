# SPDX-License-Identifier: PMPL-1.0-or-later
# Multi-Agent Coordination Patterns

## Status: Design Phase (v0)

## Problem

When running 2+ Claude instances (or mixed LLMs) simultaneously, they:
- Step on each other's work (editing same files, pushing conflicting changes)
- Don't know what the other completed (ask user to do already-done tasks)
- Can't coordinate push/merge/mirror sequences across repos
- Duplicate effort on shared task lists

## Core Capabilities Needed

1. **Workspace locking** — "I'm working on repo X, don't touch it"
2. **Task list sharing** — shared completion state (if A finishes task 5, B skips it)
3. **Completion monitoring** — watch another instance's progress, auto-advance
4. **Conflict prevention** — file-level or repo-level advisory locks
5. **Cross-instance messaging** — "I changed the API in X, update your imports"
6. **Dogfooding awareness** — when work in one area affects another area being
   worked on by another instance

## Implementation Options

| Approach | Complexity | Reliability | Cross-LLM |
|----------|-----------|-------------|-----------|
| Shared lockfile dir (`~/.claude/coordination/`) | Low | Medium | Yes |
| VeriSimDB instance (task graphs, conflict detection) | Medium | High | Yes |
| File-based message queue | Low | Low | Yes |
| BoJ cartridge | Medium | High | Claude-only |

## Practical Patterns (validated)

### Sequential Alternating Passes
Best for single-repo work with multiple concerns (e.g., TSDM + Meander):
```
Pass 1: Agent A reads state → produces priority queue
Pass 2: Agent B works top items, reports discoveries
Pass 3: Agent A re-evaluates, adjusts queue
Pass 4: Agent B works next items
```
Avoids file contention entirely. TSDM passes are cheap (~10K tokens),
meander passes are expensive (~50-100K tokens).

### Parallel with Exclusive Scoping
Best for multi-repo or multi-directory work:
```
Agent 1: OWNS emergency-room/, hardware-crash-team/
Agent 2: OWNS observatory/, records/
Agent 3: OWNS .github/, contracts/, Justfile
```
No file contention if scopes don't overlap. Build mutex still applies
(only one compiler at a time).

### The Build Mutex Problem
Only one compiler can run at a time per workspace:
- `rescript build` locks the whole project
- `cargo build` locks the workspace
- `mix compile` locks the project

Solution: Stagger builds. Agent A builds, reports, then Agent B builds.
Or give each agent a separate workspace (git worktrees).

## Observed Failure Modes

- Deprecation bot edited PipelineDesigner.res while main agent was
  modifying the same file → build break
- Two agents both running `cargo check` → OOM on 32GB machine
- Agent A pushed a commit, Agent B's working tree was now behind → merge conflict
