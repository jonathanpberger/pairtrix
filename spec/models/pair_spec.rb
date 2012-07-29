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
    let(:pair) { FactoryGirl.create(:pair) }

    it "returns the team_membership names joined by dashes" do
      pair.name.should include(pair.pair_memberships[0].name)
      pair.name.should include(pair.pair_memberships[1].name)
    end
  end

  describe "#employee_one" do
    subject { pair.employee_one }
    let(:pair) { FactoryGirl.create(:pair) }

    it { should == pair.pair_memberships[0].name }
  end

  describe "#employee_two" do
    subject { pair.employee_two }
    let(:pair) { FactoryGirl.create(:pair) }

    it { should == pair.pair_memberships[1].name }
  end

  describe ".available_team_memberships" do
    subject { pair.available_team_memberships }

    let(:pair) { pairing_day.pairs.build }
    let!(:team) { FactoryGirl.create(:team) }
    let!(:pairing_day) { FactoryGirl.create(:pairing_day, team: team)  }

    context "with no available team memberships" do
      it { should == [] }
    end

    context "with available team memberships" do
      let!(:available_team_membership) { FactoryGirl.create(:team_membership, team: team)  }
      let!(:unavailable_team_membership) { FactoryGirl.create(:team_membership, team: team)  }
      let!(:other_team_membership) { FactoryGirl.create(:team_membership)  }
      let!(:existing_pair) { FactoryGirl.create(:pair,
                                                team_membership_ids: [unavailable_team_membership.id],
                                                pairing_day: pairing_day) }

      it { should include(available_team_membership) }
      it { should_not include(unavailable_team_membership) }
      it { should_not include(other_team_membership) }
    end
  end
end
