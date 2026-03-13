# Picasso Bull — Progressive Code Simplification

Progressive code simplification through deliberate waves, inspired by Picasso's Bull lithograph series (1945-46). Each wave removes a specific category of non-essential complexity. Every wave produces working code.

## The Principle

Picasso's 11 plates don't go linearly from complex to simple. Plates I-III *increase* complexity — adding mass, muscular dissection, surface texture. Only after fully understanding the bull's anatomy does removal begin. Each cut is informed.

Applied to code: you cannot simplify what you do not fully understand. Wave 1 intensifies understanding before any cuts begin.

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
| 1 | **Intensify** | Active dissection — map dependencies, find the center of balance, classify load-bearing vs. decorative |
| 2 | **Clean** | Remove dead weight — unused code, dead branches, debug artifacts |
| 3 | **Consolidate** | Collapse duplication — inline wrappers, merge duplicates, use idioms |
| 4 | **Clarify** | Straighten flow — guard clauses, simplified logic, reader-friendly order |
| 5 | **Distill** | Challenge abstractions — does each one earn its existence against the center of balance? |
| 6 | **Essence** | Final reduction — every remaining line must be load-bearing |

## Key Concepts

- **Center of balance** — the core operation everything else serves. Identified in Wave 1, tested against in every subsequent wave.
- **Load-bearing vs. decorative** — load-bearing elements carry structural meaning; decorative elements are convention, accident, or premature generalization.
- **Simplification is compression, not loss** — if something feels lost, the wrong thing was removed.

## Example

```
/picasso src/auth/
```

Runs all 6 waves on the auth directory. Wave 1 produces a Bill of Materials with dependency map, abstraction inventory, and load-bearing assessment. Waves 2-6 progressively simplify. The Gallery Wall at the end shows the full journey with metrics.
