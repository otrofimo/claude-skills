---
description: >
  Grill a plan by interrogating a council of domain experts instead of the user.
  An interrogator walks the decision tree and asks the whole frontier each round;
  the council answers in character and pushes back; the loop runs until every
  decision is settled and a spec falls out. Prefers the Codex MCP as the council;
  otherwise two Fable-class agents take turns asking and answering. Use when the
  user has a rough plan, design, or idea that needs stress-testing before commitment.
argument-hint: "[--board=<council>] [--rounds=N] [--transport=codex|agents|solo] [--dry-run] [--list] <plan>"
---

# Council Grill — Adversarial Interrogation Until The Spec Falls Out

Two skills fused:

- **Grill-me** (Matt Pocock) — interview relentlessly about a plan until shared
  understanding, walking down each branch of the decision tree and resolving
  dependencies between decisions one by one.
- **Council** — a virtual advisory board of domain experts, Feynman always present
  to ask first-principles questions.

Normally grill-me interrogates *you*. Here the interrogator interrogates *the
council*. You are the referee, not a participant: you own the decision-tree
ledger, you decide when an answer counts as settled, and you decide when the bar
is met. The council does not get to declare itself finished.

**The cardinal rule:** the loop terminates on the *bar*, not on the round count
and not on the council running out of things to say. If the bar is not met when
the round cap hits, say so plainly and hand back the unsettled nodes. A spec
emitted over unsettled nodes is a protocol violation.

---

## Handling Arguments

Parse `$ARGUMENTS`:

1. **`--list`**: Display the board roster and transport table, then exit.
2. **`--board=<name>`**: Which council answers. Default `engineering`.
3. **`--rounds=N`**: Round cap (default 6, hard cap 10). The cap is a circuit
   breaker, not a target — stop the moment the bar is met.
4. **`--transport=codex|agents|solo`**: Force a transport. Default: auto-detect
   in the order below.
5. **`--dry-run`**: Build the decision tree and print Round 1's frontier, then
   stop. No council is convened, no external calls are made.
6. **Everything else**: The plan, design, or idea to grill.

If no plan is supplied, ask the user for one. Do not invent a plan to grill.

---

## Transport Selection

The council must run on a *different* model from the interrogator wherever
possible. Two instances of the same model agreeing with each other is not a
grilling, it is an echo. Select in this order and **announce which transport you
selected and why** before Round 1.

### 1. Codex MCP (preferred)

Check the available tool list for a Codex MCP server — typically
`mcp__codex__codex` and `mcp__codex__codex-reply`. If you cannot see them
directly, run `ToolSearch` with `query: "codex"`. **Read the actual parameter
schema before calling** — Codex's MCP surface has changed across releases, so do
not assume argument names from this document.

The shape you are relying on:

- `codex` starts a conversation from a `prompt` and returns a conversation id
  (`conversationId` / `sessionId` depending on version).
- `codex-reply` continues that same conversation given the id and a new `prompt`.

This is why Codex is preferred: the council keeps its own memory across rounds,
so it can be caught contradicting what it said in Round 2. Capture the id from
the first call and thread it through every subsequent round.

Open the conversation with the **council charter** (below) plus the plan. Every
later round is a `codex-reply` carrying only that round's frontier questions.

If the server is present but a call fails (not installed, sandbox denial, auth
error), report the actual error, then fall back to transport 2. Do not retry a
denied call verbatim.

### 2. Two-agent relay (fallback)

Spawn two subagents via the `Agent` tool with `model: "fable"` — or the strongest
model available if Fable-class is not offered:

- **Interrogator agent** — holds the grill-me protocol and the plan. Produces
  each round's frontier questions.
- **Council agent** — holds the council charter. Answers in character.

Continue each agent across rounds with `SendMessage` to its name/id so its
context survives; a fresh `Agent` call restarts it from nothing and the council
forgets what it already conceded.

You remain the referee between them. Never let the two agents talk directly
without you scoring the exchange — an interrogator that accepts a vague answer
and a council that gives one will converge on a comfortable plan in three rounds,
which is the exact failure this skill exists to prevent.

### 3. Solo (degraded)

No MCP, no subagents. You play both seats yourself. Announce this clearly:
`[SOLO MODE — interrogator and council are the same model; adversarial pressure
is reduced]`. Then enforce the separation mechanically:

- Write the frontier questions **in full** before writing any answer.
- Answer them **without** editing the questions.
- Score the answers in a separate pass, against the rubric, as if a stranger
  wrote them.

---

## Boards

Mirrors `/council`. Feynman sits on every board.

