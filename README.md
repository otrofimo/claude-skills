# Claude Skills

A collection of skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each skill adds a slash command or automation that extends what Claude can do in your terminal.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [Council](skills/council/) | `/council` | Virtual advisory board of domain experts. Feynman is always present to ask first-principles questions. |
| [Interrogation Protocol](skills/interrogation-protocol/) | `/interrogate` | Cognitive lens analysis — 36 operational protocols across design, engineering, business, product, refactoring, security, and AI. Not persona simulation; transferable methods. |
| [Auto-Archive](skills/auto-archive/) | `/archive` | Auto-archive sessions at 60% context window with keyword-indexed summaries for LLM discoverability. |
| [Cognitive Mesh](skills/cognitive-mesh/) | `/mesh` | BDI+OODA cognitive mesh for structured problem-solving. Beliefs-Desires-Intentions manage internal state, Observe-Orient-Decide-Act drive execution. The mesh tightens each cycle until the problem is solved. Execution, not analysis. |
| [Picasso Bull](skills/picasso/) | `/picasso` | Progressive code refinement through deliberate waves, inspired by Picasso's Bull lithograph series. Wave 1 makes behavior and invariants explicit; later waves remove non-essential complexity while preserving them. |

## Installation

### Via Plugin Marketplace

```bash
# Add the marketplace
/plugin marketplace add otrofimo/claude-skills

# Install a skill
/plugin install council@claude-skills
/plugin install interrogation-protocol@claude-skills
/plugin install auto-archive@claude-skills
/plugin install cognitive-mesh@claude-skills
/plugin install picasso@claude-skills
```

### Uninstalling

```bash
# Remove a skill
/plugin uninstall council@claude-skills
/plugin uninstall interrogation-protocol@claude-skills
/plugin uninstall auto-archive@claude-skills
/plugin uninstall cognitive-mesh@claude-skills
/plugin uninstall picasso@claude-skills

# Remove the marketplace (optional)
/plugin marketplace remove otrofimo/claude-skills
```

### Manual Installation

Clone and copy the skill you want:

```bash
git clone https://github.com/otrofimo/claude-skills.git
cp -r claude-skills/skills/council ~/.claude/skills/
cp -r claude-skills/skills/interrogation-protocol ~/.claude/skills/
cp -r claude-skills/skills/auto-archive ~/.claude/skills/
cp -r claude-skills/skills/cognitive-mesh ~/.claude/skills/
cp -r claude-skills/skills/picasso ~/.claude/skills/
```

## License

MIT
