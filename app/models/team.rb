class Team < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :team_memberships, dependent: :destroy
  has_many :employees, through: :team_memberships

  has_many :pairing_days, dependent: :destroy
  has_many :pairs, through: :pairing_days

  after_commit :add_default_team_memberships

  private

  # we want to make sure the solo and out of office employees exist on every team
  def add_default_team_memberships
    team_memberships.create!(employee_id: Employee.solo_employee.id, start_date: Date.current-1.day)
    team_memberships.create!(employee_id: Employee.out_of_office_employee.id, start_date: Date.current-1.day)
  end

end
