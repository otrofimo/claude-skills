# Council Plugin for Claude Code

A virtual advisory board of domain experts. Each council is domain-specific, and **Richard Feynman is always present** to ask first-principles questions and cut through complexity.

## Installation

### Via Plugin Marketplace

```bash
# Add the marketplace
/plugin marketplace add otrofimo/claude-skills

# Install the plugin
/plugin install council@claude-skills
```

### Uninstalling

```bash
# Remove the plugin
/plugin uninstall council@claude-skills

# Remove the marketplace (optional)
/plugin marketplace remove otrofimo/claude-skills
```

### Manual Installation

Copy the skill file to your global Claude skills directory:

```bash
mkdir -p ~/.claude/skills/council
curl -o ~/.claude/skills/council/SKILL.md \
  https://raw.githubusercontent.com/otrofimo/claude-skills/main/skills/council/SKILL.md
```

Or clone and copy:

```bash
git clone https://github.com/otrofimo/claude-skills.git
cp -r claude-skills/skills/council ~/.claude/skills/
```

## Usage

```
/council <question>                    # Uses engineering (default)
/council --board=design <question>     # Specific council
/council --list                        # Show available councils
```

## Available Councils

### Design (`--board=design`)
| Expert | Focus |
|--------|-------|
| Jony Ive | Minimalist aesthetic, "inevitable" design |
| Don Norman | Human-centered design, affordances |
| David Kelley | Design thinking, creative confidence |
| Steve Jobs | Technology meets liberal arts |
| Dieter Rams | "Less but better", 10 principles |

### Engineering (`--board=engineering`)
| Expert | Focus |
|--------|-------|
| Leslie Lamport | Distributed systems, formal methods |
| Jeff Dean | Systems at scale, pragmatic engineering |
| Linus Torvalds | Simplicity, "good taste" in code |
| Ken Thompson | Unix philosophy, elegant minimalism |

### Business (`--board=business`)
| Expert | Focus |
|--------|-------|
| Charlie Munger | Mental models, inversion |
| Ray Dalio | Principles-based decisions |
| Mark Cuban | Hustle, direct communication |
| Warren Buffett | Long-term thinking, simplicity |
| Paul Graham | Startup wisdom |

### Agentic Coding (`--board=agentic`)
| Expert | Focus |
|--------|-------|
| Engineering council | (Lamport, Dean, Torvalds, Thompson) |
| Geoffrey Huntley | AI-assisted development practices |
| Steve Yegge | Platform thinking, developer experience |
| Simon Willison | LLM tooling, practical AI applications |
| Andrej Karpathy | Neural networks, "Software 2.0" |

### Product (`--board=product`)
| Expert | Focus |
|--------|-------|
| Steve Jobs | Taste, saying no |
| Don Norman | Usability, emotional design |
| April Dunford | Positioning, market context |
| Jason Fried | Simplicity, calm company |

### Refactoring (`--board=refactoring`)
| Expert | Focus |
|--------|-------|
| Kent Beck | TDD, "make the change easy" |
| Martin Fowler | Refactoring patterns, code smells |
| Dave Thomas | Pragmatic programming, DRY |

### Security (`--board=security`)
| Expert | Focus |
|--------|-------|
| Bruce Schneier | Cryptography, threat modeling |
| Troy Hunt | Web security, OWASP, data breaches |
| Mikko Hypponen | Malware, global threat landscape |
| Tavis Ormandy | Vulnerability research, offensive security |
| Thomas Ptacek | Practical security, crypto pitfalls |

## Session Flow

1. **Feynman opens** - Reframes the question to its essence, asks 1-2 first-principles questions
2. **Council responds** - Each expert speaks in their authentic voice, drawing from their actual work
3. **Synthesis** - Key agreements, creative tensions, and actionable takeaways

## Example

```
/council --board=refactoring Should I refactor this 500-line function before adding the new feature?
```

**Feynman**: "Okay, let's slow down. You've got 500 lines doing... what exactly? Before we talk about refactoring, I want to understand what this function actually does. Can you explain it to me like I'm a bright undergraduate who's never seen your codebase? And here's the real question: do you actually understand what it does, or are you scared to touch it because nobody does?"

**Kent Beck**: "Here's my take: make the change easy, then make the easy change. If adding your feature feels hard right now, that's the code telling you something. But don't refactor speculatively - refactor in service of the change you're about to make."

**Martin Fowler**: "I'd look for specific code smells first. A 500-line function almost certainly has Feature Envy, Long Parameter Lists, or Divergent Change hiding in there. But Kent's right - opportunistic refactoring. Extract the part you need to touch, leave the rest."

**Dave Thomas**: "Is this function orthogonal to the rest of your system? If changing it breaks things elsewhere, that's your first problem. And honestly - do you have tests? Without tests, refactoring is just editing. With tests, it's surgery."

**Synthesis**:
- **Agreement**: Refactor in service of the immediate change, not for abstract cleanliness
- **Tension**: Beck emphasizes small steps; Thomas emphasizes tests as prerequisite
- **Takeaways**: Write characterization tests first, extract only what you need to touch

## License

MIT
