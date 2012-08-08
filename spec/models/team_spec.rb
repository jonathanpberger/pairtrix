require 'spec_helper'

describe Team do

  describe "validations" do
    let(:team) { Team.new }

    before do
      team.valid?
    end

    describe "presence" do
      it "validates the presence of name" do
        team.should have(1).error_on(:name)
      end
    end

    describe "uniqueness" do
      let!(:existing_team) { FactoryGirl.create(:team) }

      context "with a unique name" do
        before do
          team.name = "xxy"
        end

        it "validates the uniqueness of name" do
          team.should have(0).error_on(:name)
        end
      end

      context "with a duplicate name" do
        before do
          team.name = existing_team.name
        end

        it "validates the uniqueness of name" do
          team.should have(1).error_on(:name)
        end
      end
    end
  end

  describe "#current_membership_pairs" do
    subject { team.current_membership_pairs }
    let!(:team) { FactoryGirl.create(:team) }
    let!(:pairing_day) { FactoryGirl.create(:pairing_day,
                                            team: team,
                                            pairing_date: pairing_date) }
    let(:pairing_date) { Date.current }

    context "with no memberships" do
      it { should == [] }
    end

    context "with pairing days more than 1 month ago" do
      let(:pairing_date) { 32.days.ago.to_date }
      let!(:pair) { FactoryGirl.create(:pair_with_memberships, pairing_day: pairing_day) }

      it "should have valid pairs" do
        team.pairs.size.should == 1
      end

      it { should == [] }
    end

    context "with pairing days less than 1 month ago" do
      let(:pairing_date) { 5.days.ago }
      let!(:current_team_membership) { FactoryGirl.create(:team_membership,
                                                          team: team,
                                                          start_date: Date.parse("12/31/1999"))
      }
      let!(:current_team_membership_1) { FactoryGirl.create(:team_membership,
                                                            team: team,
                                                            start_date: Date.parse("12/31/1999"))
      }
      let!(:current_pair) { FactoryGirl.create(:pair,
                                               pairing_day: pairing_day,
                                               team_membership_ids: [current_team_membership.id, current_team_membership_1.id]) }

      context "that have a pair with membership that is not current" do
        let!(:expired_team_membership) { FactoryGirl.create(:team_membership,
                                                            team: team,
                                                            start_date: Date.parse("12/31/1999"),
                                                            end_date: pairing_date-5.days) }
        let!(:expired_team_membership_1) { FactoryGirl.create(:team_membership,
                                                              team: team,
                                                              start_date: Date.parse("12/31/1999"),
                                                              end_date: pairing_date-5.days) }
        let!(:expired_pair) { FactoryGirl.create(:pair,
                                                 pairing_day: pairing_day,
                                                 team_membership_ids: [expired_team_membership.id, expired_team_membership_1.id]) }

        it "should have valid pairs" do
          team.pairs.size.should == 2
        end
        it { should == [current_pair] }
      end

      context "that have pairs with all memberships that are current" do
        let!(:other_current_team_membership) { FactoryGirl.create(:team_membership,
                                                                  team: team,
                                                                  start_date: Date.parse("12/31/1999")) }
        let!(:other_current_team_membership_1) { FactoryGirl.create(:team_membership,
                                                                    team: team,
                                                                    start_date: Date.parse("12/31/1999")) }
        let!(:other_current_pair) { FactoryGirl.create(:pair,
                                                       pairing_day: pairing_day,
                                                       team_membership_ids: [other_current_team_membership.id, other_current_team_membership_1.id]) }
        it "should have valid pairs" do
          team.pairs.size.should == 2
        end
        it { should include(current_pair) }
        it { should include(other_current_pair) }
      end
    end
  end
end
