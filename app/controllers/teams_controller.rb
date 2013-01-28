class TeamsController < ApplicationController
  respond_to :html, :json

  load_and_authorize_resource :company
  load_and_authorize_resource :team, through: :company, shallow: true

  def index
    @teams = @company.teams.all
  end

  def show
    @uuid = SecureRandom.uuid
  end

  def new
    @team = @company.teams.build
  end

  def edit
    respond_with @team
  end

  def create
    @team = @company.teams.new(params[:team])
    @team.save
    respond_with @team, location: company_teams_url(@company)
  end

  def update
    if @team.update_attributes(params[:team])
      respond_with @team do |format|
        format.json { render json: @team.to_json, status: :accepted }
        format.html { respond_with @team, location: company_teams_url(@team.company) }
      end
    else
      respond_with @team
    end
  end

  def destroy
    @team.destroy
    respond_with @team, location: company_teams_url(@team.company)
  end
end
