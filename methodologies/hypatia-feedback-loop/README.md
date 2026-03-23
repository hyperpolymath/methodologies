# SPDX-License-Identifier: PMPL-1.0-or-later
# Hypatia Feedback Loop — Automated Methodology Learning

## Overview

Hypatia is the neurosymbolic CI/CD intelligence layer for the hyperpolymath
ecosystem. Its built-in learning agent forms a closed feedback loop that
learns from every fix, every failure, and every constraint resolution across
the entire 500+ repo fleet.

## The Loop (4 stages)

```
1. SCAN         panic-attack assail → JSONL outcomes
     ↓
2. DISPATCH     PatternAnalyzer → TriangleRouter → FleetDispatcher
                (confidence-gated: ≥0.95 auto, 0.85-0.94 PR, <0.85 advisory)
     ↓
3. RECORD       OutcomeTracker → Beta-distribution confidence updating
                (prior strength 10, floor 0.10, cap 0.99)
     ↓
4. LEARN        LearningScheduler polls every 5 minutes
                Rules.Learning promotes patterns (≥5 occurrences, ≥75% success,
                <30% false-positive → permanent rule)
     ↓
  → back to 1 (closed loop)
```

## Key Components

| Module | Path | Role |
|--------|------|------|
| `LearningScheduler` | `hypatia/lib/learning_scheduler.ex` | Polls new outcomes, updates recipe confidence, reports drift |
| `Rules.Learning` | `hypatia/lib/rules/learning.ex` | Per-issue-type tracking, recency-weighted confidence, false-positive decay |
| `OutcomeTracker` | `hypatia/lib/outcome_tracker.ex` | Bayesian confidence updates from fix results |
| `Neural Coordinator` | `hypatia/lib/neural/coordinator.ex` | 5 neural networks: Graph of Trust, Mixture of Experts, Liquid State Machine, Echo State Network, Radial Neural Network |

## Connection to Methodology Repo

This is where methodology learning becomes **automated**:

### What Hypatia Can Learn From Methodologies

1. **Constraint resolution outcomes** — when Event Chain + Critical Chain
   identifies a constraint and an agent resolves it, Hypatia records:
   - Was the constraint correctly identified? (precision)
   - Did resolving it unblock the chain? (effectiveness)
   - How many tokens were spent? (efficiency)

2. **Meander surprise rates** — Hypatia can track the Surprise Test across
   sessions:
   - Ring 0 only: N fixes (baseline)
   - Ring 1+: M additional fixes (meander value)
   - Critical surprises: K (production failures prevented)
   - Over time: is the meander finding fewer surprises? (diminishing returns)

3. **Cherry-picking detection** — Hypatia's pattern analyzer can flag when
   agents consistently choose Easy+Low work over Hard+High:
   - Recipe: "agent chose COULD over MUST"
   - Confidence: how often does this lead to unresolved MUSTs at session end?
   - Promotion: if pattern is reliable, auto-flag in TSDM navigator

4. **Methodology selection** — which methodology works best for which type
   of project?
   - Convergent meander: best for infrastructure repos (Hypatia can learn this)
   - Divergent meander: best for creative repos
   - TSDM: best for pre-release audits
   - Hybrid: best for most sessions (but is this always true?)

### Proposed JSONL Schema for Methodology Outcomes

```jsonl
{"session": "2026-03-23", "repo": "ambientops", "methodology": "productive-meandering-v3",
 "mode": "convergent", "waves": 2, "bots": 5, "tokens": 296000,
 "ring0_fixes": 8, "ring1plus_fixes": 13, "critical_surprises": 4,
 "bot_errors": 1, "constraint_resolved": true, "constraint_type": "compilation_failure",
 "waste_ratio": 0.12, "coverage": 0.30}

{"session": "2026-03-23", "repo": "stapeln", "methodology": "hybrid-tsdm-meander",
 "mode": "hybrid", "waves": 2, "bots": 3, "tokens": 180000,
 "tsdm_queue_items": 18, "tsdm_musts_found_by_meander": 0,
 "tsdm_musts_in_project_docs": 5, "musts_completed": 3,
 "constraint_resolved": true, "constraint_type": "missing_features"}
```

### The Feedback Goal

Over time, Hypatia should be able to answer:
- "Given this repo type, which methodology maximises fixes per token?"
- "Given this constraint type, which agent role resolves it fastest?"
- "Is the meander still finding critical surprises, or should we switch
  to TSDM?"
- "Which agents cherry-pick most? What prompt changes reduce it?"

This turns methodology selection from human intuition into data-driven
decision-making — while keeping human override for creative/novel situations.

## Current Status

- Hypatia learning loop: **Built** (Elixir GenServers, neural coordinator)
- Scanner binary: **Gap** (hypatia-cli.sh / hypatia-v2 escript may not be runnable)
- Methodology outcome JSONL: **Proposed** (schema above, not yet implemented)
- Cross-methodology learning: **Not started** (needs the JSONL pipeline)

## Next Steps

1. Verify Hypatia scanner binary exists and runs
2. Implement methodology outcome JSONL writer (in LearningScheduler)
3. Add constraint resolution tags to OutcomeTracker
4. Train neural coordinator on methodology outcome data
5. Build PanLL panel for methodology effectiveness dashboard
