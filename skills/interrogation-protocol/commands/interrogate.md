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

### Pólya — Heuristic Problem-Solving & Strategic Exploration

**Orientation:** Solving problems is a practical art, like swimming — you learn it by practice, not by reading about it. But there are systematic heuristics that make you better. The four phases — understand, plan, execute, look back — are not bureaucracy; they are the difference between flailing and problem-solving. The most powerful move is asking: "Do I know a related problem?"

**Moves:**

- Understand the problem first: What is the unknown? What are the data? What is the condition? Is the condition sufficient? Redundant? Contradictory?
- Find a related problem: Have you seen this before? Do you know a related problem with a known solution? Can you use its method?
- Specialize and generalize: Solve a simpler version. Solve a special case. Then ask what the general principle is.
- Work backwards: Start from the desired result. What would you need to be true one step before the conclusion?
- Look back: Can you check the result? Can you derive it differently? Can you use the result or method for some other problem?

**Signature Questions:**

- What is the unknown? What are we actually trying to find or prove?
- Do I know a related problem? Can I restate this as a problem I've already solved?
- Can I solve a simpler version first?
- What happens if I work backwards from the desired conclusion?
- Can I check this result by an independent method?
- Is there a more general principle here that this is a special case of?

**Failure Modes to Hunt:**

- Plunging into execution without understanding the problem (skipping phase 1)
- Not looking for related problems — treating every problem as novel when it isn't
- Solving a harder problem than necessary (failing to simplify)
- Never looking back — getting an answer and moving on without verification or generalization
- Confusing the inability to solve a problem with the problem being unsolvable

---

### Euler — Computational Exploration & Cross-Domain Analogy

**Orientation:** Compute. Compute specific cases. Compute many of them. The patterns that emerge from concrete computation are more reliable guides than abstract speculation. The deepest truths often reveal themselves through fearless calculation — pushing formulas past their apparent domain of validity, finding that discrete and continuous are mirrors of each other, and trusting the algebra even when rigor hasn't caught up.

**Moves:**

- Compute small cases systematically and look for patterns before attempting a general proof
- Push formulas beyond their apparent domain: apply a continuous result to discrete cases (or vice versa) and see what it says
- Introduce a generating function: encode a sequence as coefficients and operate on the whole function
- Use analogy across domains: if a result holds for sums, does an analogous result hold for integrals?
- When stuck, add a parameter — generalize the problem and solve the family, not the instance

**Signature Questions:**

- What do the first 5-10 specific cases look like? Is there a pattern?
- What happens if I treat this discrete problem as continuous (or vice versa)?
- Can I encode this as a generating function and extract the answer from the algebra?
- What would happen if I pushed this formula past its obvious domain of validity?
- Is there a parameter I can add that makes the general problem easier than the specific one?
- What is the continuous analogue of this discrete structure?

**Failure Modes to Hunt:**

- Attempting abstract proof before computing enough cases to see the pattern
- Treating discrete and continuous as fundamentally different when they're analogous
- Fear of non-rigorous exploration (rigor can come later; insight must come first)
- Solving one instance when parameterizing the family would be easier
- Missing a generating function representation that would make the answer algebraically transparent

---

### Grothendieck — Structural Abstraction & The Rising Sea

**Orientation:** Do not attack the problem — immerse it. The right approach is not to crack the nut with a hammer, but to let the sea rise until the nut opens by itself. This means finding the right level of generality — the context in which the hard problem becomes a trivial consequence of the definitions. If the proof is hard, the definitions are wrong. The goal is to build the right category, not to be clever.

**Moves:**

- Don't solve the problem directly — find the right context in which it dissolves
- Generalize relentlessly: what is the most general setting in which this statement holds?
- Define the right morphisms: the maps between objects tell you more than the objects themselves
- Ask what structure is preserved, not what objects look like concretely
- Let definitions do the work: if the proof requires ingenuity, the conceptual framework is insufficiently developed

**Signature Questions:**

- What is the right category for this problem? What are the objects and morphisms?
- Is this hard because the abstraction level is wrong? Would it be trivial in a more general setting?
- What structure is preserved under the natural transformations here?
- Are we studying the objects or the relationships between objects? (The relationships are usually more fundamental.)
- What would the "right" definition be — the one that makes the theorem a tautology?
- Can we replace this specific argument with a universal property?

**Failure Modes to Hunt:**

- Clever tricks substituting for conceptual understanding (solving the problem without understanding it)
- Working at the wrong level of abstraction — either too concrete or too general
- Focusing on objects rather than morphisms and functors
- Definitions that require external conditions rather than capturing the phenomenon intrinsically
- Specificity disguised as generality: claiming generality while the argument secretly depends on special features

---

### Noether — Symmetry, Invariance & Conservation

**Orientation:** The deepest question is: what doesn't change? Every symmetry produces a conservation law; every conservation law implies a symmetry. If you can identify what transformation leaves the system unchanged, you've found the invariant that governs its behavior. Strip away the concrete objects and work with the abstract structure of their relations. The most powerful mathematics is the most abstract — not because abstraction is a virtue, but because it reveals what's actually doing the work.

**Moves:**

- Find the invariant: what quantity, property, or structure is preserved across transformations?
- Identify the symmetry: what transformation leaves the system unchanged?
- Abstract the structure: replace specific objects with their algebraic relationships
- Ask what the minimal algebraic structure is that captures the phenomenon
- Test by breaking: if you break the symmetry, what conservation law fails? If a conserved quantity changes, what symmetry was violated?

**Signature Questions:**

- What is conserved here? What doesn't change as the system evolves?
- What symmetry produces this conservation law?
- If I abstract away the specific objects and keep only the relations, what algebraic structure remains?
- What is the minimal structure needed — what can I remove and still have the phenomenon?
- If I break this symmetry, what should I expect to change?
- Are there hidden symmetries I haven't noticed yet?

**Failure Modes to Hunt:**

- Missing a conserved quantity that would simplify the analysis
- Treating a specific representation as fundamental when it's the abstract structure that matters
- Over-specifying: including structure that isn't actually needed for the result
- Failing to check what happens when symmetry is broken (the exceptions reveal the rule)
- Confusing notational symmetry with structural symmetry

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

## Design Lenses

---

### Ive — Reductive Design & Material Honesty

**Orientation:** Design is not decoration applied to function — it is the fundamental expression of what a thing *is*. The goal is inevitability: the feeling that the object could not have been any other way. Every element must justify its existence. If it doesn't serve the whole, remove it. Respect the material — don't make glass pretend to be paper, don't make software pretend to be physical.

**Moves:**

- Subtract until only the essential remains — then question whether the essential is truly essential
- Test material honesty: is each element expressing what it actually is, or costuming itself as something else?
- Ask whether the design feels inevitable or arbitrary
- Examine the relationship between form and the function it serves — are they unified or bolted together?
- Question surface treatments: is visual complexity hiding structural simplicity, or is structural complexity hiding behind visual simplicity?

**Signature Questions:**

- What can be removed without loss of function or meaning?
- Does this design feel inevitable — like it couldn't be any other way?
- Is each material (visual element, interaction pattern, component) being honest about what it is?
- Where is decoration masquerading as function?
- What is the emotional quality of this design, and is that quality intentional or accidental?
- If we reduced this to its absolute minimum, what would remain?

**Failure Modes to Hunt:**

- Decoration justified as "branding" or "personality" when it's just noise
- Material dishonesty (skeuomorphism without purpose, flat design that hides affordances)
- Complexity preserved because removing it feels risky, not because it's needed
- Design that impresses designers but confuses users
- Form and function misaligned — beautiful objects that are unpleasant to use

---

### Norman — Cognitive Ergonomics & Error Prevention

**Orientation:** Design is a conversation between the object and the human mind. Every interface makes a promise about how it works — through affordances, signifiers, constraints, and mappings. When humans make errors, the design failed, not the human. The question is never "why did the user do that?" — it is "what about the design made that the natural thing to do?"

**Moves:**

- Map the user's mental model against the system model — where do they diverge?
- Identify affordances (what actions are possible) and signifiers (what actions are communicated)
- Test the error path: what happens when the user does the wrong thing? Does the design prevent, catch, or punish the error?
- Check mapping: is the relationship between controls and outcomes natural or arbitrary?
- Find the gulf of execution (how hard is it to figure out what to do?) and the gulf of evaluation (how hard is it to tell what happened?)

**Signature Questions:**

- What does the user think this does vs. what it actually does?
- Where will users make errors, and does the design prevent those errors or blame the user?
- What are the affordances here — what actions does this invite?
- Is the mapping between action and effect natural or arbitrary?
- Can the user tell what state the system is in at any moment?
- What is the gulf of execution? What is the gulf of evaluation?

**Failure Modes to Hunt:**

- Blaming user error for design failures ("the user should have known...")
- Missing or misleading signifiers (buttons that don't look clickable, clickable things that don't look like buttons)
- Arbitrary mappings (controls that bear no spatial or logical relationship to their effects)
- Mode errors (same action produces different results depending on invisible state)
- Error messages that describe symptoms without suggesting recovery

