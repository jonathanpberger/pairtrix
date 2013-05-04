class TeamMembershipsController < ApplicationController
  respond_to :json

  load_and_authorize_resource :team
  load_and_authorize_resource :team_membership, through: :team, shallow: true
  permit_params :employee_id

  def create
    @team_membership = @team.team_memberships.build(team_membership_params)
    TeamMembership.where(employee_id: @team_membership.employee_id).destroy_all
    @team_membership.save
    respond_with @team_membership
  end

  def destroy
    @team_membership.destroy
    respond_with @team_membership
  end

  private

  def team_membership_params
    params.require(:team_membership).permit(:employee_id)
  end
end
