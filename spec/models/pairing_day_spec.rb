require 'spec_helper'

describe PairingDay do
  describe "validations" do
    subject { pairing_day }
    let(:pairing_day) { PairingDay.new }

    before do
      pairing_day.valid?
    end

    describe "presence" do
      describe "team_id" do
        it { should have(1).error_on(:team_id) }
      end

      describe "pairing_date" do
        it { should have(1).error_on(:pairing_date) }
      end
    end

    describe "uniqueness" do
      let!(:existing_pairing_day) { FactoryGirl.create(:pairing_day) }

      before do
        pairing_day.team_id = existing_pairing_day.team_id
      end

      context "with a unique pairing_date" do
        before do
          pairing_day.pairing_date = "1999-12-31"
        end

        it "validates the uniqueness of pairing_date" do
          pairing_day.should have(0).error_on(:pairing_date)
        end
      end

      context "with a duplicate pairing_date" do
        before do
          pairing_day.pairing_date = existing_pairing_day.pairing_date
        end

        it "validates the uniqueness of pairing_date" do
          pairing_day.should have(1).error_on(:pairing_date)
        end
      end
    end
  end

  describe "#to_param" do
    subject { pairing_day.to_param }
    let(:pairing_day) { FactoryGirl.create(:pairing_day, pairing_date: Date.parse("12/31/1999")) }

    it { should == "#{pairing_day.id}-1999-12-31" }
  end
end
