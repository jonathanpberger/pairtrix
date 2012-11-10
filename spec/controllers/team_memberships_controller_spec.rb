require 'spec_helper'

describe TeamMembershipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:company) { FactoryGirl.create(:company, user: user) }
  let(:team) { FactoryGirl.create(:team, company: company) }
  let(:company_membership) { FactoryGirl.create(:company_membership, company: company, user: user) }

  def valid_attributes
    FactoryGirl.attributes_for(:team_membership).merge!(employee_id: 1)
  end

  def mock_user
    controller.stub(:current_user).and_return(user)
  end

  before do
    company_membership.should be
    mock_user
  end

  def do_create
    post :create, { team_id: team.to_param, team_membership: valid_attributes, format: :json }
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TeamMembership" do
        expect {
          do_create
        }.to change(TeamMembership, :count).by(1)
        assigns(:team_membership).should be_a(TeamMembership)
        assigns(:team_membership).should be_persisted
        response.body.should == assigns(:team_membership).to_json
      end
    end
  end

  describe "DELETE destroy" do
    let!(:team_membership) { FactoryGirl.create(:team_membership, team: team) }

    it "destroys the requested team_membership" do
      expect {
        delete :destroy, { id: team_membership.to_param }
      }.to change(TeamMembership, :count).by(-1)
      response.body.should == " "
    end
  end
end
