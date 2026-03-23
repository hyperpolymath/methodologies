# SPDX-License-Identifier: PMPL-1.0-or-later
# Triaxial Software Development Methodology (TSDM)

## Overview

Three-axis methodology applied in strict order: **Scope → Maintenance → Audit**.
Each axis has its own priority ordering. Followed by a cleanup/finish-off phase
and mandatory maintainer dialogue.

## When to Use

- Systematic project assessment (not random walk)
- Pre-release audits
- When guaranteed coverage matters more than serendipitous discovery
- As the "navigator" half of a TSDM-Meander alternating pass

## The Three Axes

### Axis 1: Scope

**Priority:** must > intend > like

**Inputs:**
- README, roadmap, status docs, CI/security docs
- Marker scan: `TODO`, `FIXME`, `XXX`, `HACK`, `STUB`, `PARTIAL`
- Idris unsound scan: `believe_me`, `assert_total`

**Output:** Scoped work assembly — the prioritised work list.

### Axis 2: Maintenance

**Priority:** corrective > adaptive > perfective

| Type | Description |
|------|-------------|
| **Corrective** | Defect/regression/safety/security fixes |
| **Adaptive** | Scope reconciliation, stale-reference removal, obsolete-work culling |
| **Perfective** | Quality improvements derived from Axis 1 honest state |

### Axis 3: Audit

**Priority:** systems > compliance > effects

| Type | Description | Tooling |
|------|-------------|---------|
| **Systems** | Required systems present and operating | — |
| **Compliance** | Exceptions explicit, bounded, drift-resistant | panic-attack |
| **Effects** | Benchmark/operational impact evidence captured | sustainabot |

## Cleanup/Finish-Off Phase

1. Root cleanup
2. Stale work cull
3. Docs sync (human + machine)
4. Compliance audit
5. Effects audit
6. Release summary: must / should / could
7. Next actions: corrective / adaptive / perfective

## Collaboration

Maintainer dialogue is **REQUIRED** at the end. Topics:
- What changed
- Why
- Remaining risks

## Machine-Readable Source

See `SOFTWARE-DEVELOPMENT-APPROACH.a2ml` in this directory.

## Relationship to Productive Meandering

TSDM and Productive Meandering are complementary:

| Property | TSDM | Meandering |
|----------|------|------------|
| Coverage | Guaranteed (systematic) | Probabilistic (random walk) |
| Discovery | Low (follows checklist) | High (finds surprises) |
| Completion | Predictable | Unpredictable |
| Best for | Audits, releases, compliance | Exploration, migration, integration |

The **TSDM-Meander alternating pass** combines both: TSDM provides the
priority queue, meandering provides the discovery. See the Productive
Meandering v3 prompt for details.
