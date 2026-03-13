# Picasso Bull Skill — Design Plan

## The Concept

Picasso's 1945-46 lithograph series: 11 plates of a bull on a single reworked stone. The series does **not** progress linearly from complex to simple. Plates I-III *increase* complexity — adding mass, muscular dissection, surface texture. Only after fully understanding the bull's anatomy, forces, and weight distribution does Picasso begin removing. Each destruction is informed destruction.

**The cognitive sequence:**
1. **Render** — Capture faithfully
2. **Intensify** — Push beyond faithful to understand the full expressive range. Make it *more* complex. ("I was cutting up the bull like a butcher")
3. **Analyze** — Decompose into structural components, identify planes, forces, center of balance
4. **Identify load-bearing elements** — Which lines carry meaning?
5. **Eliminate** — Remove everything not load-bearing
6. **Verify** — Must still be recognizable. If not, something essential was removed.

Picasso: *"A picture used to be a sum of additions. In my case, a picture is a sum of destructions."*

**Applied to code:** Take working code and simplify it through deliberate waves. But critically — Wave 1 is not passive study. It is active intensification: mapping every dependency, tracing every call path, understanding *why* each abstraction exists. You must build the complex mental model before you can identify what's load-bearing. The 12 final lines only work because they are survivors of a rigorous elimination process informed by total anatomical knowledge.

## Why This Is Different From `/simplify`

Anthropic's built-in `/simplify` is a **single-pass** tool that runs 3 parallel agents (reuse, quality, efficiency) and applies fixes. It's excellent but:

- It's one shot — no progressive refinement
- It doesn't show the *journey* of simplification
- It doesn't force the question "what is this code *actually* doing?"
- It can't reveal when an entire abstraction layer is unnecessary
- It skips the intensification phase — the "Plates II-III" that make informed removal possible

The Picasso Bull is **multi-wave** — each wave has a specific lens and builds on the previous wave's output. The journey itself teaches you about your code. And like the series itself, the early waves may *add* understanding-complexity before later waves remove implementation-complexity.

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

### Wave 1: Intensify — "The Butcher's Knowledge"
**Focus:** Active, aggressive understanding. Not passive reading — *dissection*.

Picasso didn't just sketch the bull in Plate I and start simplifying. In Plates II and III he **added** complexity — bulking up the mass, adding muscular dissection lines, mapping surface texture, tracing the skeleton beneath the skin. He needed to understand the bull's full expressive range before he could identify what was essential. The printers at Mourlot's studio watched him make the bull *more* complex, more detailed, more threatening — and only then begin to simplify.

**Moves:**
- Read every line of the target code — not skimming, *dissecting*
- Map ALL dependencies: who calls this, what this calls, what data flows through
- Trace every execution path, including error paths and edge cases
- Identify the "center of balance" — where does the structural weight of this code actually rest? What is the core operation everything else serves?
- Catalog every abstraction and ask: what work does this abstraction do? What would break without it?
- Identify test coverage (or lack thereof)
- Measure baseline: line count, cyclomatic complexity estimate, abstraction depth
- Document what the code *actually does* in plain language (not what comments say)

**Output:** A "Bill of Materials" that includes:
- **What this code does** — plain language, one paragraph
- **The center of balance** — the core operation everything else supports
- **Dependency map** — every inbound and outbound connection
- **Abstraction inventory** — every class/module/function/layer with its justification
- **Load-bearing vs. decorative** — initial assessment of which elements carry structural meaning vs. which are convention, historical accident, or premature generalization
- **Test coverage status**
- **Metrics:** line count, function count, abstraction count, file count

**No code changes are made in Wave 1.** But unlike passive study, this wave produces an *opinionated* analysis. It is Picasso adding the dissection lines — making the structure *visible* so that subsequent waves can make informed cuts.

---

