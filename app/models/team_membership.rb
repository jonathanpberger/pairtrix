class TeamMembership < ActiveRecord::Base
  attr_accessible :team_id, :employee_id

  belongs_to :team
  belongs_to :employee

  validates_presence_of :team_id, :employee_id
  validates :employee_id, uniqueness: { scope: :team_id,
                                        message: "The employee is currently a member of this team" }

  delegate :name, :solo_or_out_of_office?, to: :employee

  after_destroy :delete_pair_memberships_containing_membership

  class << self
    def sorted
      joins(:employee).order("employees.last_name ASC")
    end
  end

  private

  def delete_pair_memberships_containing_membership
    PairMembership.where(team_membership_id: self.id).destroy_all
  end
end
