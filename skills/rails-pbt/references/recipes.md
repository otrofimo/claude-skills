# Recipes R1–R8

Eight shapes that cover almost every property worth writing about a Rails model. Each one gives you
the generator, the assertion, and the false positive you will hit first. Copy the shape, then rename;
the shapes encode fixes for mistakes that are easy to make and hard to see.

Every example assumes `spec/support/pbt_rails.rb` is loaded and the file header from SKILL.md Phase 3
is at the top. All API here is verified against pbt 0.7.0.

## API you will use

```ruby
Pbt.assert { Pbt.property(arb) { |value| ... } }         # runs num_runs times, shrinks on failure
Pbt.assert(num_runs: 30) { ... }                          # per-property override
Pbt.property(Pbt.integer, Pbt.boolean) { |n, flag| }      # several arbitraries -> block params
Pbt.property(a: Pbt.integer) { |attrs| attrs[:a] }        # a hash arbitrary arrives as one Hash
Pbt.integer(min:, max:) / Pbt.nat / Pbt.boolean / Pbt.one_of(*values) / Pbt.constant(v)
Pbt.array(arb, min:, max:, empty:) / Pbt.tuple(*arbs) / Pbt.fixed_hash(k: arb)
Pbt.date(base_date:, past_offset_days:, future_offset_days:) / Pbt.time(base_time:, ...)
arb.map(mapper, unmapper) / arb.filter { |v| ... } / arb.generate(rng) / arb.shrink(value)
```

Two shrinking facts that change how you write properties:

- **Arrays shrink to minimal subsequences first, then shrink elements.** A failing sequence of 14
  events reliably comes back as `[:settle]` or `[:reject, :reject]`. This is why R2 and R8 generate
  event arrays instead of hand-rolling a state walk.
- **Integers bisect toward zero and stop at the first candidate that still fails.** For a property
  that only breaks above a threshold (`fails when amount > 10_000`), every halved candidate passes,
  so the counterexample stays the original value. Do not read "the counterexample is 837_412" as
  "the bug needs a huge number"; find the boundary yourself, or generate near it on purpose.

---

## R1 — Validation round-trip (always first)

**Use for:** every catalogued target, before any other property. It calibrates the generator that
every later property inherits.

**Property sentence:** "Any attribute set the generator produces is accepted by the model and comes
back from the database unchanged."

```ruby
it "accepts every generated attribute set and stores it losslessly" do
  Pbt.assert do
    Pbt.property(PbtRails.arb_for(Invoice, only: %i[amount_cents currency memo])) do |attrs|
      PbtRails.isolated do
        invoice = Invoice.new(attrs)
        expect(invoice).to be_valid, -> { invoice.errors.full_messages.join(", ") }
        invoice.save!
        reloaded = Invoice.find(invoice.id)
        attrs.each_key do |name|
          expect(reloaded.public_send(name)).to eq(invoice.public_send(name)),
            "#{name} changed on the way through the database"
        end
      end
    end
  end
end
```

**First false positives**

| Symptom | Cause | Fix |
|---|---|---|
| `Validation failed: Amount must be greater than 0` | a rule the helper cannot see (custom `validate`, conditional validator) | narrow at the call site: `amount_cents: Pbt.integer(min: 1, max: 1_000_000)` |
| `Account must exist` | a required association; the helper never generates foreign keys | create the parent outside `isolated` and pass `account_id: Pbt.constant(account.id)` |
| a string comes back with different bytes | encoding or collation, or a `before_save` that rewrites the column | if a callback rewrites it, that is the property: assert the normalized form instead |
| a datetime comes back off by microseconds | column precision below the generated precision | this is a real finding for anything that compares timestamps; do not paper over it |

If R1 cannot be made green without weakening it past "the model really accepts this", that is a
finding, not a setup problem. Write it in CATALOG.md.

---

## R2 — Transition table (state machines)

**Use for:** `enum status:` with bang methods, `aasm`, `state_machine`, anything with a `transition`.

**Property sentence:** "Every event either performs a transition the table allows, or is rejected
with a named error and no state change."

