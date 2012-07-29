require 'spec_helper'

describe Pair do
  describe "validations" do
    subject { pair }
    let(:pair) { Pair.new }

    before do
      pair.valid?
    end

    describe "presence" do
      describe "pairing_day_id"
      it { should have(1).error_on(:pairing_day_id) }
    end
  end

  describe "#name" do
    let(:pair) { FactoryGirl.create(:pair_with_memberships) }

    it "returns the team_membership names joined by dashes" do
      pair.name.should include(pair.pair_memberships[0].name)
      pair.name.should include(pair.pair_memberships[1].name)
    end
  end

  describe "#employee_one" do
    subject { pair.employee_one }
    let(:pair) { FactoryGirl.create(:pair_with_memberships) }

    it { should == pair.pair_memberships[0].name }
  end

  describe "#employee_two" do
    subject { pair.employee_two }
    let(:pair) { FactoryGirl.create(:pair_with_memberships) }

    it { should == pair.pair_memberships[1].name }
  end

  describe "#memberships_current?" do
    subject { pair.memberships_current? }
    let!(:pair) { FactoryGirl.create(:pair_with_memberships) }

    context "with all memberships current" do
      it { should be_true }
    end

    context "with any membership not current" do
      before do
        team_membership = pair.team_memberships.first
        team_membership.end_date = 3.days.ago.to_date
        team_membership.save!
      end

      it { should be_false }
    end
  end
end
