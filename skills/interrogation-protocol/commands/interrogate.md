---
description: >
  Run cognitive lens interrogation protocols against any problem. Each lens is an operational
  method — not a persona simulation. Standing lenses (Feynman, Shannon, Dijkstra, Taleb)
  always run. Extended lenses invoked by name or relevance signal. Use when the user wants
  multi-framework analysis, asks for interrogation, or wants a problem stress-tested.
argument-hint: "[lens1 lens2 ...] <problem>"
---

# Interrogation Protocol — Cognitive Lens Analysis

You are running **operational interrogation protocols**, not persona simulations.

The distinction matters:

- **Persona simulation** asks: "What would X say?" — produces mimicry, confabulated freely when the domain is novel. It's a costume, not a method.
- **Operational interrogation** asks: "What does X *do* when they think?" — produces a transferable method: moves, questions, and failure-mode hunts that apply to any domain, including ones the original thinker never encountered.

When running a lens:

- Apply its **moves** to the actual problem
- Ask its **signature questions** of the actual content
- Hunt its **characteristic failure modes** in the current reasoning
- Output findings in first person, attributed to the lens (e.g. "**Shannon:** The channel capacity question here is...")
- **Do not perform the person; perform the protocol**

## Usage

```
/interrogate <problem>                    # Standing lenses (Feynman, Shannon, Dijkstra, Taleb)
/interrogate brenner popper <problem>     # Named lenses only
/interrogate --all <problem>              # All lenses
/interrogate --list                       # Show available lenses
```

## Handling Arguments

Parse the `$ARGUMENTS` variable:

1. **If `--list` is present**: Display the lens catalog and exit
2. **If `--all` is present**: Run all standing + extended lenses
3. **If named lenses are present** (lowercase words before the question): Run only those lenses
4. **If no lenses specified**: Run the four standing lenses plus any extended lenses the problem clearly warrants (use domain signals below)
5. **Everything else**: Treat as the problem to interrogate

---

## Standing Lenses

These four run on every invocation unless specific lenses are named.

---

### Feynman — First Principles & Physical Intuition

**Orientation:** Strip every problem to its mechanical reality. Complexity is often a symptom of not yet understanding. Explanations that require jargon are placeholders for understanding, not instances of it.

**Moves:**

- Decompose the problem to its most primitive components
- Demand a mechanistic account, not just a correlational or formal one
- Test every abstraction with a concrete analogy — if no analogy works, the abstraction may be hollow
- Ask what a careful, curious person with no domain training would need to know to follow this argument

**Signature Questions:**

- What is *actually* happening here, at the lowest level we can reach?
- Can this be explained without using any technical vocabulary?
- If the jargon were removed, what claim would remain?
- What's the simplest possible system that would exhibit this behavior?
- Where does the analogy break down, and what does that tell us?

**Failure Modes to Hunt:**

- Jargon substituting for mechanism (words that point to the thing without explaining it)
- Correlation presented as causation
- Complexity deployed as authority
- Absence of physical or mechanical grounding in formally correct but hollow arguments
- "It works" as a terminal explanation

---

### Shannon — Information & Signal

**Orientation:** Every communication, every decision, every system has an information-theoretic structure. Find it. Most problems contain far more noise than signal. The question is always: what is the minimum description that preserves what matters?

**Moves:**

- Identify the actual information content vs. the volume of material
- Find redundancy — what is being said multiple times in different forms?
- Identify the degrees of freedom in the problem — how many independent dimensions are actually present?
- Ask what would be lost in maximal compression

**Signature Questions:**

- What is the actual information content here, measured in bits?
- What is signal and what is noise?
- If we had to compress this to 20% of its current size without losing anything critical, what would we cut?
- What are the independent dimensions of this problem — how many things are actually varying?
- Where is channel capacity being wasted?
- What does the noise floor look like?

**Failure Modes to Hunt:**

- High bandwidth communication of low-information content
- False precision (many decimal places on poorly understood quantities)
- Redundancy mistaken for corroboration
- Conflating form with content (the message is not the medium)
- Missing the implicit encoding choices that shape what can be said at all

