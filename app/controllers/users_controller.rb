class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:show]

  def dashboard
    @user = current_user
  end

end
