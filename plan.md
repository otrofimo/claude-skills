# Picasso Bull Skill — Design Plan

## The Concept

Picasso's 1945 lithograph series: 11 prints of a bull, each progressively stripped down until only essential lines remain. The detailed first version isn't a rough draft — it's the foundation that makes the final abstraction meaningful. Each intermediate state is a complete bull.

**Applied to code:** Take working code and simplify it through deliberate waves, where each wave removes a specific category of non-essential complexity. Every wave must produce working code. The user can stop at any wave.

## Why This Is Different From `/simplify`

Anthropic's built-in `/simplify` is a **single-pass** tool that runs 3 parallel agents (reuse, quality, efficiency) and applies fixes. It's excellent but:

- It's one shot — no progressive refinement
- It doesn't show the *journey* of simplification
- It doesn't force the question "what is this code *actually* doing?"
- It can't reveal when an entire abstraction layer is unnecessary

The Picasso Bull is **multi-wave** — each wave has a specific lens and builds on the previous wave's output. The journey itself teaches you about your code.

## Skill Structure

```
skills/picasso/
├── .claude-plugin/
│   └── plugin.json
├── README.md
└── commands/
    └── picasso.md
```

## Command Interface

```
/picasso <target>                    # Run all waves on target (file, function, or recent changes)
/picasso --wave=3 <target>           # Run only waves 1-3
/picasso --dry-run <target>          # Show what each wave would do, don't apply
/picasso --resume                    # Continue from last completed wave
/picasso --diff                      # Show cumulative before/after at end
```

## The Six Waves

### Wave 1: Study — "The Realistic Bull"
**Focus:** Complete understanding before touching anything.
**Moves:**
- Read every line of the target code
- Map all dependencies, callers, and call sites
- Identify test coverage (or lack thereof)
- Measure baseline: line count, cyclomatic complexity estimate, abstraction depth
- Document what the code *actually does* in plain language (not what comments say)

**Output:** A "Bill of Materials" — what this code is, what it does, what it depends on, how it's tested.

**No changes are made in Wave 1.** This is Picasso studying the anatomy.

---

