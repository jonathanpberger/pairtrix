require 'spec_helper'

describe UsersController do

  describe "GET 'dashboard'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      controller.stub(:authenticate_user!).and_return(true)
      controller.should_receive(:current_user).and_return(user)
      get 'dashboard'
      response.should be_success
    end
  end

end
