# SPDX-License-Identifier: PMPL-1.0-or-later
# Field Report: TSDM + Meander Hybrid Validation (Stapeln)
# Date: 2026-03-23
# Methodology: Hybrid TSDM-Meander (first full cycle)

## Result: VALIDATED

The hybrid approach — TSDM navigator producing priorities, meander
executing them — gave both systematic coverage AND discovery.

## What Happened

### Pass 1 (TSDM agent)
- Read 9 project documents
- Produced 18-item prioritised queue
- **Critical finding:** Both previous meander sessions had ZERO overlap
  with the project's own documented MUSTs. The meander never read
  STATUS.md or ROADMAP.adoc.

### Pass 2 (Meander on TSDM top-3)
- Implemented MUSTs 3, 4, 5 (undo/redo, auto-save, dark mode)
- Meander naturally caught:
  - Dark mode needing HTML class sync for Tailwind
  - alignSelf not in Sx.make
  - Auto-save needing a MarkClean dispatch path
- These are things a linear implementation might have missed

## Three Commits

| Commit | Lines | What |
|--------|-------|------|
| 712c945 (session 1) | +6,124 / -252 | Pipeline wiring, build fixes, Tailwind |
| 3340e79 (session 2a) | +147 / -358 | Real canvas, URL routing, import fix |
| 43ff8e8 (session 2b) | +743 / -140 | Undo/redo, auto-save, dark mode (TSDM MUSTs) |

## Key Insight

> The TSDM agent found what the project needs.
> The meander found what the code needs.
> Together they covered both.

Without TSDM: meander polishes infrastructure but misses documented MUSTs.
Without meander: TSDM implements features but misses code-level surprises.
Together: documented priorities + code-level discovery = complete coverage.

## Remaining TSDM Queue

1. MUST-1: Wire SecurityInspector + GapAnalysis to live validation API
2. MUST-2: Build AttackSurfaceAnalyzer.res (entire new panel)
3. MUST-6: Conversational errors with [Fix It] buttons
4. SHOULD-7: Simulation dry-run summary
5. SHOULD-11: Update TOPOLOGY.md and STATUS.md
