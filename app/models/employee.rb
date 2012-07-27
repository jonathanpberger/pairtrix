class Employee < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, scope: :last_name

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

  class << self
    def completed_team_memberships
      team_memberships.where("end_date <= ?", Date.current)
    end

    def ordered_by_last_name
      order("last_name ASC, first_name ASC")
    end

    def available
      joins("LEFT OUTER JOIN team_memberships ON team_memberships.employee_id = employees.id").
      where("team_memberships.end_date <= ? OR team_memberships.id IS NULL", Date.current)
    end
  end

  def name
    [last_name, first_name].join(", ")
  end

end
