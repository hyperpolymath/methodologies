# SPDX-License-Identifier: PMPL-1.0-or-later
# ADR-001: Three-Agent Architecture (Diverge / Converge / TSDM)
# Status: Proposed
# Date: 2026-03-23

## Context

Current approaches use either:
- Pure meandering (1 agent, random walk)
- Parallel meandering (3 agents, same mode, exclusive scopes)
- Sequential alternating (TSDM reads → meander builds → TSDM re-evaluates)

User proposed: could three bots with *different approaches* intercommunicate
and produce better results?

## Proposal

Three specialised agents running in parallel with intercommunication:

### Agent Roles

| Agent | Mode | Responsibility | Communication |
|-------|------|----------------|---------------|
| **Diverge** | Divergent meandering | Find what's unique/strongest, push it further. Identify novel patterns, creative connections, research avenues | Sends insights to TSDM for triage |
| **Converge** | Convergent meandering | Find gaps, fill them. Build infrastructure, fix broken things. Standard completeness | Sends found issues to TSDM for priority |
| **TSDM** | Systematic audit | Read state, maintain priority queue, track coverage, prevent cherry-picking, enforce MUSTs | Sends prioritised tasks to both agents |

### Communication Protocol

```
TSDM reads STATE → produces initial priority queue
  ↓ (queue items tagged: divergent / convergent / either)
Diverge takes divergent items     Converge takes convergent items
  ↓                                ↓
Diverge reports insights          Converge reports found issues
  ↓                                ↓
  → Both report to TSDM →
TSDM re-evaluates, adjusts queue, checks coverage
  ↓
Next round...
```

### What Each Agent Optimises For

- **Diverge:** "What makes this project special? Push that."
  - Won't fill gaps unless they're in the project's core strength
  - Won't standardise unless it amplifies uniqueness
  - Will notice when convergent work is erasing what's distinctive

- **Converge:** "What's missing? What's broken? Fix that."
  - Won't add new features unless they complete existing ones
  - Won't explore unless exploration serves completeness
  - Will notice when incomplete infrastructure blocks other work

- **TSDM:** "What's the current state? What MUSTs remain? Who's cherry-picking?"
  - Doesn't write code — writes the priority queue
  - Tracks coverage: which components have been visited?
  - Detects cherry-picking: "Converge has been in Ring 1 for 20 calls"
  - Detects scope creep: "Diverge is designing Ring 5 without Ring 2 passing"
  - Enforces the weighted priority system

### Advantages Over Current Approaches

1. **Natural tension prevents bias.** Diverge wants to amplify uniqueness;
   Converge wants to standardise. TSDM mediates. Neither bias dominates.

2. **TSDM prevents cherry-picking in real-time.** Current approach catches
   it post-hoc (in the session-end report). With TSDM as live navigator,
   it catches it mid-session and redirects.

3. **Better task allocation.** Some work IS convergent (fix CI, update docs).
   Some IS divergent (deepen type theory, explore novel architecture).
   Instead of one agent context-switching between modes, each agent stays
   in its natural mode.

4. **Coverage guarantee + discovery.** TSDM ensures all MUSTs are visited.
   Converge fills gaps systematically. Diverge finds surprises. Together
   they cover what any single approach misses.

### Risks and Mitigations

| Risk | Severity | Mitigation |
|------|----------|------------|
| File contention (3 agents editing) | High | TSDM assigns exclusive file scopes, not just dir scopes |
| Build mutex (only 1 compiler) | High | TSDM sequences build verification: Converge builds first, then Diverge |
| Token cost (3x budget) | Medium | TSDM is read-only (~10K tokens). Converge + Diverge share the build budget |
| Coordination overhead | Medium | TSDM is the single dispatcher — no peer-to-peer communication needed |
| Diverge goes to Ring 5 | Medium | TSDM enforces ring ceiling on both agents |
| Converge over-standardises | Low | Diverge's reports flag when uniqueness is being erased |

### Implementation

Could be implemented as:
1. **Three subagents** with TSDM as the main context (cheapest)
2. **Three Claude instances** with shared task file (most flexible)
3. **BoJ cartridge** that orchestrates the three roles (most reusable)

### Decision

**Status: Proposed.** Need to validate with a real session before adopting.
Suggested first test: a project with both infrastructure gaps AND creative
depth (IDApTIK? Ephapax?) where both convergent and divergent work matter.
