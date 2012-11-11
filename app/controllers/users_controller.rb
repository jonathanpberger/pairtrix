class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!, only: [:dashboard, :update]
  skip_authorization_check

  def dashboard
  end

  def update
    current_user.update_attributes(params[:user])
    respond_with current_user
  end
end
