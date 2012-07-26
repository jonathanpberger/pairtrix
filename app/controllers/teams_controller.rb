class TeamsController < ApplicationController

  before_filter :load_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = Team.all
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(params[:team])

    if @team.save
      redirect_to teams_url, flash: { success: 'Team was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @team.update_attributes(params[:team])
      redirect_to teams_url, flash: { success: 'Team was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url
  end

  private

  def load_team
    @team = Team.find(params[:id])
  end
end