---

### Dijkstra — Formal Correctness & Precision

**Orientation:** Programs — and arguments — should be correct by construction, not empirically verified into confidence. Precision in language is not pedantry; it is the precondition for knowing what you're actually asserting. A system that works most of the time is a system we do not yet understand.

**Moves:**

- Demand precise definitions for all key terms before accepting any argument
- Locate the abstraction boundary and test whether it leaks
- Ask whether correctness here is provable or merely plausible
- Find the invariant — what must remain true for this system to function?
- Identify unstated assumptions baked into the specification

**Signature Questions:**

- Is this term precisely defined? What does it mean, exactly?
- Where does this abstraction leak — what does it hide that matters?
- Is this correct, or does it merely pass the tests we thought to write?
- What is the invariant this system must maintain?
- What does the specification actually say vs. what we *want* it to say?
- Can we state a proof sketch, or are we relying entirely on empirical confidence?

**Failure Modes to Hunt:**

- Undefined or vaguely defined terms doing load-bearing work
- Testing as a substitute for understanding (high test coverage != correct)
- Specification that describes desired outputs without constraining the space of valid behaviors
- Abstraction boundaries treated as opaque when they are in fact transparent to failure
- "Works in practice" as argument without bounding the domain of practice

---

### Taleb — Tail Risk & Fragility

**Orientation:** The absence of evidence is not evidence of absence. Most models are fit to the data we have, which excludes the tail events that matter most. The central question is not the expected case — it is whether the system survives the case that wasn't in the spreadsheet.

**Moves:**

- Invert: what is the worst plausible outcome, and what is its cost?
- Identify the implicit distribution assumptions — are fat tails being treated as thin?
- Ask whether this system is fragile, robust, or antifragile under stress
- Hunt for hidden optionality and hidden exposure
- Find the thing that is not in the model

**Signature Questions:**

- What's the tail risk here — what happens in the 1-in-100 or 1-in-1000 case?
- What is not being modeled? What has been excluded from the distribution?
- If this assumption is wrong in the most damaging direction, what is the exposure?
- Is this system fragile (harms from disorder), robust (indifferent), or antifragile (benefits)?
- Where are we betting on forecasting accuracy in a domain where forecasting is unreliable?
- What would have to be true for this to blow up catastrophically?

**Failure Modes to Hunt:**

- Gaussian assumptions applied to fat-tailed phenomena
- Overconfidence in models that were fit to data excluding tail events
- Symmetric treatment of asymmetric payoffs
- Mistaking low historical frequency for low probability
- Fragile optima — systems optimized for average performance that fail catastrophically at extremes
- Normalcy bias (anchoring probability estimates to recent experience)

---

## Extended Lenses

Invoked by name or when the problem domain clearly calls for them.

---

### Von Neumann — Strategic Structure & Adversarial Dynamics

**Orientation:** Most problems with multiple actors are strategic problems. Players optimize, and their optimization changes the environment that other players optimize in. The question is never just "what should I do?" — it is "what will others do, given that they're watching what I do?"

**Moves:**

- Model all players, their action spaces, and their objective functions
- Find the equilibrium — what does the stable state look like?
- Identify dominant strategies and dominated strategies
- Ask what changes if opponents know your strategy
- Test whether the system is incentive-compatible

**Signature Questions:**

- Who are the players and what are they each optimizing?
- What is the Nash equilibrium of this situation?
- Does any player have a dominant strategy?
- If our strategy were known to all opponents, would we still choose it?
- Where are the incentives misaligned with stated goals?
- What does the adversary do in the case we haven't planned for?

**Failure Modes to Hunt:**

- Single-player analysis of multi-player games
- Ignoring the strategic response to your own actions
- Incentive incompatibility (system design assumes agents will behave against their interests)
- Missing adversarial actors
- Treating cooperative outcomes as stable when defection is individually rational

---

### Munger — Mental Models & Second-Order Effects

**Orientation:** Every discipline is a different lens on reality, and most problems yield their secrets to whichever lens wasn't first applied. Incentives explain most of what looks like irrationality. The right question is often not the one being asked.

**Moves:**

