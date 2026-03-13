---
description: >
  Run the BDI+OODA cognitive mesh protocol against a problem. Structured
  problem-solving through iterative cycles: Beliefs-Desires-Intentions manage
  internal state, Observe-Orient-Decide-Act drive external execution. The mesh
  tightens each cycle until the problem is solved. Use when the user wants
  structured debugging, feature implementation, refactoring, or any complex
  engineering task that benefits from disciplined cognitive scaffolding.
argument-hint: "[--dry-run] [--cycles=N] [--resume] <problem>"
---

# Cognitive Mesh Protocol — BDI+OODA Execution Loop

You are running a **cognitive protocol**, not a persona simulation.

This protocol is based on the [Cognitive Mesh Protocol](https://danielcarneiro.substack.com/p/the-cognitive-mesh-protocol) by Daniel Carneiro. It fuses two cognitive frameworks into an iterative execution loop:

- **BDI (Beliefs-Desires-Intentions)** manages your internal state — what you know, what you want, and what you commit to doing.
- **OODA (Observe-Orient-Decide-Act)** drives your external execution — gather evidence, make sense of it, decide on a course, execute it.

The mesh is the coupling: BDI feeds OODA. OODA updates BDI. Each cycle tightens the mesh until the problem is solved.

**The cardinal rule:** Every cycle must produce either (a) concrete actions taken, or (b) a specific, committed plan with identified blockers. Pure analysis without commitment is a protocol violation. If you find yourself writing paragraphs of analysis without a concrete next step, stop and formulate an intention.

Protocols are hard-coded cognitive structures. They're how actual minds process complex problems — not costumes to wear, but methods to execute.

---

## Handling Arguments

Parse `$ARGUMENTS`:

1. **`--dry-run`**: Run the full mesh protocol but do NOT execute the Act phase. Instead, output intended actions as a detailed plan. Mark all Act output with `[DRY RUN — No changes made]`.
2. **`--cycles=N`**: Run N mesh iterations (default: 1). Each cycle feeds its results into the next. Cap at 5 — if five cycles haven't resolved the problem, it needs decomposition, not more iteration.
3. **`--resume`**: Look for a previous mesh state in the conversation history. Resume from the last completed phase with preserved BDI state. If no prior mesh state exists, treat as a fresh invocation.
4. **Everything else**: The problem statement.

If no problem statement is provided and `--resume` is not set, ask the user what problem to solve.

---

## Phase 0: Pre-Mesh Calibration

Before entering the mesh, perform a rapid calibration. This takes seconds, not minutes. Its purpose is to set the gear — how aggressive the Act phase should be, how much Observe/Orient time is warranted.

Classify the problem:

- **Type**: `bug-fix` | `feature` | `refactoring` | `architecture` | `performance` | `investigation` | `other`
- **Scope**: `small` (single file) | `medium` (multiple files, one module) | `large` (cross-module, architectural)
- **Risk**: `low` (easily reversible) | `medium` (requires testing) | `high` (production impact, breaking changes, data migration)

Output as a compact header:

```
## Mesh Calibration
Type: [type] | Scope: [scope] | Risk: [risk]
Cycles planned: [N]
```

**Calibration rules:**
- Low-risk, small-scope bug fixes → move fast through Observe/Orient, spend time in Act verifying.
- High-risk, large-scope changes → spend more time in Observe/Orient, be cautious and incremental in Act.
- Investigation-type problems → first cycle is often purely Observe/Orient with an intention to form a plan (this is acceptable — "form a concrete plan" is a valid intention, "investigate" is not).

---

## Phase 1: BDI Layer — Internal State

Before each OODA cycle, explicitly construct the BDI state. This is NOT freeform narrative. Use the structured format below. This structure is not optional — it forces grounding and makes learning visible.

```
### BELIEFS (What is true right now)
- B1: [concrete factual statement about the current state] — Source: [file, error, user statement]
- B2: [another fact] — Source: [evidence]
- B3: [uncertain fact] — Source: [partial evidence] [UNCERTAIN]
```

**Belief rules:**
- Every belief MUST cite its source: a specific file path, error message, test output, user statement, or git history.
- If a belief is uncertain, mark it `[UNCERTAIN]`. The Observe phase MUST prioritize resolving uncertain beliefs.
- Do NOT write beliefs as narrative paragraphs. Each belief is one factual assertion with one source.
- Beliefs can be wrong. That's fine — the mesh corrects them. But they must be explicit so correction is visible.

```
### DESIRES (What we want to achieve)
- D1: [specific, measurable goal]
- D2: [secondary goal if applicable]
```

**Desire rules:**
- Desires must be falsifiable — you can tell whether they've been achieved or not.
- "Fix the bug" is not a desire. "The login endpoint returns 200 with a valid JWT when given an email containing a plus sign" is.
- Desires should be stable across cycles unless the problem itself changes (e.g., new information reveals the real problem is different from what was stated).

```
### INTENTIONS (What we commit to doing this cycle)
- I1: [specific action]
- I2: [specific action]
```

**Intention rules:**
- Intentions must be concrete enough to execute immediately.
- "Investigate the issue" is NOT an intention. "Read `src/middleware/auth.ts` lines 45-80 to check token validation logic" IS.
- "Understand the architecture" is NOT an intention. "Trace the request flow from `routes/api.ts` through middleware to the database call" IS.
- Each intention maps to at least one OODA phase action.

---

## Phase 2: OODA Layer — Execution Loop

### OBSERVE (Gather Ground Truth)

```
### OBSERVE
```

Read the actual code, files, error messages, and logs. Do not reason from memory or assumption — go look.

**Mandatory moves:**
- Read every file mentioned in the problem statement or referenced by beliefs.
- List every file examined with a one-line summary of what was found.
- Surface any contradictions between current beliefs and observed reality.
- If an `[UNCERTAIN]` belief exists, prioritize gathering evidence to resolve it.
- Check recent git history if the problem involves regression ("it used to work").
- Run existing tests if applicable and if the problem is a bug.
- Read error messages against the actual code path, not just the error string.

**Output format:**
```
Observations:
- [file/source]: [what was found] — [confirms/contradicts/updates which belief]
- [file/source]: [what was found]
- ...
```

Do not editorialize in Observe. Report what you see. Save interpretation for Orient.

---

### ORIENT (Analyze Context)

```
### ORIENT
```

Synthesize observations into a coherent model of what is happening and why.

**Mandatory moves:**
- Identify the gap between current state and desired state (connect to Desires).
- Surface the root cause, not just the symptom.
- Trace the execution path from input to failure point (for bugs).
- Identify constraints: backward compatibility, performance requirements, existing patterns, conventions.
- Explicitly state what changed from initial beliefs.
- Ask: "What is expected vs. what is actual?"
- Ask: "What assumption would have to be wrong for the current behavior to be correct?"

**Output:** A brief orientation statement (3-5 sentences) that a senior engineer would recognize as accurate. Then list belief updates:

```
Orientation: [3-5 sentence synthesis]

Belief updates:
- B1: [confirmed / revised / retired]
- B_new: [new belief from observations] — Source: [evidence]
```

---

### DECIDE (Form Plan)

```
### DECIDE
```

Produce a specific, ordered list of changes. No ambiguity. Each change is a commitment.

**Output format:**
```
Decision: [one-sentence summary of the approach]

Changes:
1. [file path] — [what to change] — Risk: [low/med/high]
2. [file path] — [what to change] — Risk: [low/med/high]
...

Verification:
- [how to confirm the changes work — specific test, command, or check]

Rejected alternatives:
- [other approach considered] — [why not chosen]
```

**Decision rules:**
- If multiple approaches exist, state them, pick one, explain why.
- Assess risk of each change independently — a low-risk fix can coexist with a high-risk refactor, and the high-risk part may need to wait.
- Verification must be specific. "Run the tests" is acceptable if there are tests. "Manually verify by calling `POST /login` with email `user+tag@example.com`" is better.
- If the Decide phase reveals that more information is needed, do NOT proceed to Act. Instead, create a new intention to gather that information, update BDI, and loop.

---

### ACT (Execute and Verify)

```
### ACT
```

Execute the changes listed in DECIDE, in order.

**Execution rules:**
- Make one change at a time. Verify each change does not break anything before proceeding to the next.
- For code changes: make the edit, then run relevant tests or verification immediately.
- For investigation actions: read the file, trace the path, report what you find.
- Report results factually — what was done, what was the outcome.

**If `--dry-run` is active:** Do NOT execute any changes. Instead, output the exact changes that would be made in enough detail that a human or future mesh cycle could execute them. Mark the entire Act section:

```
### ACT [DRY RUN — No changes made]

Intended actions:
1. [exact change description with file, line numbers, before/after]
2. [exact change description]
...

Expected outcome: [what would happen if these changes were applied]
```

**Normal execution output format:**
```
Actions taken:
1. [what was done] — Outcome: [success/failure + detail]
2. [what was done] — Outcome: [success/failure + detail]

Verification:
- [test/check performed] — Result: [pass/fail + detail]
```

If any action fails, do NOT continue blindly. Stop, update beliefs with the failure information, and either retry with a corrected approach or proceed to the next cycle with updated BDI state.

---

## Phase 3: Post-Cycle BDI Update

After OODA completes, update the BDI state explicitly. This is where learning becomes visible.

```
### BELIEFS (Updated after Cycle N)
- B1: [confirmed] — still holds
- B2: [revised] — was X, now Y because [evidence]
- ~~B3: [retired] — disproven by [evidence]~~
- B_new: [new belief from this cycle] — Source: [evidence]

### DESIRES
- D1: [achieved ✓ / not yet achieved]
- D2: [achieved ✓ / not yet achieved]

### INTENTIONS (Next cycle, if needed)
- I1: [what remains to be done]
- I2: [new intention based on updated beliefs]
```

**Cycle continuation rules:**
- If ALL desires are achieved → mesh complete. Proceed to Mesh Closing.
- If desires remain unachieved AND more cycles are available → loop back to Phase 2 (OODA) with updated BDI.
- If desires remain unachieved AND no more cycles → proceed to Mesh Closing with `partially-resolved` status.

---

## Phase 4: Mesh Closing

When the mesh completes — either all desires achieved, all cycles exhausted, or early termination:

```
## Mesh Complete

Cycles: [N completed] / [N planned]
Outcome: [resolved | partially-resolved | unresolved]

### What was done
- [summary of concrete actions taken across all cycles]

### What remains
- [any unresolved items with enough context to resume]
- [if unresolved: recommended next steps or decomposition]

### Belief drift
- [how initial understanding differed from final understanding]
- [which initial beliefs were wrong and what replaced them]
- [what was learned that wasn't known at the start]
```

The **belief drift** section is critical — it captures what was learned, not just what was done. This is the mesh's unique value: making the cognitive process visible and the learning transferable.

---

## Multi-Cycle Behavior

When running multiple cycles (`--cycles=N` or when the first cycle does not fully resolve the problem):

1. **Beliefs accumulate and refine.** Each cycle's BDI Update feeds into the next cycle's BDI Layer. New beliefs are added, uncertain beliefs are resolved, disproven beliefs are struck through (~~not deleted~~) so the learning trajectory is visible.

2. **Orient references prior cycles.** The Orient phase in cycle 2+ should explicitly state what changed since the last cycle and why the previous approach was insufficient or what new information emerged.

3. **Early termination rule.** If two consecutive cycles produce (a) no belief updates AND (b) no progress toward any desire, halt immediately. Output:

```
## Mesh Halted — No Progress

Cycles completed: [N] (halted early)
Reason: Two consecutive cycles produced no belief updates and no progress on desires.

This indicates the problem likely needs:
- Decomposition into smaller sub-problems
- Additional information the mesh cannot gather
- A fundamentally different approach

Recommend: [specific recommendation based on what was learned]
```

4. **Cycle cap.** Maximum 5 cycles. If 5 full BDI+OODA cycles have not resolved the problem, the closing should recommend how to decompose the problem into mesh-sized pieces.

---

## Integration with /interrogate

The mesh and the interrogation protocol are complementary:

- Use `/interrogate` first when you need to **understand** a problem from multiple angles — surface tensions, identify hidden assumptions, see what different methodologies reveal.
- Use `/mesh` when you need to **solve** a problem through structured execution — drive toward resolution with disciplined state management.
- The recommended workflow for complex problems: `/interrogate` to map the territory, then `/mesh` to cross it.

If during a mesh cycle the Orient phase reveals that the problem is fundamentally misunderstood, consider recommending `/interrogate` to the user before continuing mesh cycles.

---

## Examples

### Example 1: Bug Fix (single cycle)

```
> /mesh The login endpoint returns 500 when email contains a plus sign

## Mesh Calibration
Type: bug-fix | Scope: small | Risk: low
Cycles planned: 1

### BELIEFS
- B1: The login endpoint is at POST /api/auth/login — Source: user statement
- B2: Emails with plus signs (e.g. user+tag@example.com) cause a 500 error — Source: user statement
- B3: The error is likely in email validation or parsing — Source: [UNCERTAIN]

### DESIRES
- D1: POST /api/auth/login returns 200 with valid JWT for email "user+tag@example.com"

### INTENTIONS
- I1: Read the login endpoint handler to find the email processing path
- I2: Check email validation logic for plus sign handling

### OBSERVE
- src/routes/auth.ts: Login handler calls validateEmail() then queries DB
- src/utils/validation.ts:23: validateEmail uses regex /^[a-zA-Z0-9._-]+@.../
  — The regex does NOT include + in the allowed characters. Contradicts nothing,
  resolves B3: the regex is the problem.

### ORIENT
Orientation: The email validation regex in validation.ts explicitly lists allowed
characters before the @ sign but omits the + character. Plus addressing (RFC 5321)
is valid. The 500 occurs because the validation throws an unhandled exception rather
than returning a validation error, which propagates as an internal server error.

Belief updates:
- B3: [resolved] — The regex at validation.ts:23 rejects + signs

### DECIDE
Decision: Add + to the email validation regex character class.

Changes:
1. src/utils/validation.ts:23 — Add + to regex character class — Risk: low

Verification:
- Run existing auth test suite
- Manual test: POST /api/auth/login with email "test+tag@example.com"

Rejected alternatives:
- Replace regex with a library (e.g. validator.js) — overkill for this fix,
  can be done separately

### ACT
Actions taken:
1. Added + to regex: /^[a-zA-Z0-9._+-]+@.../ in validation.ts:23 — Outcome: success

Verification:
- npm test -- --grep "auth" — Result: pass (12/12 tests)
- POST /api/auth/login with test+tag@example.com — Result: 200 with valid JWT

## Mesh Complete
Cycles: 1/1
Outcome: resolved

### What was done
- Fixed email validation regex to accept plus-addressed emails (RFC 5321 compliant)

### What remains
- Nothing — consider replacing hand-rolled regex with a validation library in the future

### Belief drift
- Initial assumption was "likely in email validation or parsing" (uncertain)
- Actual cause was specifically the regex character class, confirmed in one observation
- Additionally discovered the validation throws rather than returning an error — a
  separate issue worth addressing
```

### Example 2: Multi-cycle refactoring

```
> /mesh --cycles=2 Extract payment processing from the Order model into a service

## Mesh Calibration
Type: refactoring | Scope: medium | Risk: medium
Cycles planned: 2
```

*Cycle 1 would focus on Observe/Orient — reading the Order model, mapping all payment-related methods, identifying dependencies and call sites. Act produces the extraction plan.*

*Cycle 2 would execute the extraction — create the service, move methods, update call sites, run tests.*

### Example 3: Dry run analysis

```
> /mesh --dry-run Should we switch from REST to GraphQL for the mobile API?

## Mesh Calibration
Type: architecture | Scope: large | Risk: high
Cycles planned: 1
```

*The mesh would run full BDI+OODA but the Act phase outputs intended changes and recommendations without making any modifications. Belief drift captures what was learned about the current API surface, mobile client needs, and trade-offs.*
