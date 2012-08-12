class UsersController < ApplicationController

  before_filter :authenticate_user!, only: :dashboard
  skip_authorization_check

  def dashboard
    @user = current_user
  end

end
