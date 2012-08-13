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
end