---

### Rams — Design Discipline & Principled Reduction

**Orientation:** Good design is as little design as possible. Every product should be useful, understandable, unobtrusive, honest, long-lasting, thorough, environmentally friendly, and — critically — involve as little design as possible. The ten principles are not aesthetic preferences; they are engineering constraints on what design is allowed to do.

**Moves:**

- Apply each of the ten principles as a binary test: does this design pass or fail?
- Ask whether the design is innovative (does it advance the state of the art, or merely recombine?)
- Test whether the design makes the product useful — not just usable, but genuinely useful
- Check for honesty: does the design promise more than the product delivers?
- Evaluate longevity: will this design age well, or is it fashion?

**Signature Questions:**

- Is this design innovative, or does it merely look new?
- Does this make the product more useful, or just more decorated?
- Is the design honest — does it promise exactly what the product delivers, no more?
- Is this understandable without explanation?
- Is this unobtrusive — does the design serve the user or demand attention for itself?
- Will this still look and feel right in ten years?
- Is this as little design as possible?

**Failure Modes to Hunt:**

- Design that draws attention to itself rather than the content or function
- Innovation theater — novelty without utility
- Dishonest design (promising capabilities that don't exist, hiding limitations)
- Fashion-driven choices that will age poorly
- Over-design: solving problems that don't exist, adding elements that don't serve the user

---

### Kelley — Creative Confidence & Human-Centered Discovery

**Orientation:** Creativity is not a gift — it is a practice. The biggest obstacle to good solutions is premature convergence: deciding what to build before understanding who you're building for. Empathy is not sentiment; it is method. Prototype to think, not to prove. The first idea is almost never the best idea, and the fear of bad ideas kills good ones.

**Moves:**

- Start with empathy: who is the actual human, what is their actual experience, what are they actually feeling?
- Diverge before converging — generate multiple alternatives before evaluating any
- Prototype the riskiest assumption first — the cheapest possible test of the thing most likely to be wrong
- Reframe the problem: is this the right question, or has the problem been defined by the first solution that came to mind?

**Signature Questions:**

- Who is the human at the center of this, and have we actually observed them (not just surveyed them)?
- How many alternatives did we generate before choosing this one?
- What is the riskiest assumption, and what is the cheapest way to test it?
- Are we solving the problem as stated, or have we reframed it based on what we learned from users?
- What would we build if the first idea were taken off the table?
- Where is fear of failure constraining the solution space?

**Failure Modes to Hunt:**

- Designing for an imagined user rather than an observed one
- Premature convergence: falling in love with the first idea
- Skipping the divergent phase and going straight to execution
- Confusing surveys and analytics with empathy (people say one thing, do another)
- Prototyping to confirm rather than to learn

---

### Jobs — Integration, Taste & Saying No

**Orientation:** Technology alone is not enough. The intersection of technology and liberal arts — that's where the value lives. Taste is the ability to recognize quality and to refuse what doesn't meet it. Saying no to a thousand things to focus on the one thing that matters. The user experience is the product; everything else is implementation detail. Ship it — perfection through iteration, not through planning.

**Moves:**

- Ask what the user *experiences*, not what the system *does* — the product is the experience
- Apply the taste test: does this feel right? If it doesn't, no amount of feature justification fixes it
- Count what's being attempted and cut until the focus is singular
- Test end-to-end integration: does the whole experience cohere, or is it a collection of good parts that don't add up?
- Ask what was said no to — if nothing was rejected, nothing was curated

**Signature Questions:**

- What is the one thing this does? If the answer requires "and", it's not focused enough
- Does this feel right — not just work right, but *feel* right?
- What did we say no to? What features, options, or capabilities were deliberately excluded?
- Is the technology serving the experience, or is the experience serving the technology?
- Would a non-technical person understand what this is and why it matters in one sentence?
- Does the whole experience cohere, or is it a collection of individually good pieces?

**Failure Modes to Hunt:**

- Feature accumulation without curation ("yes, and..." instead of "no")
- Technology-forward thinking (building because we can, not because we should)
- Fragmented experience: good components that don't add up to a coherent whole
- Confusing complexity with sophistication
- Shipping when it's "done" rather than when it's "right"

---

## Engineering Lenses

---

### Lamport — Specification & Formal Reasoning

**Orientation:** The most critical errors in software are specification errors — building the wrong thing correctly. Thinking above the code means specifying what the system should do before deciding how to do it. In distributed systems, informal reasoning is not merely insufficient — it is actively dangerous. If you haven't written the specification, you don't know what you're building.

**Moves:**

- Demand a specification before discussing implementation — what must be true, not how to make it true
- Identify the safety properties (bad things that must never happen) and liveness properties (good things that must eventually happen)
- Find the consensus problem: where must multiple components agree, and what happens when they don't?
- Test temporal reasoning: does the argument account for all possible orderings of events?

**Signature Questions:**

- What is the specification? Not the code — the specification
- What are the safety properties? What must *never* happen?
- What are the liveness properties? What must *eventually* happen?
- Have all possible orderings of events been considered, or are we assuming a convenient ordering?
- Where is consensus required, and what happens when it fails?
- Could you write this specification in TLA+ (or equivalent)? If not, is the specification precise enough?

**Failure Modes to Hunt:**

- Implementation without specification (building before knowing what to build)
- Implicit timing assumptions in distributed systems
- Safety properties that are only maintained under favorable orderings
- Liveness violations hidden by typical-case testing
- "It works on my machine" as evidence of correctness in a distributed system
- Informal reasoning about concurrent or distributed behavior

---

### Dean — Scale Engineering & Practical Systems Design

**Orientation:** At sufficient scale, everything that can go wrong will go wrong, and everything that seems unlikely becomes certain. The question is not whether the elegant solution works — it's whether it works when multiplied by a billion. Pragmatism over purity: the correct engineering decision depends on the actual numbers, not on architectural aesthetics.

**Moves:**

- Multiply everything by 1000x and see what breaks
- Identify the actual bottleneck — measure before optimizing
- Ask what the system does when a component fails (not if, when)
- Test whether the architecture is constrained by the right resource (CPU, memory, network, disk, human attention)
- Find the operational cost: not just compute cost, but cognitive cost of running the thing

**Signature Questions:**

- What happens at 1000x the current scale? What breaks first?
- What is the actual bottleneck right now — have we measured it, or are we guessing?
- What does the system do when [component X] is down for 30 minutes?
- What is the operational cost of this design — not just servers, but human hours to keep it running?
- Are we optimizing the right thing? Is this the actual constraint?
- What is the simplest architecture that handles the actual (not hypothetical) scale requirements?

**Failure Modes to Hunt:**

- Premature optimization of the wrong bottleneck
- Architectures that work at demo scale but fail at production scale
- Ignoring operational cost (systems that are cheap to build but expensive to run)
- Over-engineering for hypothetical scale that may never arrive
- Assuming components won't fail
- Measuring the easy metric instead of the important metric

---

### Torvalds — Code Taste & Opinionated Simplicity

**Orientation:** Good code is obvious code. Good taste in programming means seeing the simpler solution — the one that handles the edge cases naturally rather than through special-case handling. Abstractions should make code clearer, not more "flexible." If the code is too clever to understand at a glance, it's too clever. Opinions are not a weakness; they're what prevents design-by-committee mush.

**Moves:**

- Read the code and ask: is this obvious? Would a competent programmer understand it immediately?
- Look for special-case handling — it's usually a sign that the core abstraction is wrong
- Test whether the interface is clean even if the implementation is complex
- Ask whether the abstraction makes the common case simple or makes every case equally complex
- Find the opinion: what decision has been made, or is this trying to please everyone?

**Signature Questions:**

- Is this code obvious? Can I tell what it does by reading it once?
- Where are the special cases, and do they indicate a wrong abstraction?
- Does this interface make the common case trivial, or does it make all cases equally hard?
- What opinion does this code express? If none, it's probably trying to be everything to everyone
- Is the cleverness necessary, or is there a straightforward way to do this?
- Who maintains this in two years — will they understand it?

**Failure Modes to Hunt:**

- Clever code that requires explanation (if it needs a comment explaining the trick, rewrite the trick)
- Abstractionitis: layers of indirection that add flexibility no one uses
- Design by committee: no opinions, no decisions, maximum optionality, minimum clarity
- Special-case proliferation indicating a wrong core model
- "Generic" solutions that are harder to use than purpose-built ones
- Comments explaining what the code does instead of the code being self-evident

---

### Thompson — Minimalist Systems & Compositional Design

**Orientation:** Do one thing well. A system is a composition of parts, and the quality of the composition depends on the quality of the interfaces between parts. Small, sharp tools composed through universal interfaces beat monolithic systems every time. Complexity is the enemy, and the way to fight it is not with more sophisticated tools but with simpler ones.

**Moves:**

- Decompose into the smallest useful units with clean interfaces
- Test composability: can this component be used in contexts its designer didn't anticipate?
- Ask what the universal interface is — the simple protocol that everything speaks
- Verify that each component does one thing and does it completely
- Check whether complexity is in the components or in their composition — it should be in the composition

**Signature Questions:**

- Does this do one thing? Can you state what it does in one sentence without using "and"?
- What is the interface between components — is it simple, universal, and composable?
- Can this component be used in a context its designer didn't anticipate?
- Where is the complexity — in the parts or in their composition?
- What would the Unix version of this look like — small tools, text streams, pipelines?
- If each piece is simple, why is the whole system complex? What went wrong at the boundaries?

**Failure Modes to Hunt:**

- Monolithic designs that can't be decomposed or recomposed
- Components that assume too much about their context
- Custom interfaces where a standard one would work
- "Do everything" tools that do nothing well
- Complexity in the components rather than in their composition
- Tight coupling disguised as "integration"

---

## Business & Strategy Lenses

---

### Dalio — Principles & Radical Transparency

**Orientation:** Reality has rules, and the way to find them is through radical transparency — about what happened, why it happened, and what you got wrong. Every mistake is a learning opportunity, but only if the mistake is acknowledged without ego protection. Decisions should be believability-weighted: the opinion of someone who has done the thing successfully three times counts more than the opinion of someone who has an interesting theory.

**Moves:**

- Identify the principle: what general rule does this situation exemplify?
- Apply believability-weighting: who in this discussion has actually done this before?
- Force the pain + reflection = progress loop: what went wrong, why, and what's the principle that prevents recurrence?
- Ask what reality is, not what we wish it were
- Test whether ego is protecting a bad position from revision

**Signature Questions:**

- What principle applies here? Is there a general rule this is an instance of?
- Who has actually done this successfully before? What do they say?
- What went wrong last time, and what principle would have prevented it?
- Are we seeing reality as it is, or as we wish it were?
- Where is ego preventing an honest assessment of the situation?
- What does the data say, independent of what anyone believes?

**Failure Modes to Hunt:**

- Ego-driven decision making (protecting a position because changing it feels like losing)
- Ignoring the track record of the people giving advice
- Learning the wrong lesson from a failure (or no lesson at all)
- Confusing opinions with principles (untested beliefs treated as rules)
- Radical transparency used as a weapon rather than a diagnostic tool

---

### Buffett — Circle of Competence & Long-Term Compounding

**Orientation:** The most important thing is knowing what you don't know. Stay inside your circle of competence. Look for durable competitive advantages — moats — that compound over time. The best decision is often to do nothing and wait. Margin of safety isn't pessimism; it's engineering. Time is the friend of the wonderful business and the enemy of the mediocre one.

**Moves:**

- Draw the circle of competence: what do we actually understand well enough to bet on?
- Identify the moat: what structural advantage compounds over time?
- Apply margin of safety: if our estimate is wrong by 30%, does the decision still hold?
- Test for durability: will this advantage still exist in 10 years?
- Ask whether this is a decision we need to make now, or whether waiting has value

**Signature Questions:**

- Is this inside our circle of competence? Do we genuinely understand this domain?
- What is the moat? What structural advantage prevents competition from eroding this position?
- If our most optimistic assumption is wrong by 30%, does this still work?
- Will this still matter in 10 years?
- What is the cost of waiting? Is there an advantage to deciding now vs. later?
- Are we being greedy when others are fearful, or fearful when others are greedy?

**Failure Modes to Hunt:**

- Operating outside the circle of competence and mistaking confidence for knowledge
- Confusing a temporary advantage with a durable moat
- Insufficient margin of safety (plans that only work if everything goes right)
- Mistaking activity for progress (trading when holding is correct)
- Short-term optimization that destroys long-term compounding

---

### Graham — Startup Reasoning & Building Under Uncertainty

**Orientation:** Make something people want. That's the hard part — everything else is negotiable. Do things that don't scale in the beginning, because unscalable things teach you what people actually want. The default state of a startup is dead. Every decision should be evaluated against whether it moves you toward ramen profitability or away from it.

**Moves:**

- Ask whether people want this — not whether they say they want it, but whether they demonstrate wanting it with behavior
- Identify what doesn't scale and ask whether that's the right thing to be doing right now
- Test default alive vs. default dead: at current trajectory, does this survive or die?
- Find the schlep: the hard, unglamorous thing nobody wants to do that is the actual source of value
- Ask what happens if this works — is it a billion-dollar idea or a nice lifestyle business? (Both are fine, but know which one you're building)

**Signature Questions:**

- Do people want this? Not "would they use it if it existed" — do they actively seek it?
- What are we doing that doesn't scale, and is it teaching us what we need to learn?
- At current growth and burn rate, are we default alive or default dead?
- What is the schlep — the hard, boring, valuable thing nobody else wants to do?
- What is the thing we know that nobody else knows?
- If this works, how big is it?

**Failure Modes to Hunt:**

- Building for imagined users instead of observed demand
- Premature scaling before product-market fit
- Avoiding the schlep in favor of technically interesting but strategically unimportant work
- Default dead without acknowledging it
- Fundraising as a substitute for revenue
- Solving problems that are fun to solve rather than important to solve

---

### Cuban — Execution & Competitive Advantage Through Effort

**Orientation:** Ideas are worthless; execution is everything. The one thing you can always control is how hard you work and how prepared you are. Know your business cold — every number, every customer, every competitor. Sales cures all. If you can't explain why a customer should buy from you instead of the alternative, you don't have a business.

**Moves:**

- Ask for the numbers: revenue, cost, growth rate, customer acquisition cost, lifetime value — all of them
- Test competitive differentiation: why would a customer choose this over the specific alternative they're using now?
- Find the sales motion: who buys this, how do they find it, and what makes them say yes?
- Check preparation: does the team know the business cold, or are they running on narrative?

**Signature Questions:**

- What are the actual numbers? Revenue, cost structure, growth rate, unit economics?
- Why does a customer buy this instead of the specific alternative? (Not "we're better" — how, specifically?)
- What is the sales motion? Who buys, how do they find you, what closes the deal?
- What do you know about this business that your competitors don't?
- If you had to be profitable next month, what would you cut?
- Are you working harder and smarter than your competition? If not, why do you expect to win?

**Failure Modes to Hunt:**

- Narrative without numbers (a great story with no unit economics)
- Vague competitive differentiation ("we're better/faster/cheaper" without specifics)
- No clear sales motion (assuming "if we build it, they will come")
- Under-preparation disguised as "vision" or "strategy"
- Confusing funding with validation

---

## Product Lenses

---

### Dunford — Positioning & Market Context

**Orientation:** Positioning is not messaging — it is the context that makes the product make sense. Every product exists in a competitive landscape, and the customer evaluates it against their alternatives — not against an abstract ideal. If you don't set the context, the customer will set it for you, and they'll probably get it wrong. The five components of positioning are: competitive alternatives, unique attributes, value, target customer, and market category.

**Moves:**

- Identify the real competitive alternatives: what would the customer do if this product didn't exist?
- Map unique attributes: what does this have that the alternatives don't?
- Translate attributes to value: so what? Why does the customer care?
- Define the target customer: who cares the most about the unique value?
- Choose the market category that makes the value obvious

**Signature Questions:**

- What would the customer do if this product didn't exist? (That's the real competition)
- What unique attributes does this have that alternatives lack?
- What value do those attributes create for the customer — not features, value?
- Who is the best-fit customer — the one who cares most about this specific value?
- What market category makes this value proposition immediately obvious?
- Are we positioning against the right competitive alternative, or the one we wish we were competing with?

**Failure Modes to Hunt:**

- Positioning against an imagined competitor rather than the actual alternative the customer uses
- Feature-listing instead of value communication
- Targeting everyone (which means targeting no one)
- Choosing a market category that sounds impressive but confuses the customer
- Positioning based on what the team built rather than what the customer needs

---

### Fried — Constraint-Based Product & Calm Engineering

**Orientation:** Less is more, and enough is enough. Constraints are not limitations — they are the preconditions for good decisions. Build less, charge for it, and make it work reliably. The goal is not growth at all costs; it is a sustainable product that respects both the team and the customer. Features are easy to add and nearly impossible to remove. Say no by default.

**Moves:**

- Apply the constraint test: what would we build if we had half the time, half the people, half the features?
- Ask what can be cut entirely without losing the core value
- Test whether this feature earns its maintenance cost forever
- Check whether growth is being pursued for its own sake or because the product demands it
- Find the "good enough" — the point where additional polish costs more than it's worth

**Signature Questions:**

- What would this look like if we had to ship it in half the time?
- Is this feature earning its permanent maintenance cost?
- What happens if we just don't build this? Will anyone actually notice?
- Are we optimizing for growth or for sustainability?
- Is this complexity serving the customer or serving our ambition?
- What would the calm version of this product look like — no urgency, no crisis, just reliable?

**Failure Modes to Hunt:**

- Feature creep justified by "customer requests" (customers request everything; curation is the job)
- Growth pursued as a goal rather than an outcome of value creation
- Complexity ratchet: each feature adds a little complexity, and it never goes back down
- Work-about-work: processes, tools, and coordination overhead that exceed the work itself
- Premature scaling of team or infrastructure

---

## Refactoring Lenses

---

### Beck — Test-Driven Development & Small Steps

**Orientation:** Make the change easy, then make the easy change. The fundamental move is: write a failing test, make it pass, refactor. Small steps are not slow — they're fast, because they eliminate the debugging time that large steps require. The code tells you what it wants to be; your job is to listen. Fear is the mind-killer in refactoring — tests are the antidote.

**Moves:**

- Ask what change is needed, then ask what would make that change easy
- Find the test: what behavior must be preserved? Write the test first
- Take the smallest possible step that produces a visible change
- After each step, ask: is the code better? If not, revert
- Separate the refactoring from the behavior change — never do both at once

**Signature Questions:**

- What would make the change we need easy? Let's do that first
- What is the smallest step we can take and verify?
- Do we have a test that would catch a regression here?
- Are we changing behavior and structure at the same time? (Stop — separate them)
- If this step goes wrong, can we revert in under a minute?
- What is the code telling us it wants to be?

**Failure Modes to Hunt:**

- Big-bang refactoring (rewriting large sections without incremental verification)
- Changing behavior and structure simultaneously
- Refactoring without tests (editing, not refactoring)
- Speculative refactoring for future flexibility that may never be needed
- Fear-driven avoidance of messy code that needs to be changed
- Perfect as the enemy of better

---

### Fowler — Code Smells & Evolutionary Design

**Orientation:** Refactoring is changing the structure of code without changing its behavior — and it should be a continuous practice, not a periodic project. Code smells are heuristics, not rules: they tell you where to look, not what to do. The goal of design is not an up-front blueprint but an evolving structure that stays clean through continuous attention.

**Moves:**

- Identify the code smell: what specific structural problem is present?
- Name the refactoring: what named transformation addresses this smell?
- Test the motivation: is this refactoring in service of a current change, or speculative?
- Check for the refactoring preconditions: do we have tests? Is the change safe?
- Evaluate the design pressure: is the code under active change (refactor now) or stable (leave it)?

**Signature Questions:**

- What is the code smell here? Can we name it specifically?
- What refactoring pattern addresses this smell?
- Is this code under active change, or is it stable? (Only refactor code that needs to change)
- Do we have sufficient test coverage to refactor safely?
- Is this a structural problem or a naming/clarity problem?
- What is the smallest refactoring that addresses the immediate need?

**Failure Modes to Hunt:**

- Refactoring stable code that isn't causing problems (leave it alone)
- Applying refactoring patterns by rote without understanding the motivation
- Incomplete refactoring that leaves the code in a worse intermediate state
- Using "refactoring" to mean "rewriting" (refactoring preserves behavior by definition)
- Ignoring code smells in areas under active development

---

### Thomas — Pragmatic Engineering & Orthogonality

**Orientation:** Software development is a craft, and good craftspeople use the right tool for the job, keep their tools sharp, and leave the code a little better than they found it. Orthogonality — the principle that changing one thing shouldn't require changing unrelated things — is the foundation of maintainable systems. DRY (Don't Repeat Yourself) is about knowledge, not code.

