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
end
