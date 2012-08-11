class TeamsController < ApplicationController

  before_filter :load_company, only: [:index, :new, :create]
  before_filter :load_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = @company.teams
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

    if @team.save
      redirect_to company_teams_url(@team.company), flash: { success: 'Team was successfully created.' }
    else
      render action: "new"
    end
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
    redirect_to company_teams_url(@team.company)
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_team
    @team = Team.find(params[:id])
  end
end