```ruby
EVENTS = %i[approve settle fail].freeze
ALLOWED = {
  "pending" => {approve: "approved", fail: "failed"},
  "approved" => {settle: "settled", fail: "failed"},
  "settled" => {},
  "failed" => {}
}.freeze

it "follows the transition table or rejects the event without changing state" do
  Pbt.assert do
    Pbt.property(Pbt.array(Pbt.one_of(*EVENTS), max: 20)) do |events|
      PbtRails.isolated do
        entry = LedgerEntry.create!(state: "pending", amount_cents: 100, account: account)

        events.each do |event|
          before = entry.state
          expected = ALLOWED.fetch(before)[event]

          if expected
            entry.public_send("#{event}!")
            expect(entry.reload.state).to eq(expected)
          else
            expect { entry.public_send("#{event}!") }
              .to raise_error(LedgerEntry::InvalidTransition)
            expect(entry.reload.state).to eq(before), "#{before} --#{event} changed state after rejecting"
          end
        end
      end
    end
  end
end
```

**Notes**

- The table is written by hand from the code, not derived from it. A table derived from the same
  source as the implementation tests nothing.
- `account` is a `let` created outside `isolated`. Fixtures belong outside the savepoint.
- If the code raises no specific error on an illegal transition (it returns `false`, or silently
  no-ops), that is a finding for CATALOG.md, and the property asserts the observed contract only
  after you record it.
- Counterexamples arrive minimal: `[:settle]` means the very first `settle` from `pending` was
  wrongly accepted; `[:reject, :reject]` means the second one behaves differently from the first.

**First false positive:** the guard is conditional on a column the generator does not control (an
`amount_cents > 0` check inside `settle!`). Construct the fixture so the guard is satisfiable, or
add the column to the event tuple: `Pbt.tuple(Pbt.one_of(*EVENTS), Pbt.integer(min: 1, max: 500))`.

---

## R3 — Oracle (derived and denormalized values)

**Use for:** `balance_cents`, `counter_cache`, stored totals, cached aggregates, anything computed
twice in the codebase.

**Property sentence:** "The stored value equals the value recomputed from scratch, after any sequence
of operations."

```ruby
it "keeps balance_cents equal to the sum of settled movements" do
  Pbt.assert do
    Pbt.property(Pbt.array(Pbt.tuple(Pbt.one_of(:credit, :debit), Pbt.integer(min: 1, max: 10_000)), max: 20)) do |movements|
      PbtRails.isolated do
        account = Account.create!(balance_cents: 0)

        movements.each do |kind, cents|
          amount = (kind == :credit) ? cents : -cents
          Ledger::Post.new(account: account, amount_cents: amount).call
        end

        expected = account.ledger_entries.settled.sum(:amount_cents)
        expect(account.reload.balance_cents).to eq(expected)
      end
    end
  end
end
```

**Notes**

- The oracle must be independently computed. `expected = account.balance_cents` recomputed by the
  same method is a tautology; a raw `sum(:amount_cents)` over the rows is not.
- Recompute at the end, not after each step, unless the invariant is meant to hold mid-sequence —
  then assert inside the loop and say so in the sentence.
- Sequences at `max: 20` keep shrinking affordable: shrinking cost is sequence length × round trips.

**First false positive:** the service rejects some movements (overdraft), so the oracle counts rows
the code never wrote. Either constrain the generator so every movement is accepted, or make the
rejection part of the property (R2-style: rejected with a named error and no balance change).

---

## R4 — Idempotence (retries, webhooks, upserts)

**Use for:** `idempotency_key`, `find_or_create_by`, `upsert`, job handlers, anything a queue may
deliver twice.

**Property sentence:** "Replaying the same request any number of times leaves the same state as
handling it once."