| Board | Seats |
|-------|-------|
| `engineering` (default) | Lamport, Jeff Dean, Torvalds, Ken Thompson |
| `design` | Ive, Norman, Kelley, Jobs, Rams |
| `business` | Munger, Dalio, Cuban, Buffett, Graham |
| `agentic` | Engineering + Huntley, Yegge, Willison, Karpathy |
| `product` | Jobs, Norman, Dunford, Fried |
| `refactoring` | Beck, Fowler, Dave Thomas |
| `security` | Schneier, Hunt, Hyppönen, Ormandy, Ptacek |
| `behavioral` | Kahneman, Tversky, Gigerenzer, Simon, Duke |
| `mathematics` | Grassmann, Rota, Pólya, Euler, Grothendieck, Noether |
| `systems` | Meadows, Senge, Johnson, Edison, Luhmann |

**Feynman's role here is inverted.** In `/council` he opens. In a grill he sits on
the *answering* side and refuses to let a vague question through: when a question
is malformed, he answers it with a sharper question rather than a guess. A
Feynman counter-question is a legitimate round outcome — record it and let the
interrogator reformulate. That is the taking-turns dynamic, and it is the point.

---

## The Decision Tree Ledger

Before Round 1, decompose the plan into decision nodes. This ledger is the state
of the grill; carry it forward and reprint it after every round.

```
### LEDGER — Round N
| # | Decision | State | Depends on | Resolution |
|---|----------|-------|------------|------------|
| D1 | [the decision to be made] | SETTLED | — | [what was decided, one line] |
| D2 | [decision] | OPEN | D1 | — |
| D3 | [decision] | BLOCKED-USER | — | needs a fact only the user has |
| D4 | [decision] | DEFERRED | D1 | trigger: [what makes this live again] |
```

States:

- **OPEN** — not yet answered, prerequisites settled or not.
- **SETTLED** — answered, with a reason, and nothing in it rests on an
  unverified assumption.
- **BLOCKED-USER** — the answer is a *fact about the user's world*, not a
  judgment. See the routing rule below.
- **DEFERRED** — deliberately not decided now, with a named trigger that makes it
  live again. "We'll figure it out later" is not a trigger. "When a second tenant
  is onboarded" is a trigger.

New nodes appear mid-grill. That is expected — a good answer usually spawns two
children. The tree is done growing when a round produces no new nodes.

### Routing rule — facts to the user, judgment to the council

The council knows how to think. It does not know your codebase, your traffic,
your deadline, your team, or your customers. Any question whose answer is a fact
about the user's actual situation goes to the **user**, never to the council. If
you route it to the council, the council will invent an answer, the spec will be
built on that invention, and the grill will have manufactured a false consensus.

- Fact → `BLOCKED-USER`. Batch these and ask the user directly, in plain language,
  outside the council transcript.
- Judgment, trade-off, risk, ordering, technique → council.

If the user is unavailable, mark the node `BLOCKED-USER` and carry it into the
spec's open-risk section as an assumption. Never silently promote an assumption
to a decision.

---

## The Round Protocol

Each round asks **the whole frontier** — every OPEN node whose dependencies are
already SETTLED. Not one question at a time; not a question that hinges on an
answer you have not heard yet. If the frontier is empty but OPEN nodes remain,
the tree has a cycle: break it by picking the node with the fewest dependents,
making the smallest reasonable assumption, and labeling it explicitly.

### Round output format

```
## Round N — Frontier (D2, D5, D7)

**Interrogator:**
Q-D2: [question, naming the decision it resolves]
Q-D5: [question]
Q-D7: [question]

**Council:**
**[Member]:** [answer, in voice, taking a position]
**[Member]:** [answer — disagreeing where their philosophy actually differs]
**Feynman:** [counter-question, or the plain-language restatement that exposes
the hand-waving]

**Referee scoring:**
- D2 → SETTLED: [the decision, one line]
- D5 → OPEN: answer was directional, not a decision. Re-asking with the
  ambiguity named.
- D7 → BLOCKED-USER: depends on [fact], asking the user.
- New: D8 [spawned by the answer to D2]
```

### Scoring rubric — what counts as settled

An answer settles a node only if all four hold:

1. **It takes a position.** "It depends on X" is not an answer; it is a request
   to split the node on X. Split it.
2. **It gives a reason that could have come out the other way.** A reason that
   would justify any option justifies none.
3. **It names what it gives up.** Every real decision costs something. An answer
   with no cost is a slogan.
4. **It rests on nothing unverified.** If it assumes a fact, that fact becomes a
   `BLOCKED-USER` node before the parent can settle.

Fail any of the four → re-ask **once**, naming precisely which of the four
failed. Fail again → `BLOCKED-USER` or `DEFERRED`. Do not ask a third time; a
council that has missed twice does not have the answer, and a third round of
pressure produces confabulation, not insight.

### Anti-collapse rules

