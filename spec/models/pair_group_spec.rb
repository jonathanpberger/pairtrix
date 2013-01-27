require 'spec_helper'

describe PairGroup do
  let!(:left_membership) { FactoryGirl.create(:team_membership) }
  let(:team) { left_membership.team }
  let!(:top_membership) { FactoryGirl.create(:team_membership, team: team) }
  let(:pair_group) { PairGroup.new(left_membership, top_membership) }

  describe "#team" do
    subject { pair_group.team }

    it { should == team }
  end

  describe "#ids" do
    subject { pair_group.ids }
    let(:top_membership) { double("top", id: top_id) }
    let(:left_membership) { double("left", id: left_id) }

    context "with left membership id > top membership id" do
      let(:left_id) { 10 }
      let(:top_id) { 5 }

      it { should == "#{top_membership.id},#{left_membership.id}" }
    end

    context "with top membership id > left membership id" do
      let(:left_id) { 5 }
      let(:top_id) { 10 }

      it { should == "#{left_membership.id},#{top_membership.id}" }
    end
  end

  describe "#current_pair?" do
    subject { pair_group.current_pair? }
    let!(:pairing_day) { FactoryGirl.create(:pairing_day, pairing_date: pairing_date) }
    let!(:pair) { FactoryGirl.create(:pair_with_memberships, pairing_day: pairing_day) }
    let(:left_membership) { pair.team_memberships[0] }
    let(:top_membership) { pair.team_memberships[1] }

    context "when paired on the current pairing day" do
      let(:pairing_date) { Date.current }

      context "with left membership first" do
        it { should be_true }
      end

      context "with top membership first" do
        let(:top_membership) { pair.team_memberships[0] }
        let(:left_membership) { pair.team_memberships[1] }

        it { should be_true }
      end

    end

    context "when not paired on the current pairing day" do
      let(:pairing_date) { Date.parse("12/31/1999") }

      it { should be_false }
    end
  end

end
