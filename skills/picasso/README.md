# Picasso Bull — Progressive Code Refinement

Progressive code refinement through deliberate waves, inspired by Picasso's Bull lithograph series (1945-46). Wave 1 makes behavior, invariants, and responsibilities explicit. Later waves remove non-essential complexity while preserving those properties. Every wave produces working code.

## The Principle

Picasso's 11 plates don't go linearly from complex to simple. Plates I-III *increase* complexity — adding mass, muscular dissection, surface texture. Only after fully understanding the bull's anatomy does removal begin. Each cut is informed.

Applied to code: you cannot simplify what you do not fully understand *and protect*. Wave 1 may grow the code and the test suite. Every later removal must be justified against the behavior and invariants established there.

## Usage

```
/picasso <target>                    # Run all 6 waves on target
/picasso --wave=3 <target>           # Run waves 1-3 only
/picasso --dry-run <target>          # Show what each wave would do, don't apply
/picasso --resume                    # Continue from last completed wave
/picasso --diff                      # Show cumulative before/after at end
```

## The Six Waves

| Wave | Name | Focus |
|------|------|-------|
| 1 | **Intensify** | Make it explicit — baseline tests, dependency map, center of balance, invariant ledger, existing codebase equivalents, focused tests for unprotected rules |
| 2 | **Clean** | Remove local noise — dead code, dead branches, debug artifacts, AI-generated slop, tests that distinguish nothing |
| 3 | **Consolidate** | One owner per rule — merge duplicate domain logic, route through helpers the codebase already has, inline wrappers, split mixed responsibilities |
| 4 | **Clarify** | Straighten flow — guard clauses, simplified logic, one level of abstraction per method |
| 5 | **Distill** | Challenge abstractions — including everything Wave 1 added. Climb the reuse ladder: existing helper, stdlib, native platform feature, installed dependency |
| 6 | **Essence** | Final reduction — every remaining line load-bearing, final diff reviewed for hidden behavior loss |

## Key Concepts

- **Center of balance** — the core operation everything else serves. Identified in Wave 1, tested against in every subsequent wave.
- **Load-bearing vs. decorative** — load-bearing elements carry structural meaning; decorative elements are convention, accident, or premature generalization.
- **Validated vs. observed** — only requirements, public contracts, or confirmed user intent are validated. Existing code and tests usually establish observed behavior, which is not automatically an invariant.
- **Simplification is compression, not loss** — line count is evidence, not the objective. Revert a reduction that hides a rule, weakens safety, or increases navigation cost.

## The Removal Audit

Every wave after the first audits its own diff before it closes: list what was deleted, name the behavior each deleted line enforced, and point to where that behavior is enforced now. If nothing enforces it, the removal is not a simplification — it is reverted or the protection is replaced. This runs per wave, not once at the end.

## Verification Gates

Every wave that changes code runs the Removal Audit plus the relevant tests and applicable lint or type checks before moving on. Wave 1 starts by recording a baseline — a failing baseline is reported, not refactored away. New tests are proven by mutation: break the rule, watch the test fail, restore it. If a wave causes a failure, only that wave's changes are undone.

Some things are never removed regardless of how decorative they look: validation at a trust boundary, error handling that prevents data loss, security and access-control checks, accessibility affordances. Performance is out of scope as a goal and in scope as a constraint — Picasso does not hunt for optimizations, but it fixes regressions it introduced. A wave with nothing to do says so rather than manufacturing work.

## Example

```
/picasso src/auth/
```

Runs all 6 waves on the auth directory. Wave 1 produces a Bill of Materials with dependency map, abstraction inventory, invariant ledger, and test assessment — and may add names, guards, and focused tests. Waves 2-6 progressively refine. The Gallery Wall at the end shows the full journey with lines, abstractions, tests, and encoded invariants at each stage.
