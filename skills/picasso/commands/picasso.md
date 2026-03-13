---
description: >
  Progressive code simplification through deliberate waves, inspired by Picasso's Bull lithograph
  series (1945-46). Each wave removes a specific category of non-essential complexity while
  preserving behavior. Wave 1 intensifies understanding before any cuts begin. Use when the user
  wants to simplify code methodically, reduce complexity, or understand what their code is really doing.
argument-hint: "[--wave=N] [--dry-run] [--resume] [--diff] <target>"
---

# Picasso Bull — Progressive Code Simplification

You are running a **progressive simplification protocol**, not a one-shot cleanup.

The protocol is modeled on a specific cognitive sequence — the one Picasso used in his 1945-46 Bull lithograph series. The series does **not** go linearly from complex to simple. Plates I-III *increase* complexity — adding mass, muscular dissection, surface texture. Only after fully mapping the bull's anatomy, forces, and weight distribution does removal begin. Each cut is an *informed* cut.

The principle: **you cannot simplify what you do not fully understand.** Simplification is compression, not loss.

Two concepts thread through every wave:

- **Center of balance** — the core operation that everything else in the code serves. Identified in Wave 1, tested against in every subsequent wave.
- **Load-bearing vs. decorative** — a line of code is load-bearing if removing it would break behavior or lose essential clarity. Everything else is decorative: convention, historical accident, premature generalization, or cargo-culted pattern.

## Usage

```
/picasso <target>                    # Run all 6 waves on target
/picasso --wave=3 <target>           # Run waves 1-3 only
/picasso --dry-run <target>          # Show what each wave would do, don't apply changes
/picasso --resume                    # Continue from last completed wave
/picasso --diff                      # Show cumulative before/after at end
```

## Handling Arguments

Parse the `$ARGUMENTS` variable:

1. **If `--dry-run` is present**: Run all analysis but do not apply changes. Report what each wave *would* do.
2. **If `--wave=N` is present**: Run waves 1 through N, then stop.
3. **If `--resume` is present**: Find the last completed wave's output in the conversation and continue from the next wave.
4. **If `--diff` is present**: After the final wave, display a unified diff of the cumulative changes.
5. **Everything else**: Treat as the target — a file path, function name, directory, or "recent" (files changed in last 3 commits).

If no target is provided, ask the user what code to simplify.

---

## Wave 1: Intensify — "The Butcher's Knowledge"

**Focus:** Active, aggressive understanding. Not passive reading — *dissection*.

Picasso didn't sketch the bull once and start simplifying. In Plates II-III he **added** complexity — bulking up mass, adding muscular dissection lines, tracing the skeleton beneath the skin. He joked with the printers he was "cutting up the bull like a butcher." A butcher knows anatomy — knows where the joints are, where muscle attaches to bone, what separates from what. This is not random cutting. It is informed disassembly.

**Moves:**

- Read every line of the target code — not skimming, *dissecting*
- Map ALL dependencies: who calls this, what this calls, what data flows through
- Trace every execution path, including error paths and edge cases
- Identify the **center of balance**: what is the core operation that everything else serves? Where does the structural weight rest?
- Catalog every abstraction (class, module, function, layer) and record what work it does
- For each abstraction, make an initial assessment: **load-bearing** (removing it would break behavior or lose essential clarity) or **decorative** (convention, historical accident, premature generalization)
- Identify test coverage (or lack thereof)
- Measure baseline metrics: line count, function/method count, abstraction count, file count

**Output the Bill of Materials:**

```
## Wave 1: Intensify — "The Butcher's Knowledge"

### What This Code Does
<One paragraph, plain language. Not what comments say — what the code actually does.>

### Center of Balance
<The core operation. Everything else in this code exists to serve this.>

### Dependency Map
- Inbound: <what calls this code>
- Outbound: <what this code calls>
- Data flow: <what data enters, transforms, exits>

### Abstraction Inventory
| Abstraction | Role | Assessment |
|---|---|---|
| <name> | <what it does> | Load-bearing / Decorative / Unclear |

### Load-Bearing vs. Decorative — Initial Assessment
- **Load-bearing:** <list elements that carry structural meaning>
- **Decorative:** <list elements that are convention, accident, or premature generalization>
- **Unclear:** <list elements that need further waves to determine>

### Test Coverage
<Status. If no tests exist, flag this explicitly — the user must decide whether to proceed.>

### Baseline Metrics
- Lines: <count>
- Functions/methods: <count>
- Abstractions: <count>
- Files: <count>
```

**No code changes are made in Wave 1.** But this wave produces an *opinionated* analysis — it is Picasso adding the dissection lines, making structure visible so subsequent waves can make informed cuts.

---

## Wave 2: Clean — "Remove the Background"

**Focus:** Delete everything that contributes nothing. The easiest, safest removals. This is the background — it was never part of the bull.

**Removes:**

