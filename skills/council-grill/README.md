# Council Grill — Interrogate the Council Until the Spec Falls Out

Two ideas fused:

- **[Grill-me](https://www.aihero.dev/skills-grill-me)** (Matt Pocock) — interview
  relentlessly about a plan until shared understanding, walking down each branch
  of the decision tree and resolving dependencies one by one.
- **[Council](../council/)** — a virtual advisory board of domain experts, with
  Feynman always present to ask first-principles questions.

Grill-me normally interrogates *you*. Council Grill interrogates *the council*.
An interrogator asks; the council answers and pushes back; Claude referees and
keeps the ledger. The loop runs until the grill-me bar is met, and then a spec
falls out.

## Usage

```
/grill <plan>                              # engineering board, auto transport
/grill --board=security <plan>             # pick the board
/grill --rounds=8 <plan>                   # raise the round cap (default 6, max 10)
/grill --transport=agents <plan>           # force a transport
/grill --dry-run <plan>                    # decision tree + round 1 questions only
/grill --list                              # boards and transports
```

## Who answers

The council must run on a *different* model from the interrogator. Two instances
of the same model agreeing with each other is not a grilling, it is an echo.

| Transport | Council runs on | Selected when |
|-----------|-----------------|---------------|
| `codex` | The Codex MCP server (`mcp__codex__codex` + `codex-reply`) | Codex MCP tools are available |
| `agents` | Two Fable-class subagents — one interrogator, one council | No Codex MCP; `Agent` tool available |
| `solo` | Claude playing both seats, clearly labelled | Nothing else available |

Codex is preferred because the conversation id threads through every round, so
the council keeps its own memory and can be caught contradicting what it said
three rounds ago.

## Boards

Same roster as `/council`: `engineering` (default), `design`, `business`,
`agentic`, `product`, `refactoring`, `security`, `behavioral`, `mathematics`,
`systems`.

**Feynman's role is inverted here.** In `/council` he opens. In a grill he sits
on the answering side and refuses to let a vague question through — he answers a
malformed question with a sharper one instead of guessing. A counter-question is
a legitimate round outcome.

## How a round works

Each round asks the **whole frontier** — every open decision whose prerequisites
are already settled. Never a question that hinges on an answer nobody has given
yet.

An answer settles a decision only if it takes a position, gives a reason that
could have come out the other way, names what it gives up, and rests on nothing
unverified. Miss any of the four and the question is re-asked once with the
failure named. Miss twice and it is deferred or escalated — a third round of
pressure produces confabulation, not insight.

## Facts to the user, judgment to the council

The council knows how to think. It does not know your codebase, your traffic,
your deadline, or your customers. Any question whose answer is a fact about your
actual situation is routed to **you**, not the council. Route a fact to the
council and it will invent an answer, the spec will be built on that invention,
and the grill will have manufactured a false consensus.

## The bar

The grill is fulfilled only when every node is settled, deferred with a named
trigger, or explicitly blocked on you; nothing settled rests on an unverified
assumption; the last round spawned no new nodes; remaining disagreement is
recorded as a tension with a decision made; and the council can restate what is
being built with no daylight between members.

If the round cap hits first, no spec is emitted — the unsettled nodes are the
deliverable. An incomplete grill that names what is still unknown beats a spec
that papers over it.

## The output

A spec: what is being built, what is explicitly not, a decision table with a
*gives up* column and a *pushed back* column, unverified assumptions with what
breaks if they are wrong, deferred decisions with their triggers, acceptance
criteria, and the first slice.

The dissent column stays in. A spec that records who disagreed and why is
auditable six months later; one that reads as unanimous is not.

## Example

```
/grill We're going to add a job queue so the API stops timing out on report generation.
```

Round 1 does not produce a plan. It produces two measurements — Jeff Dean asks
for the latency distribution rather than the mean, Torvalds points out nobody has
profiled it, and Feynman asks which layer is actually emitting the timeout.
Both are facts about your system, so both are routed back to you, and "which
queue" is never asked because its prerequisite is unresolved.

That is a successful round.
