require 'spec_helper'

describe Employee do

  describe "validations" do
    let(:employee) { Employee.new }

    before do
      employee.valid?
    end

    describe "presence" do
      it "validates the presence of first_name" do
        employee.should have(1).error_on(:first_name)
      end

      it "validates the presence of last_name" do
        employee.should have(1).error_on(:last_name)
      end
    end

    describe "uniqueness" do
      let!(:existing_employee) { FactoryGirl.create(:employee) }

      context "with a common company" do
        before do
          employee.company = existing_employee.company
        end

        context "with a common last_name" do
          before do
            employee.last_name = existing_employee.last_name
          end

          context "with a unique first_name" do
            before do
              employee.first_name = "xxx"
            end

            it "validates the uniqueness of first_name" do
              employee.should have(0).error_on(:first_name)
            end
          end

          context "with a duplicate first_name" do
            before do
              employee.first_name = existing_employee.first_name
            end

            it "validates the uniqueness of first_name" do
              employee.should have(1).error_on(:first_name)
            end
          end
        end
      end

      context "with different companies" do
        context "with a common last_name" do
          before do
            employee.last_name = existing_employee.last_name
          end

          context "with a unique first_name" do
            before do
              employee.first_name = "xxx"
            end

            it "validates the uniqueness of first_name" do
              employee.should have(0).error_on(:first_name)
            end
          end

          context "with a duplicate first_name" do
            before do
              employee.first_name = existing_employee.first_name
            end

            it "validates the uniqueness of first_name" do
              employee.should have(0).error_on(:first_name)
            end
          end
        end
      end
    end
  end

  describe ".available" do
    subject { Employee.available }
    let!(:team_membership) { FactoryGirl.create(:team_membership)  }
    let!(:other_team_membership) { FactoryGirl.create(:team_membership)  }
    let!(:team) { team_membership.team }
    let(:employee) { team_membership.employee }
    let(:other_employee) { other_team_membership.employee }

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
                             start_date: Date.parse("12/31/1999"),
                             end_date: Date.parse("1/1/2012"))
        end
        let!(:active_membership) do
          FactoryGirl.create(:team_membership, employee: unavailable_employee)
        end
        let(:unavailable_employee) { completed_membership.employee }

        it { should_not include(unavailable_employee) }
        it { should_not include(employee) }
        it { should_not include(other_employee) }
      end
    end

    context "with available employees" do
      context "when the employee has no memberships" do
        let!(:no_membership_employee) { FactoryGirl.create(:employee) }

        it { should include(no_membership_employee) }
        it { should_not include(employee) }
        it { should_not include(other_employee) }
      end

      context "when employee has expired memberships" do
        let!(:completed_membership) do
          FactoryGirl.create(:team_membership,
                             team: team,
                             start_date: Date.parse("12/31/1999"),
                             end_date: Date.parse("1/1/2012"))
        end
        let(:available_employee) { completed_membership.employee }

        context "for the current team" do
          it { should include(available_employee) }
          it { should_not include(employee) }
          it { should_not include(other_employee) }
        end

        context "for a different team" do
          let(:team) { FactoryGirl.create(:team) }

          it { should include(available_employee) }
          it { should_not include(employee) }
          it { should_not include(other_employee) }
        end
      end
    end
  end

  describe "#name" do
    let(:employee) { FactoryGirl.build(:employee) }
    let(:full_name) { [employee.last_name, employee.first_name].join(", ") }

    it "returns the employee's full name" do
      employee.name.should == full_name
    end
  end

  describe ".ordered_by_last_name" do
    subject { Employee.ordered_by_last_name }
    let!(:first_employee) { FactoryGirl.create(:employee, last_name: "Aaaaa") }
    let!(:second_employee) { FactoryGirl.create(:employee, last_name: "Zzzzz") }

    it { should == [first_employee, second_employee] }
  end

end
