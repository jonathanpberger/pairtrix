class PairMembership < ActiveRecord::Base
  attr_accessible :team_membership_id, :pair_id

  belongs_to :pair
  belongs_to :team_membership

  validates_presence_of :team_membership_id, :pair_id

  def name
    team_membership.employee.name
  end

end
