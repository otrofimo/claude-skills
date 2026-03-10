# Interrogation Protocol — Cognitive Lens Analysis

Operational interrogation protocols, not persona simulations. Each lens applies a specific set of **moves**, **signature questions**, and **failure-mode hunts** to any problem.

The key distinction: persona simulation asks "What would X say?" — that's mimicry. Operational interrogation asks "What does X *do* when they think?" — that's a transferable method.

## Usage

```
/interrogate <problem>                    # Standing lenses (Feynman, Shannon, Dijkstra, Taleb)
/interrogate brenner popper <problem>     # Named lenses only
/interrogate --all <problem>              # All lenses
/interrogate --list                       # Show available lenses
```

## Standing Lenses

Always run unless specific lenses are named.

| Lens | Protocol |
|------|----------|
| Feynman | First principles & physical intuition — strip to mechanical reality |
| Shannon | Information & signal — find the minimum description that preserves what matters |
| Dijkstra | Formal correctness & precision — correct by construction, not by testing |
| Taleb | Tail risk & fragility — survive the case that wasn't in the spreadsheet |

## Extended Lenses

Invoked by name or by domain signal.

| Lens | Protocol |
|------|----------|
| Von Neumann | Strategic structure & adversarial dynamics |
| Munger | Mental models & second-order effects |
| Brenner | Hypothesis structure & experimental design |
| Popper | Falsifiability & critical rationalism |
| Karpathy | Empirical grounding & practical system behavior |
| Hipp | Radical simplicity & long-term engineering |
| Wolfram | Computational structure & emergent complexity |
| Grassmann | Algebraic structure & geometric generalization |
| Rota | Combinatorial structure & mathematical phenomenology |
| Pascal | Expected value & asymmetric bets |
| Kant | Universalizability & the limits of reason |

## Domain Signals

Extended lenses auto-invoke when the problem matches:

- Strategic / competitive problem → **Von Neumann**
- Decision under uncertainty with significant downside → **Pascal** + **Taleb**
- Multi-domain problem needing cross-framework synthesis → **Munger**
- Research hypothesis or experimental design → **Brenner** + **Popper**
- ML / AI system behavior → **Karpathy**
- Dependency management, long-term maintainability, simplicity → **Hipp**
- Complex system with emergent properties → **Wolfram**
- Mathematical structure question → **Grassmann** + **Rota**
- Ethical / universalizability question → **Kant**

## Output Format

Each lens reports its findings independently. No premature synthesis — the value is in divergence. After all lenses report, a **Fault Lines** section surfaces the 2-3 most important tensions between lenses without resolving them.

## Example

```
/interrogate Should we migrate our monolith to microservices?
```

**Feynman:** What is the monolith actually doing? "Migrate to microservices" is a slogan, not a description of a physical change. What specific thing are you unable to do right now?

**Shannon:** Every service boundary is a channel with finite capacity. How many bits per second actually need to cross each proposed boundary? The number of independent dimensions is probably smaller than it looks.

**Dijkstra:** "Migrate to microservices" is not a specification — it describes a means, not a postcondition. What invariants must the new architecture maintain?

**Taleb:** What's the tail risk of the migration itself? You're proposing to trade a known, bounded risk for an unbounded one. That's a fragility trade, not a robustness improvement.

**Fault Lines:**
- The question assumes microservices are the solution before the problem is defined
- Information theory suggests most proposed service boundaries don't align with actual information independence
- The migration itself may be the biggest risk, not the monolith
