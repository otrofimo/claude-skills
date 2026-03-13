# Cognitive Mesh Protocol

BDI+OODA cognitive mesh for structured problem-solving. Not analysis — execution.

Based on the [Cognitive Mesh Protocol](https://danielcarneiro.substack.com/p/the-cognitive-mesh-protocol) by Daniel Carneiro. The protocol fuses two cognitive frameworks into an iterative loop: **BDI** manages internal state (what we know, want, and commit to), **OODA** drives external execution (observe, orient, decide, act). The mesh tightens with every cycle.

## Usage

```
/mesh <problem>                    # Single mesh cycle, full execution
/mesh --dry-run <problem>          # Analysis only, no file changes
/mesh --cycles=N <problem>         # Run N mesh iterations (max 5)
/mesh --resume                     # Continue from last mesh state
```

## How It Differs From /interrogate

| | /interrogate | /mesh |
|--|-------------|-------|
| **Purpose** | Analyze — surface tensions | Execute — solve the problem |
| **Output** | Independent lens findings, fault lines | Actions taken, verified results |
| **Structure** | Multiple cognitive lenses, divergent | Single BDI+OODA loop, convergent |
| **State** | Stateless (single pass) | Stateful (beliefs persist across cycles) |
| **Synthesis** | Deliberately avoided | The entire point |

Use `/interrogate` when you want to understand a problem from multiple angles.
Use `/mesh` when you want to solve a problem through disciplined execution.
Use both: `/interrogate` first to surface tensions, then `/mesh` to resolve them.

## The Protocol

### BDI Layer (Internal State)

| Phase | Purpose |
|-------|---------|
| Beliefs | Ground truth — what we know about the current situation, with cited sources |
| Desires | Goal state — specific, measurable, falsifiable objectives |
| Intentions | Commitments — concrete actions for this cycle |

### OODA Layer (External Execution)

| Phase | Purpose |
|-------|---------|
| Observe | Gather evidence — read code, check errors, examine state |
| Orient | Analyze context — root cause, not symptoms. Expected vs actual |
| Decide | Form plan — specific changes, risk assessment, verification steps |
| Act | Execute and verify — make changes, run tests, confirm resolution |

### The Mesh

BDI feeds OODA. OODA updates BDI. Each cycle refines beliefs based on observed reality. Intentions sharpen. Actions become more precise. The mesh tightens until the problem is solved.
