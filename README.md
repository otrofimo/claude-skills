# Council Plugin for Claude Code

A virtual advisory board of domain experts. Each council is domain-specific, and Richard Feynman is always present to ask first-principles questions and cut through complexity.

## Installation

```bash
/plugin install otrofimo/claude-skills
```

Or add to a marketplace and install from there.

## Usage

```
/council <question>                    # Uses engineering (default)
/council --board=design <question>     # Specific council
/council --list                        # Show available councils
```

## Available Councils

| Council | Experts |
|---------|---------|
| `design` | Jony Ive, Don Norman, David Kelley, Steve Jobs, Dieter Rams |
| `engineering` | Leslie Lamport, Jeff Dean, Linus Torvalds, Ken Thompson |
| `business` | Charlie Munger, Ray Dalio, Mark Cuban, Warren Buffett, Paul Graham |
| `agentic` | Engineering council + Geoffrey Huntley, Steve Yegge, Simon Willison, Andrej Karpathy |
| `product` | Steve Jobs, Don Norman, April Dunford, Jason Fried |
| `refactoring` | Kent Beck, Martin Fowler, Dave Thomas |
| `security` | Bruce Schneier, Troy Hunt, Mikko Hypponen, Tavis Ormandy, Thomas Ptacek |

Richard Feynman is present in **all councils** as the first-principles questioner.

## Session Flow

1. **Feynman opens** - Reframes the question, asks clarifying first-principles questions
2. **Council responds** - Each expert speaks in their authentic voice
3. **Synthesis** - Key agreements, creative tensions, and actionable takeaways

## License

MIT
