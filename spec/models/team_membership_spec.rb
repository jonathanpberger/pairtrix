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

  describe "#active?" do
    subject { team_membership.active? }
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
