class TeamMembershipsController < ApplicationController

  before_filter :load_team, only: [:index, :new, :create]
  before_filter :load_team_membership, except: [:index, :new, :create]

  def index
    @team_memberships = @team.team_memberships
  end

  def show
  end

  def new
    @team_membership = @team.team_memberships.build(start_date: Date.current)
  end

  def edit
  end

  def create
    @team_membership = @team.team_memberships.build(params[:team_membership])

    if @team_membership.valid?
      @team_membership.save
      redirect_to team_url(@team_membership.team), flash: { success: 'TeamMembership was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @team_membership.update_attributes(params[:team_membership])
      redirect_to team_url(@team_membership.team), flash: { success: 'TeamMembership was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @team_membership.destroy
    redirect_to team_url(@team_membership.team)
  end

  private

  def load_team_membership
    @team_membership = TeamMembership.find(params[:id])
  end

  def load_team
    @team = Team.find(params[:team_id])
  end
end
