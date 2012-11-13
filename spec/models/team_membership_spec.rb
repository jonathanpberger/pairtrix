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
    end

    describe "uniqueness" do
      let!(:existing_team_membership) { FactoryGirl.create(:team_membership) }

      context "with a unique employee_id" do
        before { team_membership.employee_id = 999999 }

        it "validates the uniqueness of employee_id" do
          team_membership.should have(0).error_on(:employee_id)
        end
      end

      context "with a duplicate employee_id" do
        before { team_membership.employee_id = existing_team_membership.employee_id }

        it "validates the uniqueness of employee_id" do
          team_membership.should have(1).error_on(:employee_id)
        end
      end
    end
  end
end
