# frozen_string_literal: true

# 25 checks on assets/pbt_rails.rb against a real pbt checkout, with no Rails and no database.
# Run through scripts/verify_helper.sh, which clones pbt at the pinned tag and sets PBT_SRC.

pbt_src = ENV.fetch("PBT_SRC") { abort "PBT_SRC is not set. Run scripts/verify_helper.sh instead." }
$LOAD_PATH.unshift File.join(pbt_src, "lib")

require "date"
require "bigdecimal"

# --- Minimal ActiveRecord stand-in -------------------------------------------------
# Only what PbtRails.isolated touches. TX_LOG records what the helper asked for.
module ActiveRecord
  class Rollback < StandardError; end

  TX_LOG = []

  class Base
    def self.transaction(requires_new: false)
      TX_LOG << [:open, requires_new]
      yield
      TX_LOG << :committed
      nil
    rescue Rollback
      TX_LOG << :rolled_back
      nil
    rescue Exception # standard:disable Lint/RescueException
      TX_LOG << :rolled_back
      raise
    end
  end
end

# RSpec's failure class is an Exception, not a StandardError. That is the whole reason
# check 7 exists: a helper that rescues StandardError would swallow every failed expectation.
class FakeExpectationNotMetError < Exception; end # standard:disable Lint/InheritException

ENV["PBT_RUNS"] = "7"
ENV["PBT_SEED"] = "123456789"

require_relative "../assets/pbt_rails"

# --- Fake schema -------------------------------------------------------------------
Column = Struct.new(:name, :type, :limit, :precision, :scale, :null, :default, keyword_init: true) do
  def initialize(name:, type:, limit: nil, precision: nil, scale: nil, null: true, default: nil)
    super
  end
end

Validator = Struct.new(:kind, :options, keyword_init: true) do
  def initialize(kind:, options: {})
    super
  end
end

def fake_model(label, columns:, validators: {}, enums: {})
  Class.new do
    define_singleton_method(:columns) { columns }
    define_singleton_method(:primary_key) { "id" }
    define_singleton_method(:inheritance_column) { "type" }
    define_singleton_method(:locking_column) { "lock_version" }
    define_singleton_method(:defined_enums) { enums }
    define_singleton_method(:validators_on) { |attr| validators.fetch(attr.to_s, []) }
    define_singleton_method(:name) { label }
    define_singleton_method(:to_s) { label }
  end
end

ENTRY = fake_model(
  "LedgerEntry",
  columns: [
    Column.new(name: "id", type: :integer, null: false),
    Column.new(name: "account_id", type: :integer, null: false),
    Column.new(name: "type", type: :string),
    Column.new(name: "lock_version", type: :integer, null: false, default: 0),
    Column.new(name: "created_at", type: :datetime, null: false),
    Column.new(name: "updated_at", type: :datetime, null: false),
    Column.new(name: "memo", type: :string, limit: 24),
    Column.new(name: "amount_cents", type: :integer, null: false),
    Column.new(name: "sequence", type: :integer, null: false),
    Column.new(name: "settled", type: :boolean, null: false),
    Column.new(name: "rate", type: :decimal, precision: 8, scale: 4),
    Column.new(name: "weight", type: :float),
    Column.new(name: "effective_on", type: :date),
    Column.new(name: "posted_at", type: :datetime),
    Column.new(name: "state", type: :string, null: false),
    Column.new(name: "currency", type: :string, null: false)
  ],
  validators: {
    "amount_cents" => [Validator.new(kind: :numericality, options: {greater_than: 0, less_than_or_equal_to: 100})],
    "memo" => [Validator.new(kind: :presence), Validator.new(kind: :length, options: {maximum: 12})],
    "currency" => [Validator.new(kind: :inclusion, options: {in: %w[USD EUR JPY]})],
    "rate" => [Validator.new(kind: :numericality, options: {greater_than_or_equal_to: 0})]
  },
  enums: {"state" => {"pending" => 0, "settled" => 1, "failed" => 2}}
)

SAMPLES = 300
RNG = -> { Random.new(20_200_101) }

def samples(arb, key = nil)
  rng = RNG.call
  Array.new(SAMPLES) { key ? arb.generate(rng)[key] : arb.generate(rng) }
end

# --- Runner ------------------------------------------------------------------------
$passed = 0
$failed = []

def check(name)
  ok = yield
  raise "returned #{ok.inspect}" unless ok == true

  $passed += 1
  puts "  ok  #{name}"
rescue Exception => e # standard:disable Lint/RescueException
  $failed << name
  puts "FAIL  #{name}: #{e.class}: #{e.message}"
