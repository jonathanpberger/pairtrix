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

  describe ".available_users" do
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

end
