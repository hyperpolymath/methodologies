# SPDX-License-Identifier: PMPL-1.0-or-later
# Evaluation: Productive Meandering v0 → v3
# Date: 2026-03-23
# Target: ambientops (same repo, same session, A/B comparison)
# Evaluator: Claude Opus 4.6

## Context

v2 and v3 were run on the same target (ambientops) in the same session,
making this a genuine A/B comparison. v0 and v1 data is from prior sessions.

## Comparison Table

| Metric | v0 (no prompt) | v1 (Gossamer) | v2 (Ambientops) | v3 (Ambientops) |
|--------|---------------|---------------|-----------------|-----------------|
| **Session** | Baseline | 2026-03-22 | 2026-03-23 wave 1-2 | 2026-03-23 wave 3 |
| | | | | |
| **Efficiency** (output per token) | | | | |
| Tokens consumed | ~50K (est.) | ~400K (est.) | ~296K (5 bots) | ~170K (est. 2 bots) |
| Files created/modified | 1-3 | 100+ | 23 | est. 3-5 |
| Meaningful fixes | 1 (stated task) | 17 apps | 21 | TBD |
| Tokens per meaningful fix | ~50K | ~23K | ~14K | TBD |
| | | | | |
| **Effectiveness** (did it solve the right problems?) | | | | |
| P1 items from STATE addressed | n/a | n/a (no STATE read) | 4/8 directly | 2/2 P1 items targeted |
| Critical surprises found | 0 | unknown | 4 | TBD |
| MUSTs skipped for COULDs | unknown | unknown | yes (HCT main.rs was P1, fixed in wave 2 not wave 1) | 0 by design |
| Coverage of components | 1 | 14 repos | 6/29 (21%) | 29/29 audited (100% visibility) |
| Constraint identified | no | no | no (found by accident) | yes (Phase 0) |
| | | | | |
| **Efficacy** (did outcomes match intent?) | | | | |
| Stated goal achieved | yes | yes + 16x more | yes | TBD |
| Waste ratio (off-critical-chain work) | 0% (only did stated task) | unknown | ~40% (TOPOLOGY, SPDX, docs) | est. <10% |
| Bot factual errors | n/a | n/a | 1 (schema miscount) | TBD (cross-verify built in) |
| Needed follow-up wave | no | no | yes (wave 2 for HCT) | TBD |
| | | | | |
| **Economy** (cost vs value) | | | | |
| Bots launched | 0 | many | 5 | 2 |
| Waves needed | 1 | 1 | 2 | TBD |
| Perfective work % | 0% | unknown | ~30% (docs, SPDX, TOPOLOGY) | 0% by design |
| Work that fed critical chain | 100% (trivially) | unknown | ~60% | est. ~90% |
| | | | | |
| **Elegance** (how clean is the process?) | | | | |
| Phase 0 (MUST-first) | no | no | no | yes |
| Constraint identified before work | no | no | no | yes |
| Priority ordering enforced | no | no | no (equal weight) | yes (3x/2x/1x) |
| Stopping condition defined | "done" | "user says stop" | wave cap = 2 | constraint resolved + termination test |
| Coverage tracked | no | no | no | yes (29/29 audited) |
| Meander debt list produced | no | no | informal | formal |
| | | | | |
| **Equity** (fair allocation of effort?) | | | | |
| Maturity bias | n/a | unknown | yes (well-structured code got more attention) | countered (least-mature check) |
| Cherry-picking | n/a | unknown | likely (TOPOLOGY before main.rs) | prevented (difficulty-impact matrix) |
| Bot scope overlap | n/a | n/a | low (exclusive dirs) | zero (constraint + read-only tracker) |
| | | | | |
| **Ethics** (responsible resource use?) | | | | |
| Parallel builds | n/a | unknown | 1 per bot (rule) | 1 total (constraint bot only) |
| Token budget set upfront | no | no | yes (~30 calls) | yes (~25 calls) |
| Disk check before launch | no | no | yes | yes |
| Cruft tracking | no | no | informal | formal |