- Dead code and unreachable branches
- Unused imports, variables, parameters
- Commented-out code (it's in git history)
- Redundant type assertions / unnecessary casts
- No-op error handlers (catch and rethrow without modification)
- Console.log / debug statements left behind
- Unnecessary `else` after `return`
- Redundant comments that restate the code

**Rule:** Nothing behavioral changes. Only removal of dead weight.

**Verify:** Run tests if they exist. Confirm no functional change.

---

## Wave 3: Consolidate — "Merge the Lines"

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

## Wave 4: Clarify — "Strengthen the Form"

**Focus:** Make control flow and data flow obvious.

**Moves:**

- Flatten nested conditionals (guard clauses / early returns)
- Simplify boolean logic (`!(a && !b)` → clear expression)
- Replace imperative accumulation with declarative transforms where clearer
- Name magic numbers and obscure conditions
- Reorder code to match the reader's mental model (setup → action → cleanup)

**Rule:** A reader should understand the flow without tracing through branching paths.

**Verify:** Run tests. Confirm behavioral equivalence.

---

## Wave 5: Distill — "Find the Load-Bearing Lines"

**Focus:** Challenge every remaining abstraction against the center of balance from Wave 1.

In Plate VI, Picasso identified the invisible lines of force — where weight distributes between front and rear legs, the structural intersection that holds the bull up. These forces, not the visible surface, determined what stayed. The shading went. The texture went. The mass went. What remained were the lines that made the bull *stand*.

**Moves:**

- Return to the Wave 1 center of balance. Does each remaining abstraction serve it?
- Ask of every class/module/function: "What if this didn't exist? What structural weight does it carry?"
- Replace inheritance hierarchies with composition (if simpler)
- Replace generic frameworks with specific solutions (if only one use case)
- Replace configuration-driven behavior with direct code (if only one config exists)
- Collapse unnecessary layers (controller → service → repository, when service is passthrough)
- Use standard library functions instead of hand-rolled equivalents

**Rule:** An abstraction must be load-bearing — serving multiple concrete uses or genuinely clarifying intent. Potential future use doesn't count. Decorative complexity goes.

**Verify:** Run tests. Confirm behavioral equivalence.

---

## Wave 6: Essence — "The Twelve Lines"

**Focus:** Final reduction. Every remaining line must be load-bearing.

Picasso's final plate: approximately 12 lines. Remove any one and it stops being a bull. Add anything back and you're adding information that doesn't increase "bullness."

**Moves:**

- Re-read the entire result from Wave 5
- Ask: "Can this code be expressed more directly?"
- Look for opportunities where the right data structure eliminates algorithms
- Check if renaming alone could eliminate the need for comments
- Challenge file/module boundaries — would fewer files be simpler?
- Apply the "bullness" test: if I removed this line/function/file, would the code stop being recognizably *this code*? If yes, it stays. If no, it goes.
- Write a final plain-language description and compare to Wave 1's — is the code now as simple as the description?

**Rule:** If removing a line would break something or lose clarity, it stays. Everything else goes.

**Verify:** Run tests. Final before/after comparison.

---

## Wave Execution Protocol

For each wave (2-6), output in this structure:

```
## Wave N: <Name> — "<Subtitle>"

### Analysis
<What this wave found that can be simplified, with specific locations>

### Changes
<Numbered list of specific changes with rationale>
1. [file:line] — <what> — <why>

### Metrics
- Lines: <before> → <after> (delta)
- Functions/methods: <before> → <after>
- Abstractions: <before> → <after>

### Verification
- <test results or manual verification>
```

After applying each wave's changes, display the cumulative progress:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Wave 1 ✓  Wave 2 ✓  Wave 3 ●  Wave 4 ○  Wave 5 ○  Wave 6 ○
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Lines: 847 → 784 → ...  |  Abstractions: 23 → 23 → ...
```

## Final Output — "The Gallery Wall"

After the last wave completes, display the full journey:

```
## The Gallery Wall

Wave 1 (Intensify):    <lines> lines | <abstractions> abstractions | <files> files
Wave 2 (Clean):        <lines> lines | <abstractions> abstractions | <files> files  (<% change>)
Wave 3 (Consolidate):  <lines> lines | <abstractions> abstractions | <files> files  (<% change>)
Wave 4 (Clarify):      <lines> lines | <abstractions> abstractions | <files> files  (<% change>)
Wave 5 (Distill):      <lines> lines | <abstractions> abstractions | <files> files  (<% change>)
Wave 6 (Essence):      <lines> lines | <abstractions> abstractions | <files> files  (<% change>)

Total reduction: <start> → <end> lines (<total % change>)

### What Was Learned
- The center of balance: <what this code is really about>
- Decorative complexity removed: <abstractions that turned out to be non-load-bearing>
- The essential lines: <what remains and why each piece is load-bearing>
```

## Behavioral Rules

1. **Wave 1 must complete before any code changes.** Understanding before action. The butcher's knowledge comes first.
2. **Every wave must preserve behavior.** Each intermediate state is a complete, working bull. Run tests after every wave. If tests fail, revert the wave and report what happened.
3. **If no tests exist**, Wave 1 must flag this explicitly. Ask the user: proceed without tests (risky), or stop and write tests first?
4. **The user can stop at any wave.** If `--wave=N` was specified, stop after wave N. The code at any wave is valid, simplified code.
5. **Never combine waves.** Each wave has a specific lens. Mixing them produces unfocused changes that are harder to review and harder to revert.
6. **Track metrics cumulatively.** The journey matters as much as the destination.
7. **In `--dry-run` mode**, perform all analysis but make no file changes. Report what each wave *would* do, with specific locations and rationale.
8. **Simplification is compression, not loss.** If something feels *lost* after a wave — if the code became harder to understand or less capable — the wrong thing was removed. Revert and reconsider.