- Reach for a mental model from a different domain and apply it
- Invert the problem: instead of asking how to achieve X, ask what would reliably destroy X
- Identify what incentives are actually operating (vs. stated intentions)
- Follow effects out two and three steps

**Signature Questions:**

- What framework from a completely different discipline applies here?
- What would reliably make this fail? (Inversion)
- What incentives are actually operating, and do they align with stated goals?
- What are the second and third-order consequences?
- What is the simplest explanation that accounts for all the observed behavior?
- What cognitive bias is most likely distorting the current analysis?

**Failure Modes to Hunt:**

- Single-framework analysis of multi-dimensional problems
- Ignoring incentive structures (assuming stated motives are real motives)
- First-order-only thinking
- Availability bias masquerading as base rate reasoning
- Missing the simpler explanation

---

### Brenner — Hypothesis Structure & Experimental Design

**Orientation:** Understanding is the ability to reconstruct. Reality has a generative grammar — the goal is to find it, not to describe it. Enumerate all hypotheses before touching evidence. Design to exclude, not to confirm. Hypothesis kill rate is a primary metric.

**Moves:**

- Force explicit enumeration of all current hypotheses before any evidence is discussed
- Design the discriminating experiment — the one result that would most cleanly differentiate between hypotheses
- Hunt the third alternative: what if all current hypotheses are wrong?
- Identify the assumption that is not being questioned
- Apply the operator algebra: level-split, recode, invariant-extract, exclusion-test, cross-domain, paradox-hunt, theory-kill

**Signature Questions:**

- What are *all* the hypotheses currently on the table?
- Which experiment would be most discriminating — most likely to kill the most hypotheses with the least work?
- What if both current leading hypotheses are wrong? What else could produce this observation?
- What assumption is everyone in this discussion accepting without examination?
- What is the forbidden pattern — the observation that our theory says cannot happen?
- What would the observation look like if we were completely wrong?

**Failure Modes to Hunt:**

- Premature convergence on a hypothesis before alternatives are enumerated
- Confirmation-seeking experimental design (testing what we expect rather than what would surprise us)
- Conflating correlation with generative mechanism
- Missing the null: absence of the predicted effect is treated as noise rather than signal
- Assumption laundering: baking in contested assumptions as background facts

---

### Popper — Falsifiability & Critical Rationalism

**Orientation:** The content of a theory is measured by what it forbids. A theory that is compatible with all observations explains nothing. Science proceeds not by confirming hypotheses but by boldly conjecturing and rigorously attempting refutation. Every theory that survives refutation attempts is corroborated, not proven.

**Moves:**

- Find the falsifiable content: what observations would the theory prohibit?
- Design the decisive test: what result would force theory revision?
- Distinguish genuine falsifiability from ad-hoc immunization
- Ask what would change our minds — if nothing would, the position is not scientific but metaphysical
- Identify bold conjectures vs. cautious, unfalsifiable hedging

**Signature Questions:**

- What would falsify this claim? What observations would force us to abandon it?
- Is this theory falsifiable, or has it been immunized against refutation by successive ad hoc modifications?
- What is the bold conjecture here — the claim that sticks its neck out?
- If the theory is wrong, what would we see? Is that observation distinguishable from noise?
- Are we looking for confirmation or for refutation?

**Failure Modes to Hunt:**

- Unfalsifiable claims dressed as empirical ones
- Ad hoc modifications that save a theory from each new contrary observation
- Induction: "this has worked before therefore it will work again" as argument
- Confirmationism: gathering supporting evidence while ignoring disconfirming evidence
- Excessive hedging that makes claims compatible with any outcome

---

### Karpathy — Empirical Grounding & Practical System Behavior

**Orientation:** Theory predicts, practice reveals. Before optimizing, understand. Before understanding, look. Most claims about AI and complex systems are not wrong in principle — they're wrong in practice, and the difference only shows up when you actually run the thing and instrument it.

**Moves:**

- Demand empirical grounding: what do the actual numbers say?
- Check the data before the model
- Benchmark before optimizing — establish the baseline
- Trace failure modes empirically rather than theoretically
- Ask what actually happens vs. what the architecture implies should happen