**Moves:**

- Test orthogonality: if I change X, what else breaks? If the answer is "things unrelated to X," the design is coupled
- Apply DRY to knowledge, not just code: is the same piece of knowledge expressed in multiple places?
- Fire tracer bullets: build a thin end-to-end slice to validate the architecture before filling in details
- Ask whether the tool matches the problem, or whether we're using a familiar tool regardless of fit
- Check the broken windows: is there code rot that signals "nobody cares about quality here"?

**Signature Questions:**

- If we change this one thing, what else has to change? Is that coupling essential or accidental?
- Where is knowledge duplicated? (Not code — knowledge. Two functions with identical code that represent different concepts are not violations of DRY)
- Have we fired a tracer bullet — built one thin end-to-end slice — to validate our architecture?
- Are we using this tool because it's right, or because it's familiar?
- Where are the broken windows — the places where quality has visibly decayed?
- Is this reversible? If not, are we treating it with appropriate care?

**Failure Modes to Hunt:**

- Coupling disguised as cohesion (things that change together because of poor boundaries, not because they belong together)
- DRY applied to code instead of knowledge (merging functions that happen to look similar but represent different concepts)
- Big-design-up-front without tracer bullets to validate assumptions
- Broken windows — visible quality decay that signals "anything goes"
- Irreversible decisions made with reversible-decision speed

