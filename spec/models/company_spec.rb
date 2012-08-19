require 'spec_helper'

describe Company do
  describe "validations" do
    let(:company) { Company.new }

    before do
      company.valid?
    end

    describe "presence" do
      it "validates the presence of name" do
        company.should have(1).error_on(:name)
      end
    end

    describe "uniqueness" do
      let!(:existing_company) { FactoryGirl.create(:company) }

      before do
        company.user_id = existing_company.user_id
      end

      context "with a unique name" do
        before do
          company.name = "fakename"
        end

        it "validates the uniqueness of name" do
          company.should have(0).error_on(:name)
        end
      end

      context "with a duplicate name" do
        before do
          company.name = existing_company.name
        end

        it "validates the uniqueness of name" do
          company.should have(1).error_on(:name)
        end
      end
    end
  end

  describe "#has_membership_for?" do
    subject { company.has_membership_for?(user) }

    let(:membership_user) { FactoryGirl.create(:user) }
    let(:company_membership) { FactoryGirl.create(:company_membership, user: membership_user) }
    let(:company) { company_membership.company }

    before do
      company.should be
    end

    context "when it has a membership" do
      let(:user) { membership_user }

      it { should be_true }
    end

    context "when it doesn't have a membership" do
      let(:user) { FactoryGirl.create(:user) }

      it { should be_false }
    end
  end

  describe "#available_users" do
    subject { company.available_users }

    let!(:company) { FactoryGirl.create(:company) }
    let(:user) { company.user }
    let!(:company_membership) { FactoryGirl.create(:company_membership,
                                                   company: company,
                                                   user: user) }

    context "with no available users" do
      it { should == [] }
    end

    context "with available users" do
      let(:available_user_unpersisted_membership) { FactoryGirl.create(:user) }
      let!(:available_user) { FactoryGirl.create(:user) }

      before do
        company.company_memberships.build(user_id: available_user_unpersisted_membership.id)
      end

      it { should include(available_user) }
      it { should include(available_user_unpersisted_membership) }
      it { should_not include(user) }
    end
  end

  describe "#available_employees" do
    subject { company.available_employees }

    let!(:company) { FactoryGirl.create(:company) }
    let!(:employee) { FactoryGirl.create(:employee, company: company) }
    let!(:other_employee) { FactoryGirl.create(:employee, company: company) }

    let!(:team) { FactoryGirl.create(:team, company: company) }

    let!(:team_membership) { FactoryGirl.create(:team_membership, team: team, employee: employee) }
    let!(:other_team_membership) { FactoryGirl.create(:team_membership, team: team, employee: other_employee) }

    context "with no available employees" do
      it { should == [] }

      context "with an employee with an active end_dated membership" do
        let!(:active_membership) do
          FactoryGirl.create(:team_membership,
                             team: team,
                             start_date: Date.parse("12/31/1999"),
                             end_date: Date.current+5.days)
        end
        let(:unavailable_employee) { active_membership.employee }

        it { should_not include(unavailable_employee) }
        it { should_not include(employee) }
        it { should_not include(other_employee) }
      end

      context "and a current active membership" do
        let!(:completed_membership) do
          FactoryGirl.create(:team_membership,
                             team: team,
                             start_date: Date.parse("12/31/1999"),
                             end_date: Date.parse("1/1/2012"))
        end
        let(:unavailable_employee) { completed_membership.employee }
        let!(:active_membership) do
          FactoryGirl.create(:team_membership, employee: unavailable_employee, team: team)
        end

        it { should_not include(unavailable_employee) }
        it { should_not include(employee) }
        it { should_not include(other_employee) }
      end
    end

    context "with available employees" do
      context "when the employee has no memberships" do
        let!(:no_membership_employee) { FactoryGirl.create(:employee, company: company) }

        it { should include(no_membership_employee) }
        it { should_not include(employee) }
        it { should_not include(other_employee) }
      end

      context "when employee has expired memberships" do
        let!(:available_employee) { FactoryGirl.create(:employee, company: company) }
        let!(:completed_membership) do
          FactoryGirl.create(:team_membership,
                             employee: available_employee,
                             team: team,
                             start_date: Date.parse("12/31/1999"),
                             end_date: Date.parse("1/1/2012"))
        end

        context "for the current team" do
          it { should include(available_employee) }
          it { should_not include(employee) }
          it { should_not include(other_employee) }
        end

        context "for a different team" do
          let!(:team) { FactoryGirl.create(:team, company: company) }

          it { should include(available_employee) }
          it { should_not include(employee) }
          it { should_not include(other_employee) }
        end
      end
    end
  end
end
