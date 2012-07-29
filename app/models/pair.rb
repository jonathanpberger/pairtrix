class Pair < ActiveRecord::Base
  attr_accessible :team_membership_ids

  belongs_to :pairing_day

  has_many :pair_memberships, dependent: :destroy
  has_many :team_memberships, through: :pair_memberships

  has_many :employees, through: :team_memberships

  validates_presence_of :pairing_day_id

  def name
    pair_memberships.map(&:name).join("-")
  end

  def employee_one
    pair_memberships[0].name
  end

  def employee_two
    pair_memberships[1].name
  end
end