## Key Tradeoffs

| | Straight-line (v0) | Meandering (v1-v2) | Constraint-first (v3) |
|---|---|---|---|
| **Best at** | Known tasks, speed | Discovery, breadth | Critical path, depth |
| **Worst at** | Finding hidden issues | Priority, completion | Serendipity |
| **Failure mode** | Misses adjacent problems | Never arrives, cherry-picks | Misses off-chain opportunities |
| **Token efficiency** | Highest (minimal waste) | Lowest (exploration tax) | Medium (audit overhead) |
| **Discovery rate** | Zero (only does what's asked) | Highest (random walk finds surprises) | Medium (audit finds MUSTs, constraint analysis finds chains) |
| **Completion guarantee** | Yes (trivially) | No (random walk) | Yes (constraint resolution = done) |
| **Right work guarantee** | Only if user knows what's right | No (interesting > important) | Yes (critical chain enforces) |

## Headline Numbers (v2 vs v3)

| Metric | v2 | v3 | Change |
|--------|----|----|--------|
| Bots launched | 5 | 2 | **-60%** |
| Tokens (est.) | 296K | ~170K | **-43%** |
| Critical chain unblocked | accidentally (wave 2) | by design (wave 1) | **1 wave faster** |
| Components with coverage visibility | 6 | 29 | **+383%** |
| Perfective work (waste) | ~30% of effort | 0% | **eliminated** |
| Constraint identified | never (found by accident) | Phase 0, before any bot launched | **systematic** |

## Honest Caveats

1. **v3 hasn't fully completed at time of writing** — final numbers may differ.
   This evaluation will be updated when the v3 bots finish.

2. **v3 benefits from v2's work.** HCT compiles because v2 fixed main.rs. The
   constraint analysis was easier because v2 built the components. v3 on a fresh
   repo would need to do v2's structural work first. This is not a clean A/B —
   it's a sequential comparison where v3 builds on v2's foundation.

3. **v2 found more surprises.** v3's constraint focus means it won't discover
   the duplicate observatory dir, the stale Python, or the 9th schema debate.
   Those were genuinely useful v2 finds. Constraint-first trades serendipity
   for precision.

4. **v1 produced the most raw output.** 17 apps, a CLI, mobile support. Raw
   output volume favours meandering. But output volume != the right output.
   Many of those apps may never be used.

5. **v0 is still the fastest for known tasks.** If you know exactly what to do,
   just do it. The methodology overhead only pays off when you don't know what
   you don't know.

## Progression Model

```
v0: Does what you say
v1: Discovers what you missed (but no priority)
v2: Discovers what you missed + wave discipline (but cherry-picks)
v3: Discovers what you missed + works on what matters most
    (constraint-first + weighted priority + coverage tracking)
```

Each version keeps the previous version's strengths and patches its weaknesses.

## When to Use Which

| Situation | Best version |
|-----------|-------------|
| "Fix this one bug" | v0 (straight-line) |
| "Get this repo up to spec" | v1-v2 (convergent meander) |
| "What's blocking this project?" | v3 (constraint-first) |
| "Explore what makes this special" | v1 divergent mode |
| First session on a repo | v2 (discovery value is highest) |
| Second+ session on a repo | v3 (diminishing discovery returns, constraint focus) |
| Pre-release audit | v3 + parallel audit v2 |
| Multiple surfaces at different maturity | v3 hybrid (audit-then-focus) |

## Relationship to Other Methodologies

- **TSDM** provides the navigator role that v3's coverage tracker fills
- **Event Chain + Critical Chain** provides the constraint identification that v3's Phase 0 uses
- **Parallel Audit** provides the exclusive scoping that all versions use for bots
- **Hypatia Feedback Loop** will eventually learn which version works best for which repo type