end

puts "pbt: #{File.read(File.join(pbt_src, "lib/pbt/version.rb"))[/"(.+)"/, 1]}  ruby: #{RUBY_VERSION}"

# 1
check "worker is forced to :none" do
  Pbt.configuration.worker == :none
end

# 2
check "PBT_RUNS and PBT_SEED are honored" do
  Pbt.configuration.num_runs == 7 && Pbt.configuration.seed == 123_456_789
end

# 3
check "isolated returns the block's value" do
  PbtRails.isolated { 42 } == 42
end

# 4
check "isolated opens a savepoint and always rolls it back" do
  ActiveRecord::TX_LOG.clear
  PbtRails.isolated { :work }
  ActiveRecord::TX_LOG == [[:open, true], :rolled_back]
end

# 5
check "isolated re-raises StandardError and still rolls back" do
  ActiveRecord::TX_LOG.clear
  raised = begin
    PbtRails.isolated { raise ArgumentError, "boom" }
    nil
  rescue ArgumentError => e
    e.message
  end
  raised == "boom" && ActiveRecord::TX_LOG == [[:open, true], :rolled_back]
end

# 6
check "isolated re-raises a non-StandardError (RSpec expectation failures)" do
  ActiveRecord::TX_LOG.clear
  raised = begin
    PbtRails.isolated { raise FakeExpectationNotMetError, "expected 1, got 2" }
    nil
  rescue FakeExpectationNotMetError => e
    e.message
  end
  raised == "expected 1, got 2" && ActiveRecord::TX_LOG == [[:open, true], :rolled_back]
end

# 7
check "isolated nests" do
  ActiveRecord::TX_LOG.clear
  PbtRails.isolated { PbtRails.isolated { :inner } }
  ActiveRecord::TX_LOG == [[:open, true], [:open, true], :rolled_back, :rolled_back]
end

# 8
check "arb_for returns a Pbt arbitrary producing attribute hashes" do
  arb = PbtRails.arb_for(ENTRY)
  arb.is_a?(Pbt::Arbitrary::Arbitrary) && arb.generate(Random.new(1)).is_a?(Hash)
end

# 9
check "structural columns are excluded (pk, timestamps, STI, locking, foreign keys)" do
  keys = PbtRails.arb_for(ENTRY).generate(Random.new(1)).keys
  (keys & %i[id created_at updated_at type lock_version account_id]).empty? &&
    keys.include?(:amount_cents)
end

# 10
check "the same seed reproduces the same attributes" do
  arb = PbtRails.arb_for(ENTRY)
  arb.generate(Random.new(42)) == arb.generate(Random.new(42))
end

# 11
check "shrink yields hashes with the same keys" do
  arb = PbtRails.arb_for(ENTRY)
  value = arb.generate(Random.new(3))
  shrunk = arb.shrink(value).first(5)
  !shrunk.empty? && shrunk.all? { |h| h.keys == value.keys }
end

# 12
check "only: and except: select columns" do
  only = PbtRails.arb_for(ENTRY, only: %i[amount_cents settled]).generate(Random.new(1))
  except = PbtRails.arb_for(ENTRY, except: %i[amount_cents]).generate(Random.new(1))
  only.keys.sort == %i[amount_cents settled] && !except.key?(:amount_cents)
end

# 13
check "overrides replace generators, wrap plain values, and can re-add skipped columns" do
  arb = PbtRails.arb_for(ENTRY, account_id: 7, currency: Pbt.constant("CHF"))
  values = samples(arb)
  values.all? { |h| h[:account_id] == 7 && h[:currency] == "CHF" }
end

# 14
check "unvalidated integer and boolean columns get bounded default generators" do
  values = samples(PbtRails.arb_for(ENTRY))
  integers = values.map { |h| h[:sequence] }
  booleans = values.map { |h| h[:settled] }
  integers.all? { |v| v.is_a?(Integer) && v.abs <= PbtRails::INT_RANGE } && integers.uniq.size > 1 &&
    booleans.uniq.sort_by(&:to_s) == [false, true]
end

# 15
check "numericality bounds narrow the generator (greater_than / less_than_or_equal_to)" do
  values = samples(PbtRails.arb_for(ENTRY), :amount_cents)
  values.all? { |v| v.is_a?(Integer) && v >= 1 && v <= 100 } && values.uniq.size > 1
end