---

## Security Lenses

---

### Schneier — Threat Modeling & Systems Thinking

**Orientation:** Security is a process, not a product. Every system has an attack surface, and the attacker gets to choose where to attack. Think about security as risk management: what are the threats, what are the assets, who are the adversaries, and what are their capabilities? The weakest link determines the strength of the chain, and the weakest link is almost always human.

**Moves:**

- Model the threat: who is the adversary, what are their capabilities, what are their motivations?
- Identify the assets: what is being protected, and what is it worth?
- Map the attack surface: every input, every interface, every trust boundary
- Find the weakest link: the point where the least effort produces the most damage
- Ask whether the security measure addresses the actual threat or the imagined one

**Signature Questions:**

- Who is the adversary? What are their capabilities and motivations?
- What are we protecting, and what is it worth to both us and the attacker?
- What is the attack surface — every point where an adversary can interact with the system?
- Where is the weakest link? (It's probably human, not technical)
- Does this security measure address the actual threat model, or just make us feel safer?
- What is the cost of the security measure vs. the cost of the attack it prevents?

**Failure Modes to Hunt:**

- Security theater: measures that look protective but don't address actual threats
- Wrong threat model: defending against nation-states when the threat is opportunistic attackers (or vice versa)
- Ignoring the human element (phishing, social engineering, insider threats)
- Point solutions in a system problem (one strong lock on a building with open windows)
- Security through obscurity as a primary defense

---

### Hunt — Attack Surface & Data Exposure

**Orientation:** Every breach follows a pattern. Data exposure is the primary risk, and most organizations don't know what data they have, where it lives, or who can access it. The attack surface is always larger than you think. Defaults matter more than policies — if the secure option isn't the default, most users won't choose it.

**Moves:**

- Enumerate the data: what sensitive data exists, where is it stored, who can access it, how is it transmitted?
- Check the defaults: is the out-of-box configuration secure, or does it require opt-in security?
- Test the credential chain: how are secrets managed, rotated, and revoked?
- Examine the third-party surface: what vendors, APIs, and services have access to your data?
- Look at what's public: what is exposed to the internet that shouldn't be?

**Signature Questions:**

- What sensitive data does this system handle, and where does it live?
- Are the defaults secure? What happens if the operator changes nothing?
- How are credentials stored, rotated, and revoked? What happens when an employee leaves?
- What third parties have access to the data, and what are their security practices?
- What is publicly exposed that shouldn't be? (APIs, admin panels, debug endpoints, cloud storage)
- If this system were breached tomorrow, what would the attacker get?

**Failure Modes to Hunt:**

- Unknown data stores (data in places no one is monitoring)
- Insecure defaults that require opt-in hardening
- Credential sprawl (secrets in config files, environment variables, chat logs)
- Third-party risk blindness (trusting vendors without verifying their security)
- Exposure through error messages, logs, or debug endpoints

---

### Hypponen — Adversary Motivation & Global Threat Landscape

**Orientation:** To defend against attackers, you must understand attackers. Cyber threats are driven by three motivations: money, espionage, and sabotage. The threat landscape is global and asymmetric — an attacker in one country can reach a target in any other with near-zero cost. Attribution matters because it tells you about capability and persistence. Most organizations are not targeted — they are swept up in automated campaigns.

**Moves:**

- Classify the threat by motivation: criminal (money), state (espionage/sabotage), or hacktivist (ideology)
- Assess whether the target is specifically targeted or caught in a dragnet
- Map the adversary's capability and persistence: script kiddie, organized crime, or APT?
- Consider the geopolitical context: what state actors have interest in this sector?
- Check the supply chain: where are the upstream dependencies, and could they be compromised?

**Signature Questions:**

- Who would attack this, and why? Money, espionage, sabotage, or ideology?
- Are we a specific target, or are we likely to be caught in automated scanning and exploitation?
- What is the adversary's persistence level? Will they try once and move on, or will they keep coming back?
- What is the supply chain exposure? What upstream dependencies could be compromised?
- What does the global threat landscape look like for this sector and geography?
- If a state actor wanted in, could we stop them? If not, how do we limit the damage?

**Failure Modes to Hunt:**

- Defending against the wrong adversary (preparing for hacktivists when the threat is organized crime)
- Assuming you're not a target because you're "too small" (automated attacks don't care about size)
- Ignoring supply chain risk
- Treating all threats equally rather than prioritizing by capability and motivation
- Attribution theater: spending resources on who rather than on defense

---

### Ormandy — Offensive Analysis & Vulnerability Hunting

**Orientation:** The way to find out if a system is secure is to try to break it. Theoretical analysis tells you what *should* be safe; offensive testing tells you what *is* safe. Security theater — measures that look protective but don't withstand adversarial testing — is worse than no security, because it creates false confidence. Zero tolerance for security claims not backed by adversarial testing.

**Moves:**

- Think like the attacker: what is the easiest path to the asset?
- Find the parsing bugs: every place that parses input is a potential vulnerability
- Test the assumptions: what does the code assume about its inputs that an attacker can violate?
- Look for the bug class, not just the individual bug: if this type of flaw exists once, it probably exists in many places
- Verify security claims by attempting to violate them

**Signature Questions:**

- What is the easiest path to compromise this system?
- Where does this system parse untrusted input, and what happens with malformed input?
- What assumptions does the code make about its inputs that an attacker could violate?
- If this vulnerability exists here, where else might the same bug class exist?
- Has anyone actually tried to break this, or is the security assessment purely theoretical?
- What security claims are being made, and have they been adversarially tested?

**Failure Modes to Hunt:**

- Security by assertion ("we're secure because we use encryption") without adversarial testing
- Missing bug classes: finding one instance of a flaw and not searching for the pattern elsewhere
- Input validation at the UI layer only (attackers don't use the UI)
- Trust boundaries that exist on paper but not in code
- Security measures that are complex enough to have their own vulnerabilities

---

### Ptacek — Practical Security & Implementation Pitfalls

**Orientation:** The gap between theoretical security and practical security is where breaches live. Cryptographic primitives are secure; cryptographic implementations are where things go wrong. Don't roll your own crypto, don't invent your own authentication protocol, don't trust yourself to get constant-time comparison right. Use boring, proven, well-maintained libraries. The most dangerous security mistakes are the ones that look correct to everyone except the specialist.

**Moves:**

- Check for custom implementations of security primitives: authentication, encryption, hashing, token generation
- Verify that the standard library or well-maintained package is being used instead of hand-rolled code
- Test for implementation-level flaws: timing attacks, padding oracles, nonce reuse, insufficient randomness
- Ask whether the security-critical code has been reviewed by a specialist
- Look for protocol-level mistakes: things that are secure in isolation but insecure in composition

**Signature Questions:**

- Is this using a standard, well-maintained library, or is this hand-rolled?
- Who reviewed this security-critical code, and what is their cryptographic expertise?
- Are there timing side-channels? Is comparison constant-time?
- How is randomness generated? Is the CSPRNG used correctly?
- What happens if the attacker can replay, reorder, or truncate messages?
- Is this protocol secure in composition, or only in isolation?

**Failure Modes to Hunt:**

- Roll-your-own crypto or authentication
- Timing side-channels in security-critical comparisons
- Nonce reuse or insufficient randomness
- Using cryptographic primitives correctly in isolation but incorrectly in protocol composition
- JWT misuse (algorithm confusion, lack of expiry, storing sensitive data in payload)
- Security code that hasn't been reviewed by a domain specialist

---

## Agentic & AI Lenses

---

### Huntley — AI-Assisted Development Practices & Tooling

**Orientation:** AI is reshaping how software is built, and the practitioners who instrument, observe, and share their findings are building the real playbook. The patterns that work are not the ones that sound impressive — they're the ones that survive contact with real codebases. Tooling matters more than prompting tricks. The gap between "AI demo" and "AI in production" is where the actual engineering lives.

**Moves:**

- Ask what the actual developer workflow looks like end-to-end with AI in the loop
- Distinguish between demo-quality and production-quality AI integration
- Test whether the tooling supports or fights the AI workflow
- Identify where human review is essential and where it's theater
- Find the feedback loop: how does the developer know when the AI's output is wrong?

**Signature Questions:**

- What does the actual end-to-end workflow look like, not the demo?
- Where does the AI output require human review, and how does the human know what to check?
- What tooling exists to catch AI errors before they reach production?
- How is the prompt/context/configuration versioned and tested?
- What happens when the AI confidently produces wrong code? How quickly is it caught?
- Is this AI integration reducing total development time, or just shifting effort from coding to reviewing?

**Failure Modes to Hunt:**

- Demo-driven development (impressive demos that don't survive real-world use)
- Insufficient review of AI-generated code (trusting the output because it "looks right")
- Missing feedback loops (no way to tell when AI output is wrong until it breaks in production)
- Prompt fragility (workflows that break when the model is updated)
- Cargo-culting AI tools without measuring their actual impact on productivity

---

### Yegge — Platform Thinking & Developer Experience

**Orientation:** The difference between a product and a platform is that a platform lets other people build things you didn't anticipate. Internal services without APIs are just silos. Developer experience is not a feature — it is the product, because developers are the users, and if the DX is bad, the platform dies. Every sufficiently successful internal tool becomes a platform, and if it wasn't designed as one, the transition will be painful.

**Moves:**

- Ask whether this is a product or a platform — and whether it should be the other
- Test the API: can an external developer (or an internal team) build something useful on top of this without talking to the original developers?
- Evaluate developer experience: how long from zero to "hello world"?
- Find the accessibility gap: who is excluded by the current API/tooling design?
- Check whether the system is internally using its own API (dogfooding)

**Signature Questions:**

- Is this a product or a platform? Should it be the other?
- Can someone build on top of this without talking to the team that made it?
- How long does it take to go from zero to a working "hello world" integration?
- Is the team using its own API, or bypassing it for internal use?
- What developer is excluded by the current design — who can't use this that should be able to?
- What happens when a use case arises that the original designers didn't anticipate?

**Failure Modes to Hunt:**

- Building a product when you need a platform (or vice versa)
- Internal services without programmatic APIs
- Not dogfooding: the team bypasses their own API for internal operations
- High time-to-hello-world (complex setup, poor documentation, implicit knowledge required)
- Designing for the expert user while excluding the beginner

---

### Willison — Practical AI Applications & Transparent Engineering

**Orientation:** The way to understand AI tools is to build with them in public, share what works and what doesn't, and let others reproduce and challenge the results. Transparency is not optional — it is the only way to build trust in systems that are inherently unpredictable. Small, composable tools beat large, opaque platforms. Document everything, show your work, and make it reproducible.

**Moves:**

- Ask whether this is reproducible: can someone else get the same result with the same inputs?
- Test transparency: can a user understand what the AI is doing and why?
- Evaluate composability: can this tool be plugged into other workflows, or is it a walled garden?
- Check the failure mode: when the AI gets it wrong, what happens? Does the user know?
- Find the documentation gap: what is assumed that should be explicit?

**Signature Questions:**

- Is this reproducible? Can someone else run this and get the same result?
- When the AI gets it wrong, how does the user know? How do they recover?
- Is this composable with other tools, or is it a closed ecosystem?
- What is being hidden from the user that they should be able to see?
- Is this documented well enough that someone could maintain it without talking to the original developer?
- What happens when the model changes? Does the whole system break?

**Failure Modes to Hunt:**

- Opaque AI systems where the user can't see or understand the process
- Non-reproducible results presented as reliable
- Walled-garden design that prevents composition with other tools
- Missing documentation that creates bus-factor risk
- Model dependency without abstraction (one model change breaks everything)

---

## Behavioral Science Lenses

---

### Kahneman — Cognitive Bias & Judgment Under Uncertainty

**Orientation:** Human judgment is not noisy rationality — it is systematically biased. System 1 (fast, automatic, associative) does most of the work and System 2 (slow, deliberate, logical) is often just rationalizing System 1's conclusions. The operational question is never "is this person rational?" but "what substitution is happening?" — what easy question is being answered in place of the hard one? Base rates are ignored, plans are optimistic, losses loom larger than gains, and what you see is all there is.

**Moves:**

- Identify the substitution: What easy question is System 1 answering instead of the hard question that was actually asked?
- Check the base rate: Before evaluating this specific case, what does the reference class say? What percentage of projects/decisions/predictions like this one succeed?
- Run a pre-mortem: Assume this plan has failed spectacularly one year from now. What went wrong? (Surfaces planning fallacy and overconfidence.)
- Audit for noise: Would a different analyst, team, or day of the week produce a different answer to the same question? If so, the process has a noise problem.
- Test for WYSIATI (What You See Is All There Is): What information is NOT in front of you right now that would change this judgment?

**Signature Questions:**

- What is the base rate for this kind of outcome? Are we ignoring it in favor of the specific case?
- What substitution is happening? Is System 1 answering a different, easier question?
- What would the outside view predict? (Not "how does this feel from inside?" but "what happens statistically?")
- If this plan fails, what's the most likely reason? (Pre-mortem)
- What information is missing from this picture that would change the conclusion? (WYSIATI)
- Would a different person, given the same data, reach the same conclusion? If not, why not? (Noise audit)
- Where is loss aversion distorting the decision? Are we overweighting potential losses relative to equivalent gains?

**Failure Modes to Hunt:**

- Planning fallacy: timelines that assume best-case execution with no contingency
- Anchoring: a number was mentioned early and is now distorting all subsequent estimates
- Availability bias: recent or vivid events dominating probability estimates over actual frequencies
- Substitution: answering "do I like this?" instead of "is this effective?" (or any easy question replacing a hard one)
- WYSIATI: building confident narratives from incomplete information
- Overconfidence: confidence calibration that doesn't match actual accuracy rates
- Sunk cost: continuing because of past investment rather than future expected value

---

### Tversky — Framing, Features & Elimination

**Orientation:** How a problem is represented determines what conclusions feel natural — and many apparently firm conclusions are artifacts of the frame, not the facts. The same objective situation, stated differently, produces different choices — which means at least one of those choices is frame-dependent rather than truth-dependent. Similarity is not a fixed relation but a feature-weighting process, and what features dominate the comparison is itself a choice, often invisible.

**Moves:**

- Frame reversal: Restate the exact same problem in a different frame (gains vs. losses, survival vs. mortality, keep vs. discard). If the conclusion changes, it was frame-dependent.
- Feature decomposition: What features are being used to compare these options? Which features are being weighted heavily, and is that weighting justified or habitual?
- Elimination by aspects: What is being eliminated from consideration, and on what single dimension? Is that dimension actually the most important one?
- Conjunction audit: Is a conjunction (A and B) being judged more probable than one of its components? (It can't be — but it often feels that way when the conjunction is a good story.)
- Support theory check: Is the evidence being "unpacked" into vivid sub-cases (making it seem more probable) or "packed" into a single category (making it seem less probable)?

**Signature Questions:**

- Does this conclusion change if I frame the same facts differently? (If yes, the conclusion is about the frame, not the facts.)
- What features dominate this comparison? Are they the right features?
- What option was eliminated early, and on what basis? Would it survive if we changed the elimination criterion?
- Is this judgment based on a representative story rather than a statistical model? Does the story's coherence feel like probability?
- Are we comparing options by their shared features or their distinctive features? (Tversky showed these produce different similarity orderings.)
- Is the evidence unpacked or packed? Would re-describing it change the probability estimate?

**Failure Modes to Hunt:**

- Frame-dependent conclusions: answers that reverse when the same data is described differently
- Feature domination: one salient feature overwhelming other relevant dimensions
- Premature elimination: discarding options based on one aspect before evaluating the whole picture
- Conjunction fallacy: a detailed scenario feeling more probable than a general one because it's a better story
- Representativeness over base rate: "this looks like X" overriding "X is rare"
- Asymmetric unpacking: one hypothesis gets detailed elaboration (seeming more probable) while the alternative stays vague

---

## Systems & Complexity Lenses

---

### Meadows — System Dynamics & Leverage Points

**Orientation:** Systems produce their own behavior. If you want to understand why something is happening, don't look at the actors — look at the structure: the stocks, flows, feedback loops, and delays that create the dynamics you observe. Most interventions fail because they push on low-leverage points (adjusting parameters) when the system's behavior is driven by its structure (feedback loops, rules, goals, paradigms). The highest leverage is often counterintuitive.

**Moves:**

- Map the system: Identify the stocks (accumulations), flows (rates of change), and feedback loops (reinforcing and balancing)
- Find the feedback loops: Which are reinforcing (amplifying change) and which are balancing (resisting change)? Which ones dominate?
- Identify delays: Where does the system respond slowly? Delays cause oscillation and overshoot — they're where instability lives.
- Locate the leverage points: Where would a small change in structure produce a large change in behavior? (Hint: it's usually not where you first look.)
- Check system goals: What is the system optimizing for? (Often different from what it's supposed to optimize for.)

**Signature Questions:**

- What are the stocks and flows? What is accumulating, and what controls the rate?
- Where are the feedback loops? Which are reinforcing and which are balancing?
- Where are the delays? What dynamics do they create (oscillation, overshoot)?
- What is the system's actual goal — not its stated goal, but the one its structure is optimizing for?
- Where are the leverage points? Where would a small structural change produce the largest behavioral shift?
- Are we pushing on a low-leverage point (adjusting a number) when we should be changing the rules, goals, or paradigm?
- What would this system do if we left it alone? (Its default trajectory reveals its dominant loops.)

**Failure Modes to Hunt:**

- Event-level thinking: reacting to symptoms without seeing the systemic structure that produces them
- Pushing on low-leverage points: spending effort adjusting parameters when the feedback structure is the problem
- Ignoring delays: expecting immediate results from interventions in systems with long time constants
- Fixing the symptom, worsening the system: interventions that suppress balancing feedback, allowing reinforcing loops to dominate
- Goal displacement: the system has drifted to optimizing something other than its original purpose
- Missing reinforcing loops: exponential growth or collapse that isn't visible until it's too late

---

### Simon — Bounded Rationality & Satisficing

**Orientation:** Optimization is a mathematical fiction. Real decisions happen under bounded rationality — limited information, limited computation, limited time. The right question is not "what is optimal?" but "what is good enough, and can we find it with the resources we actually have?" Satisficing — seeking a solution that meets the threshold — is not a failure of rationality. It is often the only rational strategy when the cost of optimization exceeds the value of the improvement.

**Moves:**

- Assess computational tractability: Is the optimal solution even findable in the available time and with available information? If not, satisficing isn't a compromise — it's the correct strategy.
- Define the aspiration level: What is "good enough"? Set an explicit threshold before searching, not after.
- Decompose into near-independent sub-problems: Complex problems are usually nearly decomposable — find the natural joints.
- Identify the attention bottleneck: What is actually scarce here — information, computation, time, or attention? Design the decision process around the real constraint.
- Check for "looking under the lamppost": Is the analysis shaped by what data is conveniently available, rather than what data is actually relevant?

**Signature Questions:**

- Is optimization tractable here, or are we pretending it is? What is the actual computational cost of finding the best solution?
- What is "good enough"? Can we define a clear aspiration level before we start?
- Can this problem be decomposed into nearly independent sub-problems?
- What is the binding constraint — information, time, compute, or attention?
- Are we analyzing what's convenient to measure, or what actually matters?
- When should we stop deliberating and act? What's the cost of continued analysis vs. the cost of a suboptimal choice?
- Is this a case where more information would actually help, or would it just add noise?

**Failure Modes to Hunt:**

- Optimization theater: pursuing the optimal solution when satisficing would produce nearly the same result at a fraction of the cost
- Analysis paralysis: the cost of continued analysis exceeding the value of improvement
- Ignoring decomposability: treating a complex problem as monolithic when it has natural joints
- Data availability bias: analyzing what's measurable instead of what's important
- Aspiration-level drift: continuously raising the bar so "good enough" is never reached
- Confusing information volume with decision quality

---

### Senge — Learning Organizations & System Archetypes

**Orientation:** Organizations don't fail because of individual mistakes — they fail because of systemic structures that produce recurring patterns of behavior. These patterns — "system archetypes" — repeat across industries and contexts. If you can recognize the archetype, you can anticipate the dynamics before they play out. The deepest lever is the mental model: the assumptions and beliefs that keep the system locked in its current pattern.

**Moves:**

- Identify the system archetype: Is this "Fixes that Backfire"? "Shifting the Burden"? "Limits to Growth"? "Tragedy of the Commons"? "Success to the Successful"?
- Find the mental model: What assumption or belief is keeping this system locked in its current pattern?
- Distinguish the symptomatic solution from the fundamental solution: Is the current "fix" actually preventing the real problem from being addressed?
- Map the learning disabilities: Where is the organization unable to learn from its own experience?
- Check for delayed consequences: Is a current "success" creating conditions for future failure?

**Signature Questions:**

- What system archetype is operating here? What pattern keeps repeating?
- What mental model is holding this pattern in place? What would have to change in how people think?
- Is this a symptomatic fix or a fundamental solution? Is the quick fix making the real problem harder to solve?
- Where are the learning disabilities? What is the organization systematically unable to see about itself?
- What is this team/organization optimizing locally that is suboptimal globally?
- If you showed the system its own behavior pattern over time, would it be surprised?
- What would "double-loop learning" look like here — learning that changes the underlying assumptions, not just the actions?

**Failure Modes to Hunt:**

- "Fixes that Backfire": short-term solutions that create long-term dependency (workarounds that become permanent)
- "Shifting the Burden": relying on symptomatic solutions until the capacity for fundamental solutions atrophies
- "Limits to Growth": early success hitting a constraint that turns growth into stagnation or collapse
- "Tragedy of the Commons": local optimization destroying a shared resource
- "Success to the Successful": early advantage compounding into systemic inequality
- Mental model lock-in: inability to question the assumptions driving the pattern
- Single-loop learning: adjusting actions without examining the beliefs that produced them

---

## Decision Science Lenses

---

### Gigerenzer — Ecological Rationality & Fast-and-Frugal Heuristics

**Orientation:** Heuristics are not biases — they are evolved tools adapted to specific environments. A simple heuristic that ignores information can outperform a complex optimization when the environment is uncertain, sample sizes are small, and the future differs from the past. The question is not "is this rational in the abstract?" but "does this heuristic fit this environment?" Less can literally be more: simpler models with fewer parameters predict better in uncertain worlds because they don't overfit.

**Moves:**

- Match the heuristic to the environment: Is this a situation with high uncertainty, small samples, and many cues? Then simple rules beat complex models (bias-variance tradeoff).
- Apply the less-is-more principle: Would ignoring some information actually improve prediction? Does a fast-and-frugal tree outperform a regression?
- Test ecological validity: Does the finding hold in the real-world environment, or only in the lab? What features of the lab (forced choices, artificial probabilities) might not transfer?
- Ask whether the "bias" is an adaptation: Is the heuristic producing errors in the lab but success in the environment it evolved for?
- Check the bias-variance tradeoff: Is the more complex model actually predicting better, or is it overfitting to noise?

**Signature Questions:**

- What is the structure of the environment? Is it stable and data-rich (favoring optimization) or uncertain and data-poor (favoring heuristics)?
- Would a simpler decision rule produce equal or better outcomes here?
- Is the "bias" actually an adaptation to the environment? Does it fail in the lab but work in the field?
- What information is this heuristic ignoring? Is that a bug or a feature?
- Does the complex model's superior fit on past data translate to superior prediction of future data?
- What is the cost of using the complex model (time, data requirements, interpretability) vs. the simple one?
- Is this a one-cue world (where a single variable dominates) or a compensatory world (where many variables matter equally)?

**Failure Modes to Hunt:**

- Complexity bias: assuming more variables, more data, and more sophisticated models always perform better
- Lab-only rationality: declaring a behavior "irrational" based on lab studies that don't match real-world environmental structure
- Overfitting: complex models that explain the past perfectly but predict the future poorly
- Ignoring the cost of information: treating data collection and processing as free
- Decontextualized bias claims: calling a heuristic an error without specifying what environment it's being evaluated in
- Assuming more deliberation always helps: sometimes thinking more makes decisions worse (overthinking)

---

### Duke — Probabilistic Thinking & Decision Quality

**Orientation:** Every decision is a bet on an uncertain future, and the quality of a decision is not determined by its outcome. Resulting — judging decisions by outcomes rather than process — is the cardinal error. Good decisions can produce bad outcomes, and bad decisions can produce good outcomes. The discipline is separating signal from noise, calibrating confidence honestly, and updating beliefs when evidence arrives rather than defending them.

**Moves:**

- Separate decision quality from outcome quality: Was this a good bet even if it didn't pay off? Was this a bad bet even though it worked?
- Calibrate confidence: What probability do you actually assign to this? Not "I think" or "I feel" — what number? (Then check: are you historically right 70% of the time when you say 70%?)
- Identify resulting: Is the evaluation of this decision contaminated by knowledge of the outcome?
- Run the "10-10-10": How will you feel about this decision 10 minutes from now? 10 months? 10 years? (Surfaces time-horizon biases.)
- Pre-commit to update criteria: Before seeing the results, define what evidence would make you change your mind.

**Signature Questions:**

- If this decision produced a bad outcome, would you still defend the process? (If not, the decision might be outcome-dependent, not process-sound.)
- What probability do you assign to this? (Force a number — vague confidence enables self-deception.)
- What would change your mind? If you can't answer this, you're not reasoning — you're defending a position.
- Are you evaluating the decision or the outcome? What did you know at the time you made the choice?
- What is the range of possible outcomes, and what is the expected value across all of them?
- Are you in a situation where you can learn from feedback, or is the feedback too slow, noisy, or deceptive?

**Failure Modes to Hunt:**

- Resulting: judging a good bet as bad because it lost, or a bad bet as good because it won
- Phantom confidence: expressing certainty without calibration (saying "definitely" when you mean "probably")
- Motivated reasoning: updating beliefs toward what you want to be true rather than what the evidence says
- Hindsight bias: "I knew it all along" contaminating the evaluation of past decisions
- Binary thinking: treating uncertain situations as certainties ("this will work" vs. "this has a 70% chance of working")
- Failure to update: treating beliefs as identity rather than probability estimates

---

### Bayes — Prior Updating & Evidence Strength

**Orientation:** All reasoning under uncertainty is updating beliefs in light of evidence. You start with a prior (what you believed before), observe evidence, assess how likely that evidence would be under different hypotheses (the likelihood ratio), and arrive at a posterior (what you should now believe). The strength of evidence is not how surprising it is in absolute terms, but how much more likely it is under one hypothesis than another. Extraordinary claims require extraordinary evidence because they start with low priors.

**Moves:**

- Make the prior explicit: Before looking at the evidence, what did you already believe? What is the base rate?
- Compute the likelihood ratio: How much more likely is this evidence under hypothesis A than hypothesis B? (This is the actual strength of the evidence.)
- Update proportionally: Strong evidence (high likelihood ratio) warrants large updates. Weak evidence warrants small ones. No evidence warrants no update.
- Check for base rate neglect: Is a low prior being swamped by a single vivid piece of evidence?
- Ask about the counterfactual: Would this evidence also appear under the alternative hypothesis? If so, it's not very informative.

**Signature Questions:**

- What is the prior probability? Before this evidence, what was the base rate or prior belief?
- What is the likelihood ratio? How much more likely is this evidence if hypothesis A is true vs. hypothesis B?
- Is this evidence diagnostic — does it actually differentiate between hypotheses? Or would you see it regardless?
- Are you updating enough? Are you anchored on the prior and ignoring strong evidence?
- Are you updating too much? Is a single data point overwhelming a well-established prior?
- What evidence would produce the largest update? What experiment would be most informative?
- What is the posterior after updating? State your revised belief as a probability.

**Failure Modes to Hunt:**

- Base rate neglect: ignoring the prior and being overwhelmed by case-specific evidence
- Non-diagnostic evidence: treating evidence as informative when it would appear under both hypotheses
- Asymmetric updating: updating readily in one direction but resisting updates in the other
- Failure to make priors explicit: reasoning from an unconscious prior that may be unreasonable
- Confusion of absence of evidence with evidence of absence (when the evidence would be hard to detect either way)
- Treating the posterior as a new prior without tracking cumulative uncertainty

---

## Information & Communication Lenses

---

### Tufte — Information Density & Visual Evidence

**Orientation:** Every display of information is an argument — it asserts that certain patterns exist and matter. The quality of that argument depends on the data-ink ratio: how much of what you're showing is actual information vs. decoration, redundancy, or chartjunk. The goal is maximum information density with minimum noise. Respect the viewer's intelligence — people can process complex data if you present it honestly, with no distortion and no condescension.

**Moves:**

- Maximize the data-ink ratio: What fraction of the ink on this display represents actual data? Remove everything else.
- Show the data: Before summarizing, simplifying, or aggregating, present the actual evidence. Summaries conceal variation.
- Small multiples: When comparing across conditions, use the same display repeated with one variable changed. Direct, parallel comparison is the most powerful visual argument.
- Enforce graphical integrity: Do the visual proportions match the numerical proportions? (Beware: truncated axes, area-coded values, 3D effects, and dual axes all distort.)
- Layer and separate: Use different visual layers (color, position, text) to encode different dimensions without clutter.

**Signature Questions:**

- What is the data-ink ratio? How much of this display is actual information vs. decoration?
- Can I see the actual data, or only summaries? What variation is the summary concealing?
- Does the visual representation faithfully match the data? Do the visual proportions equal the numerical ones?
- Could I replace this chart with a table and lose nothing? If so, the chart is adding confusion, not clarity.
- What comparison is this display making? Is the comparison direct and parallel, or does it require the viewer to hold information in memory?
- What is the lie factor? (Visual size of effect / actual size of effect — should be 1.0.)

**Failure Modes to Hunt:**

- Chartjunk: decoration, moiré patterns, 3D effects, and gratuitous design elements that obscure data
- Low data-ink ratio: displays that are mostly frame, grid, and label with very little actual data
- Truncated or dual axes that visually exaggerate small differences
- Summary statistics hiding important variation (means without distributions)
- Aggregation concealing Simpson's paradox or ecological fallacy
- Design that condescends: oversimplified displays that underestimate the viewer's ability to process complex data

---

### Luhmann — Knowledge Networks & Emergent Connections

**Orientation:** Knowledge is not a collection — it is a network. Individual ideas have value, but the real intellectual power emerges from the connections between them. Writing is thinking — you don't have ideas and then write them down; you discover ideas by writing them and connecting them. A well-structured knowledge system should surprise you: connections you didn't plan should emerge, producing insights that no single note contains.

**Moves:**

- Atomize: Break every idea down to its smallest self-contained unit. One idea, one note. If a note contains two ideas, split it.
- Connect aggressively: Every new idea should be linked to existing ideas. The question is not "where does this go?" but "what does this connect to?"
- Let structure emerge bottom-up: Don't impose top-down categories. Let the connections between atomic ideas reveal the structure.
- Write to think: Don't wait until you understand something to write about it. Writing is the process of understanding.
- Follow the surprises: When unexpected connections emerge between previously unrelated ideas, that's where the real insight lives.

**Signature Questions:**

- What does this connect to? What existing ideas does this new information link to?
- Can this be broken down further? Is this one idea or several masquerading as one?
- What is the structure that's emerging from the connections? What categories or clusters are forming that I didn't plan?
- Am I filing or connecting? (Filing is storage; connecting is thinking.)
- What surprises me? Where are the unexpected links between ideas from different domains?
- What would happen if I juxtaposed these two seemingly unrelated ideas?

**Failure Modes to Hunt:**

- Collector's fallacy: accumulating information without connecting or processing it
- Top-down categorization: imposing a filing system instead of letting structure emerge from connections
- Isolated notes: ideas stored without links, invisible to future retrieval
- Premature systematization: organizing before enough material exists for genuine structure to emerge
- Confusing storage with understanding: believing that saving an idea is the same as integrating it
- Symmetry of connections: every link should be meaningful — indiscriminate linking destroys signal

---

## Discovery & Innovation Lenses

---

### Johnson — Adjacent Possible & Innovation Through Recombination

**Orientation:** Good ideas don't come from genius or epiphany — they come from environments and processes that make them possible. Innovation is recombination: connecting existing ideas, technologies, and capabilities in new configurations. The "adjacent possible" is the set of things that become achievable given what currently exists — and the best innovations expand the adjacent possible, opening doors to further innovations. Ideas need time to incubate and collide.

**Moves:**

- Map the adjacent possible: Given what currently exists (technology, knowledge, infrastructure), what new combinations are now feasible that weren't before?
- Look for exaptation: What existing capability, built for one purpose, could be repurposed for a completely different use?
- Create collision environments: Innovation happens when diverse ideas encounter each other. Increase the surface area for unexpected combinations.
- Check for the "slow hunch": Is this idea fully formed, or is it a slow hunch that needs time and collision with other hunches to mature?
- Trace the lineage: Every innovation has precursors. What existing ideas does this recombine?

**Signature Questions:**

- What is the adjacent possible right now? What has recently become feasible that wasn't before?
- What existing technology or process, built for one purpose, could be repurposed here? (Exaptation)
- What ideas from completely different domains could be combined with this one?
- Is this a fully formed idea, or a slow hunch that needs more time and input to mature?
- What precursors does this idea build on? What had to exist first for this to be possible?
- Are we looking for innovation in isolation, or creating environments where ideas can collide?

**Failure Modes to Hunt:**

- Genius myth: attributing innovation to individual brilliance rather than environmental conditions
- Ignoring the adjacent possible: attempting innovations that require capabilities that don't yet exist
- Premature closure: forcing a slow hunch into a finished product before it's ready
- Isolation: developing ideas in silos instead of exposing them to diverse inputs
- Ignoring exaptation: only looking for purpose-built solutions when repurposed existing capabilities would work
- Skipping the precursors: trying to leapfrog the adjacent possible

---

### Geertz — Thick Description & Interpretive Observation

**Orientation:** Understanding is not achieved from the outside by measuring and classifying — it is achieved from the inside by interpreting what things mean to the people who do them. A "thin description" records what happened; a "thick description" captures what it meant. The difference between a twitch and a wink is not physical — it is interpretive. If you want to understand a system, a culture, or a practice, you must understand the webs of meaning that the participants are operating within.

**Moves:**

- Thick description: Don't just record what happened — describe what it meant to the participants. What was the significance, not just the sequence?
- Interpret from the inside out: What do the actors think they're doing? What framework of meaning are they operating within?
- Look for the symbolic: Actions carry meaning beyond their practical function. What does this practice/choice/ritual signify?
- Resist premature generalization: Stay close to the specific case. Understand *this* situation deeply before claiming it represents a pattern.
- Triangulate: Observe from multiple positions. The view from the participant, the observer, and the outsider will differ — the differences are informative.

**Signature Questions:**

- What does this mean to the people doing it? (Not what does it mean to us.)
- What is the difference between the thin description (what happened) and the thick description (what it meant)?
- What web of significance are these actors operating within? What framework of meaning makes their actions sensible?
- What symbolic content does this action carry beyond its practical function?
- Am I observing from the outside and imposing my framework, or understanding from the inside?
- What would I miss about this if I only looked at the data and never talked to the people?

**Failure Modes to Hunt:**

- Thin description masquerading as understanding (recording behavior without interpreting meaning)
- Imposing the observer's framework onto the observed (assuming your categories are their categories)
- Premature generalization: jumping to universal claims from specific observations
- Ignoring symbolic and cultural content in technical or organizational decisions
- Quantifying what should be interpreted: turning meaning into metrics and losing the meaning
- Treating the map (the analyst's model) as the territory (the participants' lived experience)

---

### Edison — Systematic Invention & Relentless Experimentation

**Orientation:** Invention is not inspiration — it is systematic, disciplined experimentation at scale. Genius is one percent inspiration and ninety-nine percent perspiration, but the perspiration must be *organized* perspiration. Keep detailed notebooks. Run experiments in parallel. Set up your environment for rapid iteration. Kill failed approaches fast and move on. The goal is not to be right on the first try — it is to maximize the number of useful trials per unit of time. Invention is also a team sport: build a laboratory of diverse minds, not a solo workshop.

**Moves:**

- Systematic variation: Don't guess — systematically vary one parameter at a time across many experiments. The answer is in the data, not the theory.
- Parallel experimentation: Run multiple approaches simultaneously. Don't wait for one to fail before starting the next.
- Document everything: Detailed notebooks are not bureaucracy — they are how you capture serendipitous findings and avoid repeating failed experiments.
- Build for rapid iteration: Design your environment (lab, workflow, tooling) to minimize the time between experiments.
- Harvest adjacent discoveries: Many of the most valuable findings are not what you were looking for. Pay attention to unexpected results.

**Signature Questions:**

- How many experiments have we actually run? (If the answer is "we're still planning," something is wrong.)
- What are we systematically varying? What's the experimental matrix?
- What did the failed experiments teach us? (If nothing, we're not documenting well enough.)
- Can we run these experiments in parallel instead of sequentially?
- What unexpected result did we dismiss that might actually be the most important finding?
- Is our environment set up for rapid iteration, or does each experiment require weeks of setup?
- Who else should be in the room? What perspective are we missing?

**Failure Modes to Hunt:**

- Theory without experimentation: planning and debating when you should be testing
- Sequential where parallel is possible: running experiments one at a time when many could run simultaneously
- Failing to document: losing the learnings from failed experiments
- Premature optimization: investing heavily in the first approach that shows promise instead of continuing to explore
- Solo invention: working alone when diverse perspectives would accelerate discovery
- Ignoring unexpected results: dismissing findings that don't match the hypothesis instead of investigating them
- Confusing activity with progress: running many experiments without systematic variation

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
| UI/UX, visual design, aesthetics | Ive + Norman + Rams |
| Design process, user research, creative problem-solving | Kelley + Jobs |
| Distributed systems, formal verification | Lamport + Dijkstra |
| Systems at scale, performance, infrastructure | Dean |
| Code quality, readability, interface design | Torvalds + Thompson |
| Business model, competitive strategy, investment | Buffett + Cuban |
| Startup, product-market fit, early-stage decisions | Graham |
| Decision-making process, organizational learning | Dalio |
| Product positioning, go-to-market | Dunford |
| Feature scope, sustainable product development | Fried |
| Refactoring, code evolution, technical debt | Beck + Fowler + Thomas |
| Security architecture, threat assessment | Schneier + Hypponen |
| Data security, breach prevention, attack surface | Hunt + Ormandy |
| Cryptographic implementation, auth protocols | Ptacek |
| AI tooling, agentic workflows, LLM integration | Huntley + Willison |
| Platform design, developer experience, APIs | Yegge |
| Judgment, estimation, forecasting, planning fallacy | Kahneman |
| Comparison, choice architecture, framing effects | Tversky |
| Behavioral bias, cognitive error, decision hygiene | Kahneman + Tversky |
| Unfamiliar problem, stuck, need problem-solving strategy | Pólya |
| Pattern discovery, computational exploration, enumeration | Euler |
| Problem needs right abstraction level, overly complex | Grothendieck |
| Symmetry, conservation, invariance, algebraic structure | Noether |
| System dynamics, feedback loops, unintended consequences | Meadows |
| Decision under resource/time constraints, when to stop analyzing | Simon |
| Organizational patterns, recurring failures, team dynamics | Senge |
| Simple vs complex model, heuristic validity, ecological fit | Gigerenzer |
| Decision quality, probability calibration, resulting | Duke |
| Evidence evaluation, hypothesis updating, prior probability | Bayes |
| Data visualization, information display, presentation design | Tufte |
| Knowledge organization, note-taking, connecting ideas | Luhmann |
| Innovation, invention, new product development | Johnson + Edison |
| Understanding user/customer behavior, culture, meaning | Geertz |
| Experimentation process, rapid iteration, parallel testing | Edison |

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
