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

    describe "uniqueness" do
      let(:end_date) { nil }
      let!(:existing_team_membership) { FactoryGirl.create(:team_membership,
                                                           end_date: end_date) }

      before { team_membership.team_id = existing_team_membership.team_id }

      context "with a unique employee_id" do
        before do
          team_membership.employee_id = 1
        end

        it "validates the uniqueness of employee_id" do
          team_membership.should have(0).error_on(:employee_id)
        end
      end

      context "with a duplicate employee_id" do
        before do
          team_membership.employee_id = existing_team_membership.employee_id
        end

        context "and an ended membership" do
          let(:end_date) { Date.current }

          it "validates the uniqueness of employee_id" do
            team_membership.should have(0).error_on(:employee_id)
          end
        end

        context "and an active membership" do
          it "validates the uniqueness of employee_id" do
            team_membership.should have(1).error_on(:employee_id)
          end
        end
      end
    end
  end

  describe "#current?" do
    subject { team_membership.current? }
    let(:team_membership) { FactoryGirl.build(:team_membership,
                                              start_date: Date.parse("12/31/1999"),
                                              end_date: end_date) }

    context "with a nil end date" do
      let(:end_date) { nil }

      it { should be_true }
    end

    context "with a future end date" do
      let(:end_date) { Date.current+5.days }

      it { should be_true }
    end

    context "with a past end date" do
      let(:end_date) { Date.parse("1/1/2000") }

      it { should be_false }
    end

    context "with today as end date" do
      let(:end_date) { Date.current }

      it { should be_false }
    end
  end
end
