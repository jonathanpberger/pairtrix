class PairMembership < ActiveRecord::Base

  belongs_to :pair, inverse_of: :pair_memberships, dependent: :destroy
  belongs_to :team_membership

  validates_presence_of :team_membership, :pair

  def name
    team_membership.employee.name
  end
end
