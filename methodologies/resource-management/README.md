# SPDX-License-Identifier: PMPL-1.0-or-later
# Resource Management for AI-Assisted Development

## Overview

AI agents create real resource costs that compound quickly during
exploratory or parallel work. These guardrails were learned from
production incidents — OOM crashes, disk exhaustion, and token waste.

## System Constraints (hyperpolymath workstation)

| Resource | Limit | Notes |
|----------|-------|-------|
| RAM | 32GB total | 25GB available typically |
| Disk (Eclipse) | 477GB, ~200GB free | All repos here |
| Disk (Fedora) | 232GB, limited free | OS only |
| Parallel agents | 3 max | Prevent crashes |
| Parallel Bash | 2 max | Prevent I/O saturation |

## Cost Profiles

### Rust Builds
- `cargo build` spikes 2-3GB RAM per invocation
- `target/debug/` grows to 1-6GB per crate
- Three parallel Rust builds WILL OOM on 32GB
- **Rule:** Build once, reuse. Never build same crate from 2 agents.

### Elixir Builds
- `mix compile` is lighter (~500MB RAM)
- `_build/` grows to ~200MB per project
- Can run 2 parallel mix compiles safely

### Token Budgets
- Each exploration agent: 50-100K tokens
- Three parallel agents: 150-300K tokens per wave
- TSDM pass (read-only): ~10K tokens
- **Rule:** Set scope: "~30 tool calls then report"

### Disk Artifacts
- Rust `target/`: 1-6GB per workspace
- Zig `zig-out/` + `zig-cache/`: 100MB-1GB
- Elixir `_build/` + `deps/`: 200-500MB per project
- **Rule:** At end of session, report sizes, offer cleanup

## Pre-Flight Checklist

Before launching parallel agents:
```bash
df -h /var/mnt/eclipse    # Check disk (need > 10GB free)
free -h                    # Check RAM (need > 10GB available)
```

## Incident Log

| Date | Incident | Cause | Fix |
|------|----------|-------|-----|
| 2026-03-22 | Eclexia bot consumed 6.3GB disk | `cargo build` ran 23 times | "Build once" rule |
| 2026-03-22 | OOM crash during parallel audit | 3 agents × `cargo check` | Stagger builds |
| 2026-03-20 | System hang during heavy session | Full context + large tool results | Resource awareness caps |

## Rules Summary

1. Check `df -h` and `free -h` before spawning builder agents
2. Tell agents "build once, reuse the binary" explicitly
3. Set scope limits: "explore for ~30 tool calls then report"
4. After session: `cargo clean`, `rm -rf zig-out/` for Zig
5. If crash appears, check if OOM before assuming logic bug
6. Never 2+ agents building same Rust workspace simultaneously
7. Stagger builds across agents (each spikes 2-3GB RAM)
8. Use `model: "haiku"` for simple search/read subagents
9. Never glob/grep the full `/var/mnt/eclipse/repos/`
10. Use `limit` on Read for files > 500 lines
