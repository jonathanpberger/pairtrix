require 'spec_helper'

describe TeamsController do

  def valid_attributes
    FactoryGirl.attributes_for(:team)
  end

  def valid_session
    {}
  end

  def mock_admin
    user = mock(:user, admin?: true)
    controller.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    it "assigns all teams as @teams" do
      team = FactoryGirl.create(:team)
      get :index, {}, valid_session
      assigns(:teams).should eq([team])
    end
  end

  describe "GET show" do
    it "assigns the requested team as @team" do
      team = FactoryGirl.create(:team)
      get :show, {:id => team.to_param}, valid_session
      assigns(:team).should eq(team)
    end
  end

  describe "GET new" do
    it "assigns a new team as @team" do
      mock_admin
      get :new, {}, valid_session
      assigns(:team).should be_a_new(Team)
    end
  end

  describe "GET edit" do
    it "assigns the requested team as @team" do
      mock_admin
      team = FactoryGirl.create(:team)
      get :edit, {:id => team.to_param}, valid_session
      assigns(:team).should eq(team)
    end
  end

  describe "POST create" do
    before do
      mock_admin
    end

    describe "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes}, valid_session
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}, valid_session
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes}, valid_session
        response.should redirect_to(teams_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => {}}, valid_session
        assigns(:team).should be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      mock_admin
    end

    describe "with valid params" do
      it "updates the requested team" do
        team = FactoryGirl.create(:team)
        Team.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => team.to_param, :team => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested team as @team" do
        team = FactoryGirl.create(:team)
        put :update, {:id => team.to_param, :team => valid_attributes}, valid_session
        assigns(:team).should eq(team)
      end

      it "redirects to the team" do
        team = FactoryGirl.create(:team)
        put :update, {:id => team.to_param, :team => valid_attributes}, valid_session
        response.should redirect_to(teams_url)
      end
    end

    describe "with invalid params" do
      it "assigns the team as @team" do
        team = FactoryGirl.create(:team)
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => team.to_param, :team => {}}, valid_session
        assigns(:team).should eq(team)
      end

      it "re-renders the 'edit' template" do
        team = FactoryGirl.create(:team)
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        put :update, {:id => team.to_param, :team => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      mock_admin
    end

    it "destroys the requested team" do
      team = FactoryGirl.create(:team)
      expect {
        delete :destroy, {:id => team.to_param}, valid_session
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = FactoryGirl.create(:team)
      delete :destroy, {:id => team.to_param}, valid_session
      response.should redirect_to(teams_url)
    end
  end

end