### Wave 2: Clean — "Remove the Background"
**Focus:** Delete everything that contributes nothing. The easiest, safest removals.
**Removes:**
- Dead code and unreachable branches
- Unused imports, variables, parameters
- Commented-out code (it's in git)
- Redundant type assertions / unnecessary casts
- No-op error handlers (catch and rethrow without modification)
- Console.log / debug statements left behind
- Unnecessary `else` after `return`

**Rule:** Nothing behavioral changes. Only removal of dead weight. This is the background — it was never part of the bull.

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

### Wave 5: Distill — "Find the Load-Bearing Lines"
**Focus:** Challenge every abstraction against the "center of balance" identified in Wave 1.

Picasso's final plates are not arbitrary — each remaining line is load-bearing. In Plate VI, he identified the lines of force where weight distributes between front and rear legs. These invisible structural forces, not the visible surface, determined what stayed. The shading went. The texture went. The mass went. What remained were the lines that made the bull *stand*.

**Moves:**
- Return to the Wave 1 "center of balance." Does each remaining abstraction serve the core operation?
- Ask of every class/module/function: "What if this didn't exist? What structural weight does it carry?"
- Replace inheritance hierarchies with composition (if simpler)
- Replace generic frameworks with specific solutions (if there's only one use case)
- Replace configuration-driven behavior with direct code (if only one config exists)
- Collapse unnecessary layers (controller → service → repository, when service is passthrough)
- Use standard library functions instead of hand-rolled equivalents

**Rule:** An abstraction must be load-bearing — serving multiple concrete uses or genuinely clarifying intent. Potential future use doesn't count. Decorative complexity goes.

**Verify:** Run tests. Confirm behavioral equivalence.

---

### Wave 6: Essence — "The Twelve Lines"
**Focus:** Final reduction. Every remaining line must be load-bearing.

Picasso's final plate: approximately 12 lines. A small circle for a head, horns reduced to antenna-like marks, a vague ovular body shape, a single line for the genitals. It is still, unmistakably, a bull. Remove any one line and it stops being a bull. Add anything back and you're adding information that doesn't increase "bullness."

**Moves:**
- Re-read the entire result from Wave 5
- Ask: "Can this code be expressed more directly?"
- Look for opportunities where the right data structure eliminates algorithms
- Check if renaming alone could eliminate the need for comments
- Challenge the file/module boundaries — would fewer files be simpler?
- Apply the "bullness" test: if I removed this line/function/file, would the code stop being recognizably *this code*? If yes, it stays. If no, it goes.
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

Wave 1 (Intensify):    847 lines | 23 abstractions | 14 files  — "The Butcher's Knowledge"
Wave 2 (Clean):        784 lines | 23 abstractions | 14 files  (-7.4%)
Wave 3 (Consolidate):  651 lines | 18 abstractions | 11 files  (-16.9%)
Wave 4 (Clarify):      618 lines | 18 abstractions | 11 files  (-5.1%)
Wave 5 (Distill):      492 lines | 12 abstractions | 8 files   (-20.4%)
Wave 6 (Essence):      471 lines | 11 abstractions | 7 files   (-4.3%)

Total reduction: 847 → 471 lines (44.4%)

### What Was Learned
- <The "center of balance" — what this code is really about>
- <Abstractions that turned out to be decorative, not load-bearing>
- <The "twelve lines" — the essential structure that everything else served>
```

## Design Decisions

1. **Wave 1 actively intensifies understanding, not passively reads** — This is the key insight from the research. Picasso's Plates II-III don't simplify — they add complexity to understand the subject's full range. Wave 1 produces an opinionated "Bill of Materials" with a declared center of balance and load-bearing analysis. The butcher knows where the joints are.

2. **"Center of balance" concept threads through the entire process** — Wave 1 identifies it, Waves 2-4 clear away noise around it, Wave 5 tests every abstraction against it, Wave 6 verifies that only load-bearing elements remain. This mirrors Picasso's Plate VI, where he found the structural intersection where weight distributes.

3. **"Load-bearing vs. decorative" is the primary simplification heuristic** — Not "used vs. unused" (that's just Wave 2). The deeper question is: does this element carry structural meaning, or is it convention/historical accident/premature generalization? Picasso kept 12 lines not because the others were "unused" but because those 12 carried the bull's structural identity.

4. **Every wave must preserve behavior** — Each intermediate state is a complete, working bull. Tests must pass. If no tests exist, Wave 1 flags this and the user decides whether to proceed.

5. **User can stop at any wave** — Maybe Wave 3 is simple enough. The skill respects that.

6. **Metrics are tracked cumulatively** — The journey matters. Seeing "Wave 5 removed 3 entire abstractions" is more valuable than "your code got shorter."

7. **`--dry-run` shows the full journey without changes** — Useful for understanding what simplification *would* look like before committing to it.

8. **No persona simulation** — Following the codebase convention. The skill runs operational protocols (intensify, clean, consolidate, clarify, distill, reduce), not "what would Picasso say."

9. **Targets can be flexible** — A single file, a function, a directory, or "recent changes" (files modified in the last N commits).

10. **Simplification is compression, not loss** — As Picasso said: "Starting with the egg and following the same process in reverse, one finishes with the portrait." The simplified code should contain the full understanding, compressed. If the simplification feels like something was *lost*, the wrong thing was removed.

## Implementation Plan

1. Create `skills/picasso/.claude-plugin/plugin.json`
2. Create `skills/picasso/commands/picasso.md` — the full skill definition
3. Create `skills/picasso/README.md`
4. Update `.claude-plugin/marketplace.json` to register the new skill (if exists)
