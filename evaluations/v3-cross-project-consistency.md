# SPDX-License-Identifier: PMPL-1.0-or-later
# Evaluation: v3 Cross-Project Consistency Test
# Date: 2026-03-23
# Projects: ambientops (infra), burble (platform), proven (research)

## Question

Does v3 methodology produce consistent results across different project
types, and does it correctly adapt its mode (convergent/divergent/hybrid)?

## Results

| Dimension | ambientops | burble | proven |
|-----------|-----------|--------|--------|
| **Type** | Infrastructure | Platform | Research |
| **Mode selected** | Convergent | Convergent | Divergent |
| **Mode correct?** | Yes | Yes | Yes |
| **Constraint found?** | Yes (envelope flow) | Yes (missing deps) | Yes (build unverified) |
| **Constraint type** | Wiring gap | Dependency gap | Pipeline gap |
| **Phase 0 worked?** | Yes (STATE valid) | Partial (STATE = template) | Partial (STATE empty) |
| **v3 quality score** | 8/10 | 7/10 | 8/10 |

## Key Findings

### 1. Constraint identification is consistent (3/3)

All three projects had a critical chain with a clear first-unresolved-link.
The constraint types varied (wiring, deps, pipeline) but the identification
method (build dependency graph → find longest chain → find first break)
worked identically across all three.

### 2. Mode selection is correct (3/3)

v3 correctly chose convergent for infrastructure/platform and divergent
for research. The signals were clear in all cases.

### 3. Phase 0 has a STATE file reliability problem (2/3 failures)

Only ambientops had a valid STATE.a2ml. Burble's was an uncustomised
template. Proven's was empty after SCM→A2ML migration. This means Phase 0
falls back to TODO.md/ROADMAP.adoc in most cases.

**New refinement needed:** Validate STATE before trusting it:
- Check for {{PLACEHOLDER}} tokens
- Check project name matches repo name
- Check last-updated within 90 days
- Fall back to TODO/ROADMAP if validation fails

### 4. Convergent gravity in divergent mode (proven-specific)

The coverage audit step naturally pulls attention toward empty components
(102 scaffolded bindings, 12 stub apps). In convergent mode this is
correct (fill gaps). In divergent mode this is wrong (deepening > breadth).
The 70/30 budget split mitigates but doesn't eliminate the pull.

**New refinement needed:** In divergent mode, the coverage audit should
ask "which components carry the unique strength?" not "which components
are empty?" Empty components are acceptable in divergent projects.

### 5. "Silent fallback" is a new constraint pattern (burble-specific)

Burble had fully-written QUIC and LMDB code that silently fell back to
WebSocket/ETS because the deps weren't in mix.exs. This is invisible to
code review — the code looks complete. Only the constraint analysis
(tracing the dependency graph to find what's actually wired) revealed it.

This pattern may exist in other projects: code that looks done but is
secretly using a fallback path because a dependency/config/flag is missing.

## Consistency Verdict

**v3 is consistent across project types.** The core mechanism (read state →
build dependency graph → find constraint → work it) produces the right
priorities in infrastructure, platform, and research contexts. The mode
selection (convergent vs divergent) correctly adapts.

The two weak points (STATE reliability, convergent gravity in divergent mode)
are addressable with refinements #25 and #26 to the methodology.

## What v3 Works Better For

| Situation | v3 Advantage |
|-----------|-------------|
| Infrastructure with hidden wiring gaps | Strong — constraint analysis finds silent failures |
| Platform with dependency issues | Strong — traces dep graph to find missing links |
| Research with deep proof needs | Good — divergent mode focuses on unique strength |
| Multi-component monorepos | Strong — coverage audit catches skipped MUSTs |
| Projects with valid STATE files | Ideal — Phase 0 works perfectly |

## What v3 Works Less Well For

| Situation | Issue |
|-----------|-------|
| Projects with broken/template STATE | Phase 0 starts with bad data |
| Divergent projects with many stubs | Coverage audit tempts convergent filling |
| Very small projects (1-3 files) | Overhead not justified |
| Exploratory/greenfield work | No state to read, no constraint to find |
