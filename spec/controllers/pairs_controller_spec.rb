require 'spec_helper'

describe PairsController do

  def valid_attributes
    FactoryGirl.attributes_for(:pair)
  end

  def valid_session
    {}
  end

  def mock_admin
    user = mock(:user, admin?: true)
    controller.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    let!(:pair) { FactoryGirl.create(:pair) }
    let(:pairing_day) { pair.pairing_day }

    it "assigns all pairs as @pairs" do
      get :index, { pairing_day_id: pairing_day.to_param, }, valid_session
      assigns(:pairs).should eq([pair])
    end
  end

  describe "GET show" do
    let!(:pair) { FactoryGirl.create(:pair) }
    let(:pairing_day) { pair.pairing_day }

    it "assigns the requested pair as @pair" do
      get :show, { id: pair.to_param }, valid_session
      assigns(:pair).should eq(pair)
    end
  end

  describe "GET new" do
    let!(:pairing_day) { FactoryGirl.create(:pairing_day) }

    it "assigns a new pair as @pair" do
      mock_admin
      get :new, { pairing_day_id: pairing_day.to_param, }, valid_session
      assigns(:pair).should be_a_new(Pair)
    end
  end

  describe "GET edit" do
    let!(:pair) { FactoryGirl.create(:pair) }
    let(:pairing_day) { pair.pairing_day }

    it "assigns the requested pair as @pair" do
      mock_admin
      get :edit, { id: pair.to_param }, valid_session
      assigns(:pair).should eq(pair)
    end
  end

  describe "POST create" do
    let!(:pairing_day) { FactoryGirl.create(:pairing_day) }
    let!(:team_membership) { FactoryGirl.create(:team_membership) }

    before do
      mock_admin
    end

    describe "with valid params" do

      it "creates a new Pair" do
        expect {
          post :create, { pairing_day_id: pairing_day.to_param, pair: valid_attributes.merge!(team_membership_ids: team_membership.id) }, valid_session
        }.to change(Pair, :count).by(1)
      end

      it "assigns a newly created pair as @pair" do
        post :create, { pairing_day_id: pairing_day.to_param, pair: valid_attributes.merge!(team_membership_ids: team_membership.id) }, valid_session
        assigns(:pair).should be_an(Pair)
        assigns(:pair).should be_persisted
      end

      context "with available team_memberships" do
        before do
          Pair.any_instance.should_receive(:available_team_memberships).and_return([double])
        end

        it "redirects to create new pair" do
          post :create, { pairing_day_id: pairing_day.to_param, pair: valid_attributes.merge!(team_membership_ids: team_membership.id) }, valid_session
          response.should redirect_to(new_pairing_day_pair_url(pairing_day))
        end
      end

      context "without available team_memberships" do
        before do
          Pair.any_instance.should_receive(:available_team_memberships).and_return([])
        end

        it "redirects to pairing_day show page" do
          post :create, { pairing_day_id: pairing_day.to_param, pair: valid_attributes.merge!(team_membership_ids: team_membership.id) }, valid_session
          response.should redirect_to(pairing_day_url(pairing_day))
        end
      end
    end

    describe "with invalid params" do
      before do
        # Trigger the behavior that occurs when invalid params are submitted
        Pair.any_instance.stub(:save).and_return(false)
      end

      it "assigns a newly created but unsaved pair as @pair" do
        post :create, { pairing_day_id: pairing_day.to_param, pair: {} }, valid_session
        assigns(:pair).should be_a_new(Pair)
      end

      it "re-renders the 'new' template" do
        post :create, { pairing_day_id: pairing_day.to_param, pair: {} }, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let!(:pair) { FactoryGirl.create(:pair) }
    let(:pairing_day) { pair.pairing_day }

    before do
      mock_admin
    end

    describe "with valid params" do
      it "updates the requested pair" do
        Pair.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, { id: pair.to_param, pair: {'these' => 'params'} }, valid_session
      end

      it "assigns the requested pair as @pair" do
        put :update, { id: pair.to_param, pair: valid_attributes }, valid_session
        assigns(:pair).should eq(pair)
      end

      it "redirects to the pair" do
        put :update, { id: pair.to_param, pair: valid_attributes }, valid_session
        response.should redirect_to(pairing_day_url(pairing_day))
      end
    end

    describe "with invalid params" do
      it "assigns the pair as @pair" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pair.any_instance.stub(:save).and_return(false)
        put :update, { id: pair.to_param, pair: {} }, valid_session
        assigns(:pair).should eq(pair)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pair.any_instance.stub(:save).and_return(false)
        put :update, { id: pair.to_param, pair: {} }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:pair) { FactoryGirl.create(:pair) }
    let(:pairing_day) { pair.pairing_day }

    before do
      mock_admin
    end

    it "destroys the requested pair" do
      expect {
        delete :destroy, { id: pair.to_param }, valid_session
      }.to change(Pair, :count).by(-1)
    end

    it "redirects to the pairs list" do
      delete :destroy, { id: pair.to_param }, valid_session
      response.should redirect_to(pairing_day_url(pairing_day))
    end
  end
end
