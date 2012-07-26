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

      before do
        employee.last_name = existing_employee.last_name
      end

      context "with a unique first_name" do
        before do
          employee.first_name = "xxy"
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
