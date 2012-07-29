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
      employees = Employee.all
      employees.map do |employee|
        employee if (employee.team_memberships.empty? ||
          employee.team_memberships.none? { |team_membership| team_membership.active? }) &&
          !employee.hide?
      end.compact
    end

    def solo_employee
      where(last_name: "Solo").first
    end

    def out_of_office_employee
      where(last_name: "Office").first
    end
  end

  def hide?
    solo_employee? || out_of_office_employee?
  end

  def name
    [last_name, first_name].join(", ")
  end

  private

  def solo_employee?
    id == Employee.solo_employee.try(:id)
  end

  def out_of_office_employee?
    id == Employee.out_of_office_employee.try(:id)
  end

end