### Wave 2: Clean — "Remove the Background"
**Focus:** Delete everything that contributes nothing.
**Removes:**
- Dead code and unreachable branches
- Unused imports, variables, parameters
- Commented-out code (it's in git)
- Redundant type assertions / unnecessary casts
- No-op error handlers (catch and rethrow without modification)
- Console.log / debug statements left behind
- Unnecessary `else` after `return`

**Rule:** Nothing behavioral changes. Only removal of dead weight.

**Verify:** Run tests if they exist. Confirm no functional change.

---

### Wave 3: Consolidate — "Merge the Lines"
**Focus:** Collapse duplication and unnecessary indirection.
**Moves:**
- Merge duplicate logic into shared implementations
- Inline trivial wrapper functions (functions that just call another function)
- Collapse single-use abstractions back to their call site
- Replace verbose patterns with language idioms
- Merge related but scattered state into cohesive structures

**Rule:** Reduce the number of concepts the reader must hold in their head.

**Verify:** Run tests. Confirm behavioral equivalence.

---

### Wave 4: Clarify — "Strengthen the Form"
**Focus:** Make control flow and data flow obvious.
**Moves:**
- Flatten nested conditionals (guard clauses / early returns)
- Simplify boolean logic (`!(a && !b)` → clear expression)
- Replace imperative accumulation with declarative transforms (map/filter/reduce where clearer)
- Name magic numbers and obscure conditions
- Reorder code to match the reader's mental model (setup → action → cleanup)

**Rule:** A reader should understand the flow without tracing through branching paths.

**Verify:** Run tests. Confirm behavioral equivalence.

---

### Wave 5: Distill — "Find the Essence"
**Focus:** Challenge every abstraction. Does it earn its existence?
**Moves:**
- Ask of every class/module/function: "What if this didn't exist?"
- Replace inheritance hierarchies with composition (if simpler)
- Replace generic frameworks with specific solutions (if there's only one use case)
- Replace configuration-driven behavior with direct code (if only one config exists)
- Collapse unnecessary layers (controller → service → repository, when service is passthrough)
- Use standard library functions instead of hand-rolled equivalents

**Rule:** An abstraction must justify its complexity by serving multiple concrete uses or genuinely clarifying intent. Potential future use doesn't count.

**Verify:** Run tests. Confirm behavioral equivalence.

---

### Wave 6: Essence — "The Essential Lines"
**Focus:** Final reduction. Every remaining line must be load-bearing.
**Moves:**
- Re-read the entire result from Wave 5
- Ask: "Can this code be expressed more directly?"
- Look for opportunities where the right data structure eliminates algorithms
- Check if renaming alone could eliminate the need for comments
- Challenge the file/module boundaries — would fewer files be simpler?
- Write a final plain-language description and compare to Wave 1's — is the code now as simple as the description?

**Rule:** If removing a line would break something or lose clarity, it stays. Everything else goes.

**Verify:** Run tests. Final before/after comparison.

---

## Wave Execution Protocol

For each wave (2-6), follow this structure:

```
## Wave N: <Name> — "<Subtitle>"

### Analysis
<What this wave found that can be simplified, with specific locations>

### Changes
<Numbered list of specific changes with rationale>
1. [file:line] — <what> — <why>

### Metrics
- Lines: <before> → <after> (Δ<diff>)
- Functions/methods: <before> → <after>
- Abstractions: <before> → <after>

### Verification
- <test results or manual verification>
```

## Cumulative Progress Display

After each wave, show a running progress bar:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Wave 1 ✓  Wave 2 ✓  Wave 3 ●  Wave 4 ○  Wave 5 ○  Wave 6 ○
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Lines: 847 → 612 → ...  |  Abstractions: 23 → 19 → ...
```

## Final Output — "The Gallery Wall"

At completion, display the full journey:

```
## The Gallery Wall

Wave 1 (Study):    847 lines | 23 abstractions | 14 files
Wave 2 (Clean):    784 lines | 23 abstractions | 14 files  (-7.4%)
Wave 3 (Consolidate): 651 lines | 18 abstractions | 11 files (-16.9%)
Wave 4 (Clarify):  618 lines | 18 abstractions | 11 files  (-5.1%)
Wave 5 (Distill):  492 lines | 12 abstractions | 8 files   (-20.4%)
Wave 6 (Essence):  471 lines | 11 abstractions | 7 files   (-4.3%)

Total reduction: 847 → 471 lines (44.4%)

### What Was Learned
- <insight about the code revealed through simplification>
- <abstraction that turned out to be unnecessary and why>
- <the "essential lines" — what this code is really about>
```

## Design Decisions

1. **Wave 1 makes no changes** — Understanding before action. This is what makes Picasso's approach different from just "clean up the code."

2. **Every wave must preserve behavior** — Each intermediate state is a complete, working bull. Tests must pass. If no tests exist, Wave 1 flags this and the user decides whether to proceed.

3. **User can stop at any wave** — Maybe Wave 3 is simple enough. The skill respects that.

4. **Metrics are tracked cumulatively** — The journey matters. Seeing "Wave 5 removed 3 entire abstractions" is more valuable than "your code got shorter."

5. **`--dry-run` shows the full journey without changes** — Useful for understanding what simplification *would* look like before committing to it.

6. **No persona simulation** — Following the codebase convention. The skill runs operational protocols (analyze, remove, consolidate, clarify, distill, reduce), not "what would Picasso say."

7. **Targets can be flexible** — A single file, a function, a directory, or "recent changes" (files modified in the last N commits).

## Implementation Plan

1. Create `skills/picasso/.claude-plugin/plugin.json`
2. Create `skills/picasso/commands/picasso.md` — the full skill definition
3. Create `skills/picasso/README.md`
4. Update `.claude-plugin/marketplace.json` to register the new skill
