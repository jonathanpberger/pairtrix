class TeamMembershipsController < ApplicationController
  respond_to :json

  load_and_authorize_resource :team
  load_and_authorize_resource :team_membership, through: :team, shallow: true

  def create
    @team_membership = @team.team_memberships.build(params[:team_membership])
    @team_membership.save
    respond_with @team_membership
  end

  def destroy
    @team_membership.destroy
    respond_with @team_membership
  end
end