**Signature Questions:**

- Have we actually run this and looked at the outputs?
- What do the loss curves / latency numbers / error rates actually show?
- Did we check the data, or are we assuming it's clean?
- What does the failure mode look like in practice?
- What's the actual throughput / latency / accuracy vs. the theoretical claim?
- What would we see if we added instrumentation right now?

**Failure Modes to Hunt:**

- Theorizing about system behavior without empirical measurement
- Premature optimization before the baseline is established
- Assuming data quality without checking
- Architecture cargo-culting (applying patterns that worked elsewhere without validating fit)
- Confusing benchmark performance with real-world performance

---

### Hipp — Radical Simplicity & Long-Term Engineering

**Orientation:** The best architecture is the one you can hold in your head. Dependencies are liabilities, not assets. A system that will still work in 20 years looks nothing like a system designed for next quarter. Every external dependency is a bet that someone else will maintain their code to your standards, on your timeline, forever. That bet almost always loses.

**Moves:**

- Count dependencies and question each one — what does it provide that couldn't be done in 200 lines of purpose-built code?
- Ask what happens to this system in 10 years with zero maintenance
- Demand a single-file or single-deployment mental model — if you can't explain the entire system's operation, it's too complex
- Test whether the architecture serves the problem or serves the developer's resume
- Identify where "best practices" are adding complexity without adding value

**Signature Questions:**

- How many dependencies does this have, and what happens when any one of them breaks, changes API, or is abandoned?
- Can one person understand this entire system? If not, why not, and is that complexity essential or accidental?
- What would this look like if it had to ship as a single file?
- Will this still compile and run correctly in 10 years without any changes?
- What is the total transitive dependency count, and has anyone audited all of it?
- Is this architecture solving the user's problem or the developer's boredom?

**Failure Modes to Hunt:**

- Dependency-heavy designs where each dependency solves a trivial problem (pulling in a framework to avoid writing 50 lines)
- Architecture astronautics — abstractions and indirections that exist for "flexibility" no one will use
- Assuming external services and libraries will be maintained indefinitely
- Choosing the popular tool over the correct tool
- Test suites that test the framework rather than the logic
- Build systems more complex than the software they build
- Confusing "industry standard" with "appropriate for this problem"

---

### Wolfram — Computational Structure & Emergent Complexity

**Orientation:** Complex behavior does not require complex causes. Simple rules iterated produce irreducible complexity. Before asking why a system behaves as it does, ask what computation it is performing. Some systems cannot be understood by analysis — they can only be understood by running them.

**Moves:**

- Model the system as a computation: what are the elementary operations, what are the state transitions?
- Ask whether the behavior is computationally irreducible — can it be predicted without simulation?
- Find the minimal rule set that generates the observed behavior
- Look for pattern in rule space, not just in output space
- Question whether an analytical solution is possible or whether the system must simply be run

**Signature Questions:**

- What computation is this system actually performing?
- Is this behavior computationally irreducible — is there a shortcut, or must we simulate it?
- What is the minimal rule set that would generate this complexity?
- Are we looking for an analytical solution to an irreducible process?
- What does this look like if we model it as a cellular automaton or similar minimal substrate?

**Failure Modes to Hunt:**

- Assuming complex behavior requires complex causes
- Seeking closed-form analytical solutions to computationally irreducible processes
- Missing emergence: attributing to intent or design what arises from simple rule iteration
- Overfitting explanatory models to outputs rather than finding the generative rules

---

### Grassmann — Algebraic Structure & Geometric Generalization

**Orientation:** Every geometric intuition has an algebraic structure, and every algebraic structure has geometric content. The question is always: what is the underlying structure, and how does it generalize? Coordinates are a choice, not a fact — and that choice hides as much as it reveals.

**Moves:**

- Ask what algebraic structure underlies the current geometric or computational object
- Generalize: how does this extend to n dimensions, or to an arbitrary field?
- Test coordinate-independence: does the claimed property depend on the specific basis chosen, or does it hold structurally?
- Look for the exterior product / wedge product structure: what orientation and magnitude are being lost in projection?

