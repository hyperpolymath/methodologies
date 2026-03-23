# SPDX-License-Identifier: PMPL-1.0-or-later
# Rhodium Standard Repositories (RSR) — as a Methodology

## Overview

RSR is both a template (`rsr-template-repo`) and a methodology for repository
standardisation. Every hyperpolymath repo is created from the template and
maintains compliance with the standard.

## The RSR Methodology

### Core Principle
All repos share the same structural DNA. A bot, human, or CI system that
understands one RSR repo understands all of them.

### What RSR Standardises
- **17 CI workflows** (security, quality, mirroring, policy enforcement)
- **Checkpoint files** (STATE.a2ml, META.a2ml, ECOSYSTEM.a2ml in `.machine_readable/`)
- **Documentation** (README.adoc, EXPLAINME.adoc, SECURITY.md, CONTRIBUTING.md)
- **Build** (Justfile with standardised recipes)
- **License** (PMPL-1.0-or-later with MPL-2.0 fallback)
- **AI manifest** (0-AI-MANIFEST.a2ml or AI.a2ml)
- **Author attribution** (Jonathan D.A. Jewell, noreply email for git)

### RSR as Methodology — Open Questions

1. **Is RSR too heavy for docs-only repos?** This methodologies repo doesn't
   need 17 CI workflows, a Containerfile, or a Cargo.toml. Should there be
   an RSR-lite variant?

2. **Does RSR's standardisation inhibit divergent work?** When every repo
   looks the same, creative projects (languages, research) get pushed toward
   the same "complete" shape. The Productive Meandering v3 prompt explicitly
   warns about this (convergence bias).

3. **Is `just init` sufficient onboarding?** New repos still need significant
   placeholder replacement. Could the template be smarter (detect language,
   auto-configure CodeQL matrix, set up correct Cargo/Mix/Deno structure)?

4. **Should RSR checkpoint files be A2ML or SCM?** The repo uses both formats
   across different projects. Standardising on one would reduce cognitive load.

### RSR + Other Methodologies

| Combined with | Effect |
|---------------|--------|
| TSDM | TSDM's Axis 3 (Audit) naturally checks RSR compliance |
| Productive Meandering | Ring 1 naturally fixes RSR gaps (SPDX headers, missing docs) |
| Parallel Audit | Agents can split by RSR category (CI, docs, contracts, code) |
| panic-attack | `assail` is the automated RSR compliance checker |

## Reference

- Template: `~/Documents/hyperpolymath-repos/rsr-template-repo`
- Compliance tool: `panic-attack assail .`
- Verification: `~/verify-repo-standards.jl`
