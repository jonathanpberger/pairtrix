require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    before do
      controller.stub(:current_user).and_return(has_current_user)
    end
    context "with a current_user" do
      let(:has_current_user) { true }
      it "redirects to user dashboard" do
        get 'new'
        response.should redirect_to(dashboard_url)
      end
    end

    context "without a current user" do
      let(:has_current_user) { false }
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end
  end

  describe "create" do
    it "should redirect to root" do
      user = mock_model(User)
      User.should_receive(:from_omniauth).and_return(user)
      post 'create'
      session[:user_id].should == user.id
      flash[:notice].should =~ /Signed in/i
      response.should redirect_to(root_url)
    end
  end

  describe "destroy" do
    it "should redirect to root" do
      post 'destroy'
      session[:user_id].should be_nil
      flash[:notice].should =~ /Signed out/i
      response.should redirect_to(root_url)
    end
  end

  describe "failure" do
    it "should redirect to root" do
      post 'failure'
      flash[:error].should =~ /failed/i
      response.should redirect_to(root_url)
    end
  end
end