```ruby
it "is unchanged by redelivery of the same webhook" do
  Pbt.assert do
    Pbt.property(
      Pbt.fixed_hash(
        key: Pbt.alphanumeric_string(min: 8, max: 12),
        cents: Pbt.integer(min: 1, max: 100_000),
        repeats: Pbt.integer(min: 2, max: 5)
      )
    ) do |attrs|
      PbtRails.isolated do
        once = Webhooks::Handle.new(key: attrs[:key], cents: attrs[:cents]).call
        state_after_one = Payment.order(:id).pluck(:id, :cents, :status)

        attrs[:repeats].times { Webhooks::Handle.new(key: attrs[:key], cents: attrs[:cents]).call }

        expect(Payment.order(:id).pluck(:id, :cents, :status)).to eq(state_after_one)
        expect(Payment.where(idempotency_key: attrs[:key]).count).to eq(1)
        expect(once).to be_present
      end
    end
  end
end
```

**Notes**

- Compare a snapshot of the rows, not just a count. Duplicate suppression that still double-applies
  an amount passes a count check.
- Include `updated_at` in the snapshot only if a no-op replay is genuinely supposed to leave it
  alone; if you are unsure, that question belongs in CATALOG.md as an assumption.

**First false positive:** the handler is idempotent per key but the generator reuses a key across
runs. Everything writes inside `PbtRails.isolated`, so state never leaks between runs — if you see
cross-run collisions, something is writing outside the savepoint.

---

## R5 — Order independence (commutativity)

**Use for:** independent operations the product treats as unordered: applying tags, adding line
items, merging preference hashes, importing rows from a file.

**Property sentence:** "Applying the same set of operations in any order produces the same final
state."

```ruby
it "produces the same cart total regardless of the order items are added" do
  Pbt.assert do
    Pbt.property(
      Pbt.array(Pbt.integer(min: 1, max: 5_000), min: 1, max: 10),
      Pbt.integer(min: 0, max: 3_628_799)
    ) do |prices, rotation|
      PbtRails.isolated do
        forward = Cart.create!
        prices.each { |cents| forward.add_item!(price_cents: cents) }

        shuffled = prices.rotate(rotation % prices.size)
        backward = Cart.create!
        shuffled.each { |cents| backward.add_item!(price_cents: cents) }

        expect(backward.reload.total_cents).to eq(forward.reload.total_cents)
      end
    end
  end
end
```

**Notes**

- The permutation comes from a **generated integer**, never from `shuffle`. `Array#shuffle` uses
  global randomness, so the seed stops reproducing the failure — the one rule that quietly ruins a
  property suite.
- `rotate` covers rotations only. For full permutations, generate an index array and use it as a
  sort key: `Pbt.array(Pbt.integer(min: 0, max: 999), min: n, max: n)` zipped with the operations.

**First false positive:** the operations are not actually independent (the second item gets a
volume discount from the first). Then the property is wrong, not the code — rewrite the sentence
to describe the real rule, or drop it and keep R3 instead.

---

## R6 — Round-trip serialization

**Use for:** `as_json`/`from_json` pairs, CSV and EDI importers, `serialize`, export/import features,
API payload builders with a parser on the other side.

**Property sentence:** "Decoding an encoded record returns the same record."

```ruby
it "round-trips through the export format" do
  Pbt.assert do
    Pbt.property(PbtRails.arb_for(Shipment, only: %i[reference weight_grams shipped_on])) do |attrs|
      PbtRails.isolated do
        shipment = Shipment.create!(attrs)
        decoded = Shipment::Import.parse(Shipment::Export.render(shipment))

        attrs.each_key do |name|
          expect(decoded.public_send(name)).to eq(shipment.public_send(name)), "#{name} did not survive the round trip"
        end
      end
    end
  end
end
```

**Notes**

- Round trips are where the default alphanumeric string generator earns its replacement. Override
  with `reference: Pbt.printable_ascii_string(min: 1, max: 20)` once R1 is green: delimiters, quotes
  and whitespace are exactly what a CSV or EDI writer gets wrong.
- Encode-decode-encode (`render(parse(render(x))) == render(x)`) is a weaker but useful fallback when
  the decoded object is not comparable.

**First false positive:** the format is lossy by design (rounds money to whole units, drops
timezone). Then the property is "decoding returns the same record **up to the documented loss**" —
assert the normalized form, and record the loss in CATALOG.md.

---

## R7 — Partition completeness (complementary scopes)

