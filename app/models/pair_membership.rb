class PairMembership < ActiveRecord::Base
  attr_accessible :team_membership_id, :pair_id

  belongs_to :pair, inverse_of: :pair_memberships
  belongs_to :team_membership

  validates_presence_of :team_membership, :pair

  def name
    team_membership.employee.name
  end

end