# 16
check "strings respect presence and length, and survive a round trip unchanged" do
  values = samples(PbtRails.arb_for(ENTRY), :memo)
  values.all? { |v| v.is_a?(String) && !v.empty? && v.length <= 12 && v == v.strip && v.encoding == Encoding::UTF_8 }
end

# 17
check "decimal columns respect precision and scale, and shrink through the unmapper" do
  arb = PbtRails.arb_for(ENTRY, only: %i[rate])
  values = samples(arb, :rate)
  in_range = values.all? do |v|
    v.is_a?(BigDecimal) && v >= 0 && v <= BigDecimal("9999.9999") && (v * 10_000).frac.zero?
  end
  start = arb.generate(RNG.call)
  shrunk = arb.shrink(start).first(5)
  in_range && !shrunk.empty? && shrunk.all? { |h| h[:rate].is_a?(BigDecimal) } &&
    shrunk.last[:rate].abs <= start[:rate].abs
end

# 18
check "float columns are generated in hundredths and shrink through the unmapper" do
  arb = PbtRails.arb_for(ENTRY, only: %i[weight])
  values = samples(arb, :weight)
  hundredths = values.all? { |v| v.is_a?(Float) && ((v * 100) - (v * 100).round).abs < 1e-6 }
  start = arb.generate(RNG.call)
  shrunk = arb.shrink(start).first(5)
  hundredths && !shrunk.empty? && shrunk.all? { |h| h[:weight].is_a?(Float) } &&
    shrunk.last[:weight].abs <= start[:weight].abs
end

# 19
check "dates and times are anchored to a fixed base, never to the wall clock" do
  values = samples(PbtRails.arb_for(ENTRY))
  dates = values.map { |h| h[:effective_on] }
  times = values.map { |h| h[:posted_at] }
  dates.all? { |d| d.is_a?(Date) && (d - PbtRails::BASE_DATE).abs <= PbtRails::DAY_RANGE } &&
    times.all? { |t| t.is_a?(Time) && (t - PbtRails::BASE_TIME).abs <= PbtRails::SECOND_RANGE && t.sec == t.sec.to_i && (t - PbtRails::BASE_TIME) % 1 == 0 }
end

# 20
check "enum columns generate declared keys only" do
  values = samples(PbtRails.arb_for(ENTRY), :state)
  values.uniq.sort == %w[failed pending settled]
end

# 21
check "inclusion validators generate allowed values only" do
  values = samples(PbtRails.arb_for(ENTRY), :currency)
  (values.uniq - %w[USD EUR JPY]).empty? && values.uniq.size == 3
end

# 22
check "format validators are refused with a message that names the column" do
  model = fake_model("Contact",
    columns: [Column.new(name: "email", type: :string, null: false)],
    validators: {"email" => [Validator.new(kind: :format, options: {with: /@/})]})
  begin
    PbtRails.arb_for(model)
    false
  rescue PbtRails::Unsupported => e
    e.message.include?("Contact#email") && e.message.include?("override")
  end
end

# 23
check "conditional validators are ignored, not silently applied" do
  model = fake_model("Draft",
    columns: [Column.new(name: "score", type: :integer, null: false)],
    validators: {"score" => [
      Validator.new(kind: :numericality, options: {greater_than: 1_000_000, if: :published?})
    ]})
  values = samples(PbtRails.arb_for(model), :score)
  values.any? { |v| v < 1_000_000 }
end

# 24
check "unmodelled column types are skipped when nullable and refused when NOT NULL" do
  nullable = fake_model("Doc", columns: [
    Column.new(name: "payload", type: :jsonb, null: true),
    Column.new(name: "title", type: :string, null: false)
  ])
  required = fake_model("Doc", columns: [Column.new(name: "payload", type: :jsonb, null: false)])
  skipped = !PbtRails.arb_for(nullable).generate(Random.new(1)).key?(:payload)
  refused = begin
    PbtRails.arb_for(required)
    false
  rescue PbtRails::Unsupported => e
    e.message.include?("payload")
  end
  skipped && refused
end

# 25
check "a generated hash drives Pbt.property as keyword arguments without losing its shape" do
  seen = []
  Pbt.assert(num_runs: 5) do
    Pbt.property(PbtRails.arb_for(ENTRY, only: %i[amount_cents settled])) do |attrs|
      seen << attrs
    end
  end
  seen.size == 5 && seen.all? { |a| a.is_a?(Hash) && a.keys.sort == %i[amount_cents settled] }
end

puts
puts "#{$passed}/#{$passed + $failed.size} checks passed"
unless $failed.empty?
  puts "failed: #{$failed.join(", ")}"
  exit 1
end