- **Never accept unanimity in a round without probing it.** If every member
  agrees on a contested design decision, ask the member whose philosophy is
  furthest from the consensus to argue the opposite case. Record whether it
  holds up.
- **Quote the council against itself.** If a Round 4 answer contradicts a Round 2
  answer, put both in front of it and make it pick.
- **Do not soften the question to get an answer.** Re-asking means naming the
  ambiguity, not lowering the bar.

---

## The Bar — When The Grill Is Fulfilled

The grill is fulfilled when **all** of these hold. Print this checklist verbatim
with each box scored before emitting a spec.

```
### BAR CHECK
[ ] Every node is SETTLED, DEFERRED (with a trigger), or BLOCKED-USER (recorded
    as an explicit assumption)
[ ] No SETTLED node rests on an unverified assumption
[ ] The last round produced no new nodes
[ ] Remaining disagreement is recorded as a tension with a decision made, not as
    an open question
[ ] The council can restate the plan with no daylight between members on what is
    being built
```

The last box is a real test, not a formality: ask the council, in one final turn,
to state in two sentences what is being built and what is deliberately not being
built. If the restatements diverge, you did not reach shared understanding — you
reached politeness. Reopen the node they diverge on.

If the round cap hits before the bar is met, stop and report:

```
### GRILL INCOMPLETE — cap reached at round N
Settled: [count]  Open: [list]  Blocked on user: [list]
No spec emitted. The unsettled nodes are the deliverable.
```

That is a legitimate, useful outcome. An incomplete grill that names what is
still unknown beats a spec that papers over it.

---

## The Output — The Spec

Only once the bar is met:

```markdown
## Spec: [name]

### What we are building
[Two or three sentences. The council's restatement, reconciled.]

### Not building
- [explicit non-goal] — [why it was ruled out, and by whom]

### Decisions
| # | Decision | Why | Gives up | Pushed back |
|---|----------|-----|----------|-------------|
| D1 | [decision] | [reason] | [cost] | [member who dissented, and their case] |

### Assumptions we did not verify
- [assumption] — [what breaks if it is wrong] — [how to check it cheaply]

### Deferred
- [decision] — trigger: [the event that makes it live again]

### Acceptance criteria
- [observable, checkable statement — not "works well"]

### First slice
[The smallest change that makes the next decision cheaper to get right.]
```

Keep the dissent column. A spec that records who disagreed and why is auditable
six months later; a spec that reads as unanimous is not.

---

## Example (abridged, `--board=engineering`, Codex transport)

> `/grill We're going to add a job queue so the API stops timing out on report generation.`

```
Transport: Codex MCP (mcp__codex__codex, conversation 01J8Z…) — council runs on a
different model from the interrogator.

### LEDGER — Round 0
| # | Decision | State | Depends on |
|---|----------|-------|------------|
| D1 | Is the timeout actually caused by report generation? | OPEN | — |
| D2 | Queue vs. making generation fast enough to stay inline | OPEN | D1 |
| D3 | Which queue | OPEN | D2 |
| D4 | What the client sees while the job runs | OPEN | D2 |
```

**Round 1 — Frontier (D1)**

**Interrogator:** Q-D1: What evidence establishes that report generation is the
cause of the timeouts, rather than a symptom of contention that a queue would
merely relocate?

**Jeff Dean:** You need the latency distribution, not the mean. If p50 is 200ms
and p99 is 30s, that is a tail problem and a queue moves it rather than fixing
it. Get the percentiles per endpoint before you build anything.

**Torvalds:** And if nobody has actually profiled this, you are about to add a
whole distributed subsystem because of a hunch. That is how you end up with two
problems.

**Feynman:** Hold on — what is timing out? The user's browser, a load balancer, a
database statement timeout? Those are three different bugs and only one of them
is about reports.

**Referee scoring:**
- D1 → BLOCKED-USER: the council correctly refuses to answer without the latency
  data and the timeout layer. Both are facts about the user's system. Asking the
  user.
- New: D5 "Which layer is emitting the timeout" (fact → BLOCKED-USER)

*(The grill continues once the user supplies the two facts. D2 cannot be reached
until D1 settles — asking "which queue" now would be asking a question whose
prerequisites are unresolved, which the protocol forbids.)*

Note what happened: the first round did not produce a plan, it produced two
measurements. That is a successful round.

---

## Failure Modes To Watch In Yourself

- **Emitting the spec because the transcript got long.** Length is not the bar.
- **Marking a node SETTLED on a well-phrased answer with no position in it.**
  Eloquence reads as resolution. Score against the four criteria, not vibes.
- **Routing a fact to the council.** It will answer. The answer will be fiction.
- **Letting the council grill the user instead.** The user answers facts. The
  council answers judgment. Keep the seats straight.
- **Running solo without saying so.** A single model wearing two hats produces
  agreement that looks like convergence. Label it every time.
