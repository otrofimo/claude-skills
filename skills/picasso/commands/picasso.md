---
description: >
  Progressive code refinement through deliberate waves, inspired by Picasso's Bull lithograph
  series (1945-46). Wave 1 makes behavior, invariants, and responsibilities explicit. Later waves
  remove non-essential complexity while preserving those properties. Use when the user wants to
  simplify code methodically, strengthen it before refactoring, or understand what it is really doing.
argument-hint: "[--wave=N] [--dry-run] [--resume] [--diff] <target>"
---

# Picasso Bull — Progressive Code Refinement

You are running a **progressive refinement protocol**, not a one-shot cleanup.

The protocol is modeled on a specific cognitive sequence — the one Picasso used in his 1945-46 Bull lithograph series. The series does **not** go linearly from complex to simple. Plates I-III *increase* complexity — adding mass, muscular dissection, surface texture. Only after fully mapping the bull's anatomy, forces, and weight distribution does removal begin. Each cut is an *informed* cut.

The principle: **you cannot simplify what you do not fully understand and protect.** Wave 1 may
increase code and test size. Later waves must justify every removal against the behavior and
invariants established there. Simplification is compression, not loss.

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

**Focus:** Make behavior, invariants, and responsibilities explicit before making cuts.

Picasso didn't sketch the bull once and start simplifying. In Plates II-III he **added** complexity — bulking up mass, adding muscular dissection lines, tracing the skeleton beneath the skin. He joked with the printers he was "cutting up the bull like a butcher." A butcher knows anatomy — knows where the joints are, where muscle attaches to bone, what separates from what. This is not random cutting. It is informed disassembly.

Start by running the relevant tests without changing code. A failing baseline is evidence. Do not
hide it with refactoring. Stop and report it unless the user explicitly accepts the known failure.

**Understand:**

- Read every line of the target and trace normal, boundary, and error paths
- Map inbound callers, outbound dependencies, data transformations, and side effects
- Identify the **center of balance**: the core operation that everything else serves
- Catalog each abstraction and the reason it exists
- Separate validated requirements from behavior that is only observed or assumed
- Record baseline size, structure, test count, and available complexity or coverage metrics

**Encode:**

- Give domain concepts and responsibilities precise names
- Encode validated invariants with the lightest suitable mechanism: types, value objects, guards, assertions, or constrained constructors
- Extract methods when the name identifies a domain step, policy, side effect, or independent responsibility
- Add comments only for rationale, constraints, or surprising decisions that code cannot state clearly
- Add focused behavioral tests for important invariants, boundaries, and failure paths that lack protection

Each new test must name the behavior or invariant that it protects. Prefer tests that fail when the
protected rule is removed. Use table-driven or property tests only when the input space and existing
tooling justify them. Do not add a test dependency without approval.

Temporary expansion is expected. Do not extract methods only to make methods shorter. The Single
Responsibility Principle concerns reasons to change, not line count.

Treat tests as evidence, not unquestionable authority. Flag tests that only assert private structure,
mock call sequences, or behavior contradicted by stronger requirements. Do not make production code
more complex solely to satisfy such a test.

"Validated" means supported by a requirement, public contract, or confirmed user intent. Existing
code and tests usually establish "Observed," not "Validated." Do not encode every observed behavior
as an invariant.

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

### Invariant Ledger
| Invariant | Evidence | Confidence | Encoding |
|---|---|---|---|
| <rule that must remain true> | <code, test, caller, docs> | Validated / Observed / Assumed | <type, guard, test, comment, none> |

### Load-Bearing vs. Decorative — Initial Assessment
- **Load-bearing:** <list elements that carry structural meaning>
- **Decorative:** <list elements that are convention, accident, or premature generalization>
- **Unclear:** <list elements that need further waves to determine>

### Test Assessment
- Baseline result: <command and result>
- Contract tests: <tests that protect meaningful behavior>
- Coverage gaps: <important invariants, boundaries, and errors without tests>
- Low-value constraints: <tests coupled to implementation or unable to distinguish behavior>

### Intensification Changes
1. [file:line] — <name, invariant, responsibility, or test made explicit> — <why>