**Signature Questions:**

- What is the algebraic structure underlying this object?
- Does this property depend on the coordinate system, or is it intrinsic?
- What is being lost when we project to a lower-dimensional representation?
- How does this generalize? Does the argument hold in the general case or only for the specific instance?
- What is the anti-symmetric / orientational content that scalar representations miss?

**Failure Modes to Hunt:**

- Premature coordinate attachment (mistaking a computational convenience for a structural fact)
- Over-specialization: proving a result for a specific case when the structure implies it generally
- Missing geometric content in algebraic representations
- Dimension-specific reasoning that fails to generalize

---

### Rota — Combinatorial Structure & Mathematical Phenomenology

**Orientation:** Mathematics is not its formalism — it is what the formalism is pointing at. Every mathematical object has combinatorial content, and that content is often where the real understanding lives. Formal correctness and genuine understanding are not the same thing.

**Moves:**

- Find the combinatorial structure underneath the formal presentation
- Ask what the mathematical object is *about*, not just how it is defined
- Question foundational assumptions: what are we taking for granted before the formalism begins?
- Distinguish the phenomenon from the formalization: what is actually happening before we impose notation?

**Signature Questions:**

- What is the combinatorial content of this object?
- What is the formalism pointing at — what is the phenomenon behind the symbol?
- What foundational assumption is being made before the first line of the argument?
- Is the proof illuminating or merely correct? (Can we see *why* it's true, not just *that* it is?)
- What would a mathematician who distrusted formalism say about this object?

**Failure Modes to Hunt:**

- Formalism without understanding (correct proofs that explain nothing)
- Missing the phenomenon behind the notation
- Treating foundational choices as inevitable rather than conventional
- Combinatorial structure hidden by inappropriate notation

---

### Pascal — Expected Value & Asymmetric Bets

**Orientation:** Uncertainty is not a reason to suspend judgment — it is the domain in which judgment operates. Every decision under uncertainty is a wager, and the question is whether it is a good one. Infinite consequences demand special treatment. Expected value is the minimum framework; ignoring it is not humility, it's innumeracy.

**Moves:**

- Compute expected value: probability x payoff, across all outcomes
- Identify asymmetric bets: where small probability x large payoff changes the calculus
- Ask what would need to be true for the low-probability outcome to warrant action
- Apply Pascal's Mugging test: is an infinite or catastrophic claimed consequence being used to swamp ordinary reasoning?

**Signature Questions:**

- What is the expected value of this choice? (Probability x payoff for each outcome)
- Is there an asymmetric bet here — a small probability but disproportionate consequence?
- What probability assignment would change the decision?
- Are we ignoring a low-probability outcome because it feels improbable, or because the expected value calculation actually supports ignoring it?
- Is an extreme claimed consequence being used to dominate the analysis in a way that resists scrutiny?

**Failure Modes to Hunt:**

- Ignoring expected value entirely and choosing by outcome valence alone
- Symmetric treatment of asymmetric probability-payoff structures
- Pascal's Mugging: being moved by extreme claimed consequences without probability calibration
- Probability neglect: making decisions based on whether an outcome is possible rather than how likely
- Omitting catastrophic low-probability outcomes from the calculation

---

### Kant — Universalizability & The Limits of Reason

**Orientation:** Every action embeds a maxim, and the test is whether that maxim can be universalized. Pure reason has limits — it produces antinomies when it exceeds them. The structures we bring to experience are not given by the world; they are the conditions of possible experience.

**Moves:**

- Universalize the maxim: what if everyone acted this way? Would the practice self-destruct?
- Identify the synthetic a priori assumptions: what is being taken as both necessarily true and informative about the world?
- Test whether the argument is exceeding the limits of reason — producing antinomies or paralogisms
- Ask what is being treated as a thing-in-itself when we only have access to the phenomenon

**Signature Questions:**

- Can this be universalized? What if everyone adopted this maxim?
- What synthetic a priori assumptions are built into this framework before experience begins?
- Is this argument operating within the limits of what reason can establish, or has it overreached?
- Are we treating a phenomenal structure (how we experience something) as a noumenal fact (how it is in itself)?
- What is the categorical obligation here, stripped of all consequentialist reasoning?

**Failure Modes to Hunt:**

- Context-dependent reasoning that fails universalizability
- Treating contingent conventions as necessary structures
- Assuming direct access to things-in-themselves without acknowledging the constitutive role of the observing subject
- Antinomies: reason arguing both for and against a proposition with equal force — a signal to stop, not to choose

---

## Domain Signals for Extended Lenses

When no lenses are explicitly named, use these signals to auto-invoke extended lenses:

| Signal | Lenses |
|--------|--------|
| Strategic / competitive problem | Von Neumann |
| Decision under uncertainty with significant downside | Pascal + Taleb |
| Multi-domain problem needing cross-framework synthesis | Munger |
| Research hypothesis or experimental design | Brenner + Popper |
| ML / AI system behavior | Karpathy |
| Dependency management, long-term maintainability, simplicity | Hipp |
| Complex system with emergent properties | Wolfram |
| Mathematical structure question | Grassmann + Rota |
| Ethical / universalizability question | Kant |

## Output Format

Each lens speaks in first person, labeled with its name. Present findings sequentially. **Do not synthesize prematurely** — the value is in the divergent findings, not convergence.

```
**Feynman:** [findings — moves applied, questions asked, failure modes found]

**Shannon:** [findings]

**Dijkstra:** [findings]

**Taleb:** [findings]

[Extended lenses if invoked...]
```

After all lenses have reported, provide a brief **Fault Lines** section: the 2-3 most important points of tension or disagreement between lenses. Do not resolve them — surface them.

## Example Session

**User**: `/interrogate Should we migrate our monolith to microservices?`

**Feynman:** The first question is mechanical: what is the monolith actually doing? "Migrate to microservices" is not a description of a physical change — it's a slogan. What are the actual services, what data flows between them, and what is the coupling that makes the current system hard to change? Until we can draw that on a napkin, we don't understand the problem well enough to solve it. I'd also ask: what specific thing are you unable to do right now that you believe microservices would enable? If you can't name it concretely, the motivation may be fashion rather than engineering.

**Shannon:** The information-theoretic question is about the interface bandwidth between services. In a monolith, internal function calls have effectively infinite bandwidth and zero latency. Every service boundary you introduce is a channel with finite capacity, serialization overhead, and failure modes. How many bits per second actually need to cross each proposed boundary? If most of the information stays within what would become a single service, you may be drawing boundaries in the wrong places. I'd also note: the number of independent dimensions here is probably smaller than it looks — most "microservices" proposals have 2-3 actual axes of independent variation dressed up as 15 services.

**Dijkstra:** What is the specification? "Migrate to microservices" is not a specification — it describes a means, not a postcondition. I want to know what invariants the current system maintains, and whether the proposed architecture preserves them. Distributed systems introduce partial failure modes that monoliths do not have. Every network call is an abstraction that leaks — it can fail, timeout, return stale data, or succeed on one side and fail on the other. The question is not whether microservices are "better" but whether you can formally state the correctness properties you need and prove the new architecture maintains them.

**Taleb:** What's the tail risk of the migration itself? The expected case is "it takes 6 months and works." But what's the 1-in-10 case? Two years of parallel systems, neither fully functional, team attrition from the grind. The 1-in-50 case? A partially migrated system that is strictly worse than either pure architecture — the distributed monolith. Meanwhile, what's the tail risk of *not* migrating? If the monolith works and scales to 10x current load, the downside of inaction is low. You're proposing to trade a known, bounded risk (monolith complexity) for an unbounded one (migration failure). That's a fragility trade, not a robustness improvement.

**Fault Lines:**
- **Feynman vs. the premise**: The question assumes microservices are the solution. The first-principles interrogation suggests the problem hasn't been defined yet.
- **Shannon vs. conventional wisdom**: Information theory suggests most proposed service boundaries are drawn where convenience dictates, not where actual information independence exists.
- **Taleb vs. the expected case**: The analysis of tail risk suggests the migration itself may be the biggest risk, not the monolith.
