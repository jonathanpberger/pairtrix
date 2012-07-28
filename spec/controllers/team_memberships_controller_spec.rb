require 'spec_helper'

describe TeamMembershipsController do

  def valid_attributes
    FactoryGirl.attributes_for(:team_membership).merge!(employee_id: 1)
  end

  def valid_session
    {}
  end

  def mock_admin
    user = mock(:user, admin?: true)
    controller.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    it "assigns all team_memberships as @team_memberships" do
      team_membership = FactoryGirl.create(:team_membership)
      get :index, { team_id: team_membership.team.to_param }, valid_session
      assigns(:team_memberships).should eq([team_membership])
    end
  end

  describe "GET show" do
    it "assigns the requested team_membership as @team_membership" do
      team_membership = FactoryGirl.create(:team_membership)
      get :show, { id: team_membership.to_param }, valid_session
      assigns(:team_membership).should eq(team_membership)
    end
  end

  describe "GET new" do
    it "assigns a new team_membership as @team_membership" do
      mock_admin
      team = FactoryGirl.create(:team)
      get :new, { team_id: team.to_param }, valid_session
      assigns(:team_membership).should be_a_new(TeamMembership)
    end
  end

  describe "GET edit" do
    it "assigns the requested team_membership as @team_membership" do
      mock_admin
      team_membership = FactoryGirl.create(:team_membership)
      get :edit, { id: team_membership.to_param }, valid_session
      assigns(:team_membership).should eq(team_membership)
    end
  end

  describe "POST create" do
    let!(:team) { FactoryGirl.create(:team) }

    before do
      mock_admin
    end

    describe "with valid params" do
      it "creates a new TeamMembership" do
        expect {
          post :create, { team_id: team.to_param, team_membership: valid_attributes }, valid_session
        }.to change(TeamMembership, :count).by(1)
      end

      it "assigns a newly created team_membership as @team_membership" do
        post :create, { team_id: team.to_param, team_membership: valid_attributes }, valid_session
        assigns(:team_membership).should be_a(TeamMembership)
        assigns(:team_membership).should be_persisted
      end

      it "redirects to the created team_membership" do
        post :create, { team_id: team.to_param, team_membership: valid_attributes }, valid_session
        response.should redirect_to(team_url(team))
      end
    end

    describe "with invalid params" do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        TeamMembership.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns a newly created but unsaved team_membership as @team_membership" do
        post :create, { team_id: team.to_param, team_membership: { } }, valid_session
        assigns(:team_membership).should be_a_new(TeamMembership)
      end

      it "re-renders the 'new' template" do
        post :create, { team_id: team.to_param, team_membership: { } }, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let!(:team_membership) { FactoryGirl.create(:team_membership) }
    let(:team) { team_membership.team }

    before do
      mock_admin
    end

    describe "with valid params" do
      it "updates the requested team_membership" do
        TeamMembership.any_instance.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
        put :update, { id: team_membership.to_param, team_membership: {'these' => 'params'} }, valid_session
      end

      it "assigns the requested team_membership as @team_membership" do
        put :update, { id: team_membership.to_param, team_membership: valid_attributes}, valid_session
        assigns(:team_membership).should eq(team_membership)
      end

      it "redirects to the team_membership" do
        put :update, { id: team_membership.to_param, team_membership: valid_attributes}, valid_session
        response.should redirect_to(team_url(team))
      end
    end

    describe "with invalid params" do

      before do
        # Trigger the behavior that occurs when invalid params are submitted
        TeamMembership.any_instance.stub(:save).and_return(false)
      end

      it "assigns the team_membership as @team_membership" do
        put :update, { id: team_membership.to_param, team_membership: {} }, valid_session
        assigns(:team_membership).should eq(team_membership)
      end

      it "re-renders the 'edit' template" do
        put :update, { id: team_membership.to_param, team_membership: {} }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:team_membership) { FactoryGirl.create(:team_membership) }
    let(:team) { team_membership.team }

    before do
      mock_admin
    end

    it "destroys the requested team_membership" do
      expect {
        delete :destroy, { id: team_membership.to_param }, valid_session
      }.to change(TeamMembership, :count).by(-1)
    end

    it "redirects to the team_memberships list" do
      delete :destroy, { id: team_membership.to_param }, valid_session
      response.should redirect_to(team_url(team))
    end
  end
end
