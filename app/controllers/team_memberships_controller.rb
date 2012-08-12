class TeamMembershipsController < ApplicationController

  load_and_authorize_resource :team
  load_and_authorize_resource :team_membership, through: :team, shallow: true

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
end