### Metrics
- Lines: <baseline> → <after Intensify>
- Functions/methods: <baseline> → <after Intensify>
- Abstractions: <baseline> → <after Intensify>
- Tests: <baseline> → <after Intensify>
- Encoded invariants: <baseline> → <after Intensify>
- Files: <baseline> → <after Intensify>
```

Run relevant tests and applicable lint or type checks after intensification. Wave 1 ends with a
working, better-protected design.

---

## Wave 2: Clean — "Remove the Background"

**Focus:** Remove local noise while preserving the intent exposed in Wave 1.

**Removes:**

- Dead code and unreachable branches
- Unused imports, variables, parameters
- Commented-out code (it's in git history)
- Redundant type assertions / unnecessary casts
- No-op error handlers (catch and rethrow without modification)
- Console.log / debug statements left behind
- Unnecessary `else` after `return`
- Redundant comments that restate the code
- Duplicate mechanics when each copy implements the same rule and has the same reason to change
- Tests that cannot distinguish a meaningful behavior from the remaining test suite

Extract a shared implementation only when the copies represent the same knowledge. Similar syntax is
not sufficient. If the change moves ownership between modules or files, defer it to Wave 3.

Before deleting a test, name the behavior it claims to protect. Identify the remaining test that
would fail if that behavior broke. If no such test exists, keep or replace the protection.

**Rule:** Remove contamination, not domain detail. Nothing behavioral changes.

**Verify:** Run relevant tests and applicable lint or type checks. Confirm no functional change.

---

## Wave 3: Consolidate — "Merge the Lines"

**Focus:** Give each rule one owner and each concept one canonical representation.

**Moves:**

- Merge duplicate domain logic into shared implementations
- Inline trivial wrapper functions (functions that just call another function)
- Collapse single-use abstractions back to their call site
- Merge related but scattered state into cohesive structures
- Move behavior to the module, class, or value object that owns the rule
- Split components that have independent reasons to change

**Rule:** Consolidate shared knowledge, not coincidental syntax. Reduce the number of places that must
change when one business rule changes.

**Verify:** Run relevant tests and applicable lint or type checks. Confirm behavioral equivalence.

---

## Wave 4: Clarify — "Strengthen the Form"

**Focus:** Make control flow and data flow obvious.

**Moves:**

- Flatten nested conditionals (guard clauses / early returns)
- Simplify boolean logic (`!(a && !b)` → clear expression)
- Replace imperative accumulation with declarative transforms where clearer
- Name magic numbers and obscure conditions
- Reorder code to match the reader's mental model (setup → action → cleanup)
- Normalize input once instead of making readers track several equivalent forms
- Remove comments that became redundant after names and flow improved

**Rule:** Keep each method at one level of abstraction. A reader should understand the primary path
without tracing every branch or helper.

**Verify:** Run relevant tests and applicable lint or type checks. Confirm behavioral equivalence.

---

## Wave 5: Distill — "Find the Load-Bearing Lines"

**Focus:** Challenge every remaining abstraction against the center of balance from Wave 1.

In Plate VI, Picasso identified the invisible lines of force — where weight distributes between front and rear legs, the structural intersection that holds the bull up. These forces, not the visible surface, determined what stayed. The shading went. The texture went. The mass went. What remained were the lines that made the bull *stand*.

**Moves:**

- Return to the Wave 1 center of balance. Does each remaining abstraction serve it?
- Revisit every method, type, comment, and test added during Intensify. Did it earn its cost?
- Ask of every class/module/function: "What if this didn't exist? What structural weight does it carry?"
- Replace inheritance hierarchies with composition (if simpler)
- Replace generic frameworks with specific solutions (if only one use case)
- Replace configuration-driven behavior with direct code (if only one config exists)
- Collapse unnecessary layers (controller → service → repository, when service is passthrough)
- Use standard library functions instead of hand-rolled equivalents
- Merge or remove characterization tests once stronger contract tests protect the same behavior

**Rule:** An abstraction must be load-bearing — serving multiple concrete uses or genuinely clarifying intent. Potential future use doesn't count. Decorative complexity goes.

**Verify:** Run relevant tests and applicable lint or type checks. Confirm behavioral equivalence.

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
- Review the final diff for hidden behavior loss, weaker errors, or names that became less precise

**Rule:** Line count is evidence, not the objective. If a reduction hides a rule, weakens safety, or
increases navigation cost, revert it. Stop when another cut would remove behavior or useful clarity.

**Verify:** Run relevant tests and applicable lint or type checks. Complete the final comparison.

---

## Wave Execution Protocol

Wave 1 uses the Bill of Materials above. For Waves 2-6, output this structure:

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
- Tests: <before> → <after>
- Encoded invariants: <before> → <after>

### Verification
- <test results or manual verification>
```

Count each distinct invariant once. Do not count its guard, type, and test as three invariants.

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

Wave 1 (Intensify):    <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants
Wave 2 (Clean):        <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants
Wave 3 (Consolidate):  <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants
Wave 4 (Clarify):      <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants
Wave 5 (Distill):      <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants
Wave 6 (Essence):      <lines> lines | <abstractions> abstractions | <tests> tests | <invariants> encoded invariants

Net size change: <start> → <end> lines (<signed count and percentage>)

### What Was Learned
- The center of balance: <what this code is really about>
- Decorative complexity removed: <abstractions that turned out to be non-load-bearing>
- The essential lines: <what remains and why each piece is load-bearing>
```

## Behavioral Rules

1. **Establish a baseline before changing code.** Run the smallest relevant test set and record existing failures.
2. **Wave 1 may expand the code.** It must make validated behavior safer and easier to understand. Do not encode assumptions as requirements.
3. **Strengthen tests selectively.** Use the existing test framework. Prefer public behavior, invariants, boundaries, and errors. Avoid private-method tests and mock-only assertions. Do not pursue coverage percentage as an objective.
4. **If no usable test harness exists**, ask whether to add one or proceed with explicit risk. Do not introduce a new framework without approval.
5. **Every changed wave must verify its work.** Run relevant tests and applicable static checks. If a wave causes a failure, undo only that wave's changes. Preserve all pre-existing and unrelated user changes.
6. **The user can stop at any wave.** If `--wave=N` was specified, stop after Wave N. Each completed wave must leave working code.
7. **Never combine waves.** Each wave has a separate review lens and must remain easy to revert.
8. **Track metrics cumulatively, but do not optimize one metric alone.** A shorter implementation can still be worse.
9. **In `--dry-run` mode**, perform all analysis but make no file changes. Report proposed invariant, test, and code changes with specific locations.
10. **Simplification is compression, not loss.** Revert a reduction that hides intent, removes protection, or makes the code harder to change safely.
