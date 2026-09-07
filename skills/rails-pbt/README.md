# rails-pbt

Property-based testing for Ruby on Rails with the [`pbt`](https://github.com/ohbarye/pbt) gem.

An example test says "this input gives that output". A property says "whatever happens, money is
never created or destroyed" — and then a generator spends a hundred runs trying to break it. This
skill finds the logic in a Rails repo where that trade pays off, writes the properties down for a
human to check *before* any code is generated, and turns the approved ones into ordinary RSpec.

## Usage

```
/rails-pbt analyze this repo and propose a property catalog
/rails-pbt the catalog looks right, generate the specs
/rails-pbt triage these failures
```

There is no DSL and no config file. The output is `spec/properties/*_spec.rb`, plain RSpec that any
Rails developer can read, plus one helper in `spec/support/`.

## The shape

| Phase | What happens | Output |
|-------|--------------|--------|
| 1. Discover | Rank targets by blast radius: money and ledgers, state machines, idempotent commands, derived fields, serializers, partition scopes | nothing written |
| 2. Catalog | One table, one sentence per property, plus "not tested" and "assumptions to confirm" — **then stop** | `spec/properties/CATALOG.md` |
| 3. Generate | R1 (validation round-trip) first, then the approved properties from eight recipes | one spec file per target |
| 4. Triage | Every failure is generator-too-wide, property-wrong, or code-wrong — checked in that order | fixes, or a recorded bug |

The stop after Phase 2 is the point of the skill. A wrong property costs one line to fix in the
catalog and an afternoon to chase once the specs are red.

## What ships

```
SKILL.md                    the procedure
references/recipes.md       R1–R8: generator, assertion, and the false positive you hit first
assets/pbt_rails.rb         the helper: arb_for(Model) + isolated { }
assets/pbt_rails_spec.rb    four self-checks to run before trusting any property
scripts/verify_helper.sh    25 checks of the helper against a pinned pbt checkout
evals.json                  three end-to-end evals
```

`PbtRails.arb_for(Model)` derives generators from the schema and the validations: column types,
numericality bounds, length limits, enums, inclusion lists. `PbtRails.isolated { }` runs each case
in a savepoint that is always rolled back, so run 37 never sees the rows from runs 1–36.

The helper refuses more than it guesses. It never generates `nil`, ignores conditional validators,
rejects `format:` validators, and skips foreign keys — each of those is a place where a plausible
guess would produce a green test that proves nothing. Everything it refuses is an override at the
call site.

## The recipes

| # | Recipe | For |
|---|--------|-----|
| R1 | Validation round-trip | every target, first — it calibrates the generator |
| R2 | Transition table | `enum`, `aasm`, bang methods |
| R3 | Oracle | `counter_cache`, stored totals, balances |
| R4 | Idempotence | `idempotency_key`, `upsert`, webhooks, jobs |
| R5 | Order independence | tags, line items, imports |
| R6 | Round-trip serialization | `as_json`/parse pairs, CSV, EDI |
| R7 | Partition completeness | complementary scopes |
| R8 | Conservation | ledgers, inventory, quotas |

## Hard rules the skill enforces

- `worker: :none` always — Ractor workers cannot call `expect`, see `let`, or share the connection
- No `rand`, `SecureRandom`, `Time.now` or `Time.current` inside a property block; a seed that does
  not reproduce the failure is worse than no seed
- Every database write inside `PbtRails.isolated`
- No bare `rescue`; expected rejections are asserted with a named error class
- Sequences capped at 20 for DB-backed targets
- A property whose sentence a product manager would not recognize is a test case, not a property
- Never weaken a property to make it pass — that is the one way this exercise produces negative value

## Verifying the helper

```bash
./scripts/verify_helper.sh          # clones pbt v0.7.0, runs 25 checks; needs ruby + git
PBT_TAG=v0.8.0 ./scripts/verify_helper.sh
```

No Rails and no database required — the script stubs the two ActiveRecord methods the helper uses.

## Status

Verified against **pbt 0.7.0** on Ruby 3.3: array shrinking reduces failing event sequences to
minimal ones (`[:settle]`), integer shrinking bisects toward zero and therefore does not find
interior thresholds (the recipes account for this), hash arbitraries reach property blocks intact,
and `map` shrinks through the unmapper. Not yet run against a live Rails app; the bundled self-check
exists to surface adapter and schema surprises on the first run.

## Install

```bash
/plugin marketplace add otrofimo/claude-skills
/plugin install rails-pbt@claude-skills
```

## Credit

The four-phase shape — research, reviewed property catalog, workload, fresh-context triage — is
borrowed from Antithesis's skills, as is the framing that a property is a sentence about the system
that must always hold. The tooling is unrelated: this produces RSpec, not hypervisor assertions.
