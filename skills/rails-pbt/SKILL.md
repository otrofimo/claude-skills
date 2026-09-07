---
name: rails-pbt
license: MIT
metadata:
  version: "0.1.0"
  verified-against: "pbt 0.7.0"
description: Adds property-based tests to a Ruby on Rails codebase using the `pbt` gem. Analyzes the repo for high-blast-radius logic (money and ledgers, state machines, idempotent commands, derived fields, serializers, partition scopes), writes a short property catalog, then generates plain RSpec property specs from proven recipes and triages the first failures. Use this whenever someone asks for property-based testing, PBT, generative tests, invariant tests, or "tests that find bugs I did not think of" in a Ruby or Rails project; also when they ask how to test a ledger, a state machine, business rules, or a service with many branches, even if they never say "property".
---

# Rails property-based testing

You are adding property-based tests to a Rails repo with `pbt` (verified API: `Pbt.assert`, `Pbt.property`, `Pbt.integer/nat/one_of/boolean/constant/nil/fixed_hash/array/tuple/date/time/alphanumeric_string/printable_ascii_string`, `Arbitrary#map(f, f_inv)`, `Arbitrary#filter`, `#generate(rng)`, `#shrink(value)`). The output is ordinary RSpec files plus one helper file. There is no framework, no DSL, no config file. If you find yourself building one, stop.

## What you produce

```
Gemfile                              gem "pbt", "~> 0.7", group: :test
spec/support/pbt_rails.rb            copied from assets/ (do not edit unless a bug)
spec/properties/pbt_rails_spec.rb    copied from assets/, SMOKE_MODEL set to a real model
spec/properties/CATALOG.md           one table + a "not tested" list (≤ 60 lines)
spec/properties/<target>_spec.rb     one file per target, ≤ 4 properties each
```

First run: at most 5 targets. The person can ask for more. Fifteen sharp properties beat a hundred shallow ones, and every property you add is one the team must maintain.

## Phase 1 — Discover (read, do not write)

Rank targets by blast radius, meaning what breaks for customers or auditors if this logic is wrong. Search in this order and stop reading once you have 5 strong candidates:

| Rank | Signal (grep for) | Why it matters |
|---|---|---|
| 1 | `_cents`, `amount`, `balance`, `total`, `Money`, `money-rails`, `ledger`, `journal` | Money moves. Conservation and sign bugs are silent and expensive. |
| 2 | `enum status:`/`state:` with `!` methods, `aasm`, `state_machine`, `workflow`, `transition` | State machines have combinatorial paths nobody enumerates by hand. |
| 3 | `idempotency_key`, `find_or_create_by`, `upsert`, webhook/job handlers | Retries and duplicates are the normal case in production. |
| 4 | `app/services/**` with `call`/`perform` touching 2+ models | Cross-model invariants live here and are rarely tested as invariants. |
| 5 | `counter_cache`, `*_count` columns, stored totals next to associations | Denormalized values drift. |
| 6 | `serialize`, `to_export`/`from_export`, `as_json` pairs, CSV/EDI importers | Round-trip bugs corrupt data quietly. |
| 7 | Complementary scope pairs (`active`/`inactive`, `paid`/`unpaid`) | Partition bugs double-count or drop rows. |

Read each candidate's model, its validations, and the code that mutates it. Note the exact error class raised on rejection (or that there is none; that becomes a finding). Note `if:`/`unless:` on validators and any `validate :custom_method`; the helper ignores conditional validators on purpose and refuses `format:` validators, so these need overrides.

Skip: CRUD, anything that calls a third-party API without an injectable client, controllers, views, anything already covered by an exhaustive example table.

## Phase 2 — Catalog, then stop

Write `spec/properties/CATALOG.md`:

```markdown
# Property catalog

| # | Target | Recipe | Property (one sentence, business language) | Blast radius | Status |
|---|--------|--------|--------------------------------------------|--------------|--------|
| 1 | LedgerEntry | R2 | Every event either follows the transition table or is rejected with no state change | Money, audit | planned |
| 2 | Account#balance_cents | R3 | Balance equals the raw sum of settled movements after any sequence | Money | planned |

## Not tested (and why)
- PaymentGateway::Charge — calls Stripe with no injectable client. Would need a fake first.
- Order#discount — rule lives in a YAML file that changes weekly; property would be as unstable as the config.

## Assumptions to confirm
- Balances may not go negative (inferred from `validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }`; confirm overdraft is really unsupported).
```

Then stop and show it. The catalog is where a human catches "that is not actually our rule". Fixing a wrong property here costs one line; fixing it after specs are written and failing costs an afternoon of chasing a non-bug. Proceed only when the person says the catalog is right (or edits it).

Recipe codes are in `references/recipes.md`; read it now if you have not.

## Phase 3 — Generate

