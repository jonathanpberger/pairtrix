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

  def available_team_memberships
    team_membership_table = Arel::Table.new(:team_memberships)
    available_team_memberships = TeamMembership.current.
      where(team_membership_table[:id].not_in(paired_team_membership_ids)).
      where(team_membership_table[:team_id].eq(pairing_day.team.id)).
      joins(:employee).order("employees.last_name ASC")
    [solo_membership, out_of_office_membership, available_team_memberships].flatten.uniq
  end

  private

  def out_of_office_membership
    find_membership_for("Office")
  end

  def solo_membership
    find_membership_for("Solo")
  end

  def find_membership_for(name)
    TeamMembership.
      joins(:employee).
      where("employees.last_name = ?", name).
      where(team_id: pairing_day.team.id)
  end

  def paired_team_membership_ids
    ids = pairing_day.pairs.map(&:team_membership_ids).flatten
    ids.any? ? ids : [0]
  end

end