**Use for:** `active`/`inactive`, `paid`/`unpaid`, `overdue`/`current`, any pair of scopes a
dashboard adds together.

**Property sentence:** "Every row is in exactly one of the two scopes, whatever it looks like."

```ruby
it "splits every invoice into exactly one of paid and unpaid" do
  Pbt.assert do
    Pbt.property(Pbt.array(PbtRails.arb_for(Invoice, only: %i[amount_cents paid_cents status]), min: 1, max: 15)) do |rows|
      PbtRails.isolated do
        rows.each { |attrs| Invoice.create!(attrs.merge(account_id: account.id)) }

        paid = Invoice.paid.pluck(:id)
        unpaid = Invoice.unpaid.pluck(:id)

        expect(paid & unpaid).to be_empty, "invoices counted twice: #{(paid & unpaid).inspect}"
        expect((paid + unpaid).sort).to eq(Invoice.pluck(:id).sort), "invoices in neither scope"
      end
    end
  end
end
```

**Notes**

- This is the cheapest high-yield property in the catalog. Partition bugs come from `NULL`
  comparisons and from a status added later that neither scope mentions — both show up in the first
  20 runs.
- Generate the rows; do not rely on fixtures. The point is the row the fixtures never contain.

**First false positive:** the scopes are not intended to be complementary (`unpaid` deliberately
excludes drafts). Fix the sentence: "every non-draft invoice is in exactly one of…", and add the
`status` constraint to the generator.

---

## R8 — Conservation and monotonic invariants

**Use for:** money that must not appear or vanish, quantities that must not go negative, audit trails
that must only grow.

**Property sentence:** "After any sequence of operations, <quantity> still satisfies <invariant>."

```ruby
it "never lets a transfer create or destroy money" do
  Pbt.assert do
    Pbt.property(Pbt.array(Pbt.tuple(Pbt.boolean, Pbt.integer(min: 1, max: 50_000)), max: 20)) do |transfers|
      PbtRails.isolated do
        a = Account.create!(balance_cents: 100_000)
        b = Account.create!(balance_cents: 100_000)
        total_before = a.balance_cents + b.balance_cents

        transfers.each do |a_to_b, cents|
          from, to = a_to_b ? [a, b] : [b, a]
          begin
            Transfers::Execute.new(from: from, to: to, cents: cents).call
          rescue Transfers::InsufficientFunds
            next # a documented, named rejection is part of the contract
          end
        end

        expect(a.reload.balance_cents + b.reload.balance_cents).to eq(total_before)
        expect(a.balance_cents).to be >= 0
        expect(b.balance_cents).to be >= 0
      end
    end
  end
end
```

**Notes**

- The `rescue` names one class. `rescue StandardError` here would hide the bug the property exists
  to find, and is a spec bug in its own right.
- Conservation properties are the ones most likely to find a real defect, because nobody writes
  example tests for "the sum across two accounts after 14 partial failures".
- Remember the integer shrinking behaviour: a counterexample of `[[true, 47_213]]` does not mean the
  bug needs 47,213 cents. Re-run with `Pbt.integer(min: 1, max: 3)` to find the small case.

**First false positive:** the sequence pushes an account past a limit the domain forbids
(`balance_cents` overflows a 4-byte column), so the failure is about the generator's range, not the
transfer logic. Narrow the range — and note the overflow, because a 4-byte money column is a finding
in itself.

---

## Choosing a recipe

| What you are looking at | Recipe |
|---|---|
| any model, first property | R1 |
| `enum`, `aasm`, bang methods, `transition` | R2 |
| `*_count`, stored totals, `balance`, cached aggregates | R3 |
| `idempotency_key`, `find_or_create_by`, `upsert`, webhooks, jobs | R4 |
| tags, line items, imports, merges, "order should not matter" | R5 |
| `as_json`/parse pairs, CSV/EDI, `serialize`, export features | R6 |
| complementary scopes, dashboard counts | R7 |
| ledgers, inventory, quotas, anything that must balance | R8 |

If the target fits none of these, it probably is not a property yet. Write the sentence first; if the
sentence needs an "and then usually", you have a test case, not a property.
