require 'spec_helper'

describe TeamMembership do
  describe "validations" do
    let(:team_membership) { TeamMembership.new }

    before do
      team_membership.valid?
    end

    describe "presence" do
      it "validates the presence of team_id" do
        team_membership.should have(1).error_on(:team_id)
      end

      it "validates the presence of employee_id" do
        team_membership.should have(1).error_on(:employee_id)
      end

      it "validates the presence of start_date" do
        team_membership.should have(1).error_on(:start_date)
      end
    end
  end
end
