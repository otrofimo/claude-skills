# frozen_string_literal: true

# spec/properties/pbt_rails_spec.rb
#
# Guards the two assumptions every other property spec depends on.
# If either fails, fix it before trusting any property result.
#
# Replace `SMOKE_MODEL` with one simple model from your app (no format validations,
# no required associations), or pass the needed association via overrides.

require "rails_helper"

RSpec.describe "PbtRails helper", type: :model do
  SMOKE_MODEL = Object.const_get(ENV.fetch("PBT_SMOKE_MODEL", "User")) # change me

  it "rolls back everything done inside PbtRails.isolated" do
    before = SMOKE_MODEL.count
    PbtRails.isolated do
      SMOKE_MODEL.create!(PbtRails.arb_for(SMOKE_MODEL).generate(Random.new(1)))
      expect(SMOKE_MODEL.count).to eq(before + 1)
    end
    expect(SMOKE_MODEL.count).to eq(before)
  end

  it "re-raises assertion failures from inside PbtRails.isolated (so Pbt can shrink)" do
    expect {
      PbtRails.isolated { raise RSpec::Expectations::ExpectationNotMetError, "boom" }
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError, "boom")
  end

  it "arb_for produces attribute sets the model accepts and persists losslessly" do
    Pbt.assert do
      Pbt.property(PbtRails.arb_for(SMOKE_MODEL)) do |attrs|
        PbtRails.isolated do
          record = SMOKE_MODEL.new(attrs)
          expect(record).to be_valid, -> { record.errors.full_messages.join(", ") }
          record.save!
          reloaded = SMOKE_MODEL.find(record.id)
          attrs.each_key do |k|
            expect(reloaded.public_send(k)).to eq(record.public_send(k)), "#{k} changed through the database"
          end
        end
      end
    end
  end

  it "reproduces the same generated values for the same seed" do
    arb = PbtRails.arb_for(SMOKE_MODEL)
    expect(arb.generate(Random.new(42))).to eq(arb.generate(Random.new(42)))
  end
end
