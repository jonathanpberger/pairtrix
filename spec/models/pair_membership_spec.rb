require 'spec_helper'

describe PairMembership do
  describe "validations" do
    let(:pair_membership) { PairMembership.new }

    before do
      pair_membership.valid?
    end

    describe "presence" do
      it "validates the presence of pair_id" do
        pair_membership.should have(1).error_on(:pair_id)
      end

      it "validates the presence of team_membership_id" do
        pair_membership.should have(1).error_on(:team_membership_id)
      end
    end
  end
end