1. Add the gem, copy both files from `assets/` into place, set `SMOKE_MODEL` in `pbt_rails_spec.rb` to the simplest real model, and run `bundle exec rspec spec/properties/pbt_rails_spec.rb`. All four must pass before anything else; they prove savepoint rollback works on this adapter and that `arb_for` understands this schema. If the round-trip check fails, that is a real finding about the model (see R1 false positives) — resolve it, do not skip it.
2. For each catalogued target, always start with R1 (validation round-trip). It calibrates the generator; every later property inherits that generator.
3. Add the catalogued properties from the matching recipe. Copy the recipe's shape exactly, then adapt names. The recipes encode the fixes for the mistakes people make on their first property; deviating reintroduces them.
4. Each spec file starts with this header so a failure is reproducible by anyone:

```ruby
# Property-based tests. On failure, Pbt prints a seed. Replay with:
#   PBT_SEED=<seed> bundle exec rspec spec/properties/<file>:<line>
# Raise the case count locally with PBT_RUNS=200.
```

## Phase 4 — Verify and triage

Run `PBT_RUNS=100 bundle exec rspec spec/properties`. Every failure is one of three things, and the order you check them matters:

1. **The generator is wider than the domain.** Symptom: rejection with a message like "amount must be positive" from a rule you did not encode. Fix: narrow the generator (override, constructed value, or `.filter` as last resort). This is most first-run failures.
2. **The property is wrong.** Symptom: the code does something reasonable that your sentence forbids. Re-read the business rule in the code and the catalog. Fix the sentence and the assertion together. Note the correction in CATALOG.md so the reviewer sees the rule was misunderstood, not the code.
3. **The code is wrong.** Symptom: the shrunk counterexample is small, the property sentence still reads as true, and you can explain in one line why the code violates it. Leave the spec failing. Write the counterexample and the seed into CATALOG.md under the property's row with status `FAILING — bug`. Do not weaken the property to make it pass; that is the one way this whole exercise produces negative value.

When you cannot tell 2 from 3, say so and show the counterexample. Do not guess.

Before finishing, re-read every generated spec once with fresh eyes (or hand it to a fresh-context reviewer if you can spawn one) against the Hard rules below. Then run the whole suite one more time.

## Hard rules

- `worker: :none` always. Ractor workers cannot call `expect`, cannot see `let` variables, and cannot share the ActiveRecord connection. The helper sets this globally; do not override it.
- No `rand`, `Random.new`, `SecureRandom`, `Time.now`, `Date.today`, or `Time.current` inside a `Pbt.property` block. Every decision comes from the generator or the seed stops reproducing the failure. Time goes through `travel_to` with a generated offset from a fixed base.
- Anything that writes to the database runs inside `PbtRails.isolated`. Shared fixtures are created outside it. Without it, run 37 sees the rows from runs 1–36 and shrinking runs against a polluted database.
- No bare `rescue`. Expected rejections are asserted with a specific class (`expect { }.to raise_error(Ledger::Rejected)`). Anything else propagates and fails the property. A `rescue StandardError` in a property spec is a bug in the spec.
- Sequences: `max: 20` or lower for DB-backed targets. Shrinking scales with sequence length times database round-trips.
- Each property's `it` string is a sentence a product manager would agree with. If you cannot write that sentence, you do not have a property yet; you have a test case.
- Do not test Rails (`has_many` works). Do not restate a validation as a property (`validates :email, presence: true` → "email is present" says nothing). Do not test CRUD.
- Do not generate properties for a target the person did not confirm in the catalog.

## Relationship to Antithesis

This skill borrows the Antithesis skills' shape — research, then a reviewed property catalog, then a workload, then triage with a fresh-context review — and their framing that a property is a sentence about the system that must always hold. It does not use their tooling: `antithesis-research`/`-setup`/`-workload` target Docker-composed distributed systems running under their deterministic hypervisor with SDK assertions (`assert.Always`, `assert.Sometimes`), and `snouty` launches runs on their platform. None of that applies to a Rails test suite. If the app is later deployed to Antithesis, the catalog transfers as-is (each row becomes an `Always` assertion in a workload); the spec files do not. Their reliability property catalogs (blockchains, key-value stores) at antithesis.com/docs/resources are worth reading for phrasing.

## References

- `references/recipes.md` — R1–R8 with generators, assertions, and first false positives. Read before Phase 3.
- `assets/pbt_rails.rb` — the helper. Read once so you know what `arb_for` derives and what it refuses.
- `assets/pbt_rails_spec.rb` — the self-check. Copy verbatim, set `SMOKE_MODEL`.
- `scripts/verify_helper.sh` — 25 checks of the helper against a pinned pbt checkout (needs `ruby` and `git`, no Rails, no database). Run it if you change the helper or the `~> 0.7` constraint.
- pbt README: github.com/ohbarye/pbt — arbitraries, `verbose: true`, seed replay, and the experimental `Pbt.stateful` API (do not use it yet; the array-of-events recipe R2 gets the same shrinking with a stable API).
