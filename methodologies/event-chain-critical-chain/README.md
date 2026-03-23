# SPDX-License-Identifier: PMPL-1.0-or-later
# Event Chain Methodology + Critical Chain for AI Agent Work

## Overview

Event Chain Methodology (ECM) combined with Critical Chain Project Management
(CCPM, from Goldratt's Theory of Constraints). Applied to AI-assisted software
development, this focuses agent work on **the actual constraint** — the
bottleneck that limits throughput — rather than whatever happens to be
interesting or easy.

## Why This Matters for AI Agents

Every methodology we've built (Productive Meandering, TSDM, Parallel Audit)
shares one failure mode: **agents work on non-constraints**. They polish
docs while compilation is broken. They write examples while parsers panic.
They design architectures while the foundation is unverified.

The Theory of Constraints says:
1. **Identify** the constraint (what limits the system's throughput?)
2. **Exploit** the constraint (maximise its output with current resources)
3. **Subordinate** everything else to the constraint (non-constraint work
   that doesn't feed the constraint is waste)
4. **Elevate** the constraint (invest to remove it)
5. **Repeat** — the constraint has moved, find the new one

## Event Chains in AI Development

An **event** is anything that affects a task's duration, cost, or outcome.
Events chain — one triggers another:

```
Event: "HCT main.rs is a broken skeleton"
  → Chain: Can't compile HCT
    → Chain: Can't run SARIF tests
      → Chain: Can't verify HCT010/HCT011 rules
        → Chain: Can't ship new NVMe monitoring
          → Chain: Can't detect CC-003 boot loops
            → CONSTRAINT: System stability at risk
```

The event chain reveals that fixing main.rs isn't just "a cleanup task" —
it's the **constraint** that blocks the entire NVMe monitoring pipeline.
Without event chain analysis, an agent might classify it as a SHOULD and
work on TOPOLOGY.md instead.

## The Constraint-First Agent Protocol

### For Single Agents

Before starting work, identify the critical chain:

```
1. Read STATE file → list all tasks
2. Build dependency graph (what blocks what?)
3. Find the LONGEST CHAIN of dependencies → this is the critical chain
4. Find the FIRST UNRESOLVED LINK in that chain → this is the constraint
5. Work on the constraint FIRST
6. After resolving: re-evaluate (the constraint has moved)
```

### For Multi-Agent Systems

The three-agent architecture (ADR-001) maps naturally:

| Agent | ToC Role | Responsibility |
|-------|----------|----------------|
| **TSDM** | Identify + Monitor | Builds the dependency graph. Identifies the critical chain. Spots when the constraint moves. |
| **Converge** | Exploit + Subordinate | Works the constraint directly. Everything it does must feed the critical chain. Non-constraint work is deferred. |
| **Diverge** | Elevate | Finds creative solutions to remove the constraint entirely. Novel approaches, architectural shortcuts, tool-building that eliminates whole classes of constraints. |

### Subordination Rule (CRITICAL)

**Everything subordinates to the constraint.** This means:

- If the constraint is "HCT doesn't compile", then ALL agent work must
  either (a) fix HCT compilation, or (b) prepare work that's blocked
  by HCT compilation so it's ready when the constraint clears.
- Work that doesn't feed the constraint is **not just low priority —
  it's waste.** Updating TOPOLOGY.md while HCT can't compile is waste.
  Writing new Elixir modules that depend on HCT output is waste.
- **Exception:** If non-constraint work is completely independent (doesn't
  feed into or depend on the critical chain), it can proceed in parallel
  at lower priority. But verify independence — most things connect.

### Buffer Management

Critical Chain uses **buffers** to absorb uncertainty:

- **Project buffer:** Time/budget reserved at the end of the critical chain.
  For AI agents: reserve 20% of token budget for constraint resolution.
- **Feeding buffers:** Time/budget at merge points where non-critical work
  joins the critical chain. For AI agents: when a parallel bot's output
  feeds into the critical chain, ensure it completes before the constraint
  resolution needs it.
- **Resource buffer:** Signal to have the right resource ready. For AI agents:
  don't launch a Rust bot if the constraint is an Elixir compilation issue.

## Event Chain Analysis for Meander Bots

When a meander bot discovers an issue, it should classify it:

```
1. Is this ON the critical chain?
   YES → This is or feeds the constraint. Fix immediately.
   NO  → Continue to question 2.

2. Does fixing this CREATE a new path that's LONGER than the current
   critical chain?
   YES → This changes the constraint. Report to TSDM for re-evaluation.
   NO  → Continue to question 3.

3. Is this completely independent of the critical chain?
   YES → Add to meander debt list. Fix if budget allows.
   NO  → It feeds the critical chain indirectly. Fix if on the
         feeding path, defer if not.
```

## Integration with Hypatia Learning Loop

The constraint identification feeds directly into Hypatia's feedback loop:

```
Constraint identified → panic-attack scans affected repos
  → PatternAnalyzer classifies the constraint type
    → OutcomeTracker records whether constraint resolution succeeded
      → LearningScheduler updates confidence for that constraint class
        → Next time this constraint type appears, Hypatia knows:
          - How hard it typically is to resolve
          - Which bot/recipe works best
          - Whether it's really a constraint or a red herring
```

**Key connection:** Hypatia's `Rules.Learning` module tracks fix outcomes
per issue type. If we tag constraint resolutions distinctly from non-constraint
fixes, Hypatia can learn which types of constraints the agents handle well
and which need human intervention. This is the feedback loop the user wants.

### Proposed Hypatia Tags

```jsonl
{"type": "constraint_resolution", "chain_depth": 6, "resolved": true, "method": "direct_fix"}
{"type": "constraint_resolution", "chain_depth": 3, "resolved": true, "method": "elevation"}
{"type": "non_constraint_fix", "on_feeding_path": true, "resolved": true}
{"type": "waste_detected", "reason": "worked_off_critical_chain", "tokens_spent": 15000}
```

Over time, Hypatia learns:
- Average chain depth of real constraints (short chains = easy, long = hard)
- Success rate per resolution method (direct fix vs elevation vs creative)
- Waste ratio (% of tokens spent off critical chain — lower is better)
- Which constraint types recur (chronic conditions vs one-offs)

## Integration with Productive Meandering v3

Event Chain + Critical Chain strengthens several v3 mechanisms:

| v3 Mechanism | ECM/CCPM Enhancement |
|-------------|----------------------|
| Weighted priority (MUST 3x) | Constraints are always MUSTs. Non-constraint MUSTs subordinate to constraint MUSTs. |
| Cherry-picking counter | "Am I working on the constraint?" replaces "Am I avoiding hard work?" — more precise. |
| Difficulty-impact matrix | Impact = "on critical chain?" Hard+High = constraint. Easy+High = feeding the constraint. |
| TSDM navigator | TSDM agent builds the dependency graph and identifies the critical chain explicitly. |
| Self-termination | "Constraint resolved, no new constraint found" is a clean stopping condition. |
| Hybrid audit-then-focus | Audit phase identifies the critical chain. Focus phase works the constraint. |

## Example: Ambientops Meander (Re-Evaluated)

What actually happened (v2):
- Wave 1: Built 4 components + 2 SARIF rules + infra sweep (parallel, no priority)
- Wave 2: Fixed HCT main.rs + cleanup

What should have happened (v3 + ECM/CCPM):

```
Critical chain analysis:
  CC-003 (boot loops) → boot-guardian → HCT010 SARIF rule → HCT compiles
  ← CONSTRAINT: HCT doesn't compile (broken main.rs)

Wave 1 (constraint-first):
  Bot 1: Fix HCT main.rs (THE CONSTRAINT) + HCT010/HCT011
  Bot 2: Build boot-guardian (feeds constraint output)
  Bot 3: Build nvme-sentinel (independent — can proceed in parallel)

Wave 1 result: Critical chain UNBLOCKED. HCT compiles. Boot-guardian
can consume SARIF output. NVMe sentinel ready independently.

Wave 2 (new constraint):
  Re-evaluate: what's the constraint NOW?
  → shutdown-marshal + service-autopsy + wiring
  → Constraint: no cross-component Evidence Envelope flow
  Work the new constraint.
```

The constraint-first approach would have:
- Unblocked HCT compilation in Wave 1 (not Wave 2)
- Built boot-guardian against a compilable HCT (verified, not assumed)
- Produced fewer total files but a more coherent, tested system

## References

- Goldratt, E.M. (1997). *Critical Chain*. North River Press.
- Virine, L. & Trumper, M. (2013). *ProjectThink*. Gower.
- Event Chain Methodology: https://en.wikipedia.org/wiki/Event_chain_methodology
- Theory of Constraints: https://en.wikipedia.org/wiki/Theory_of_constraints
