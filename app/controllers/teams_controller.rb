class TeamsController < ApplicationController
  respond_to :html, :json

  load_and_authorize_resource :company
  load_and_authorize_resource :team, through: :company, shallow: true

  def index
    @teams = @company.teams.all
  end

  def show
  end

  def new
    @team = @company.teams.build
  end

  def edit
  end

  def create
    @team = @company.teams.new(params[:team])
    @team.save
    respond_with @team, location: company_teams_url(@company)
  end

  def update
    if @team.update_attributes(params[:team])
      redirect_to company_teams_url(@team.company), flash: { success: 'Team was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @team.destroy
    respond_with @team, location: company_teams_url(@team.company)
  end
end
