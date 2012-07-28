class TeamMembership < ActiveRecord::Base
  attr_accessible :team_id, :employee_id, :start_date, :end_date

  belongs_to :team
  belongs_to :employee

  validates_presence_of :team_id, :employee_id, :start_date

  def active?
    end_date.nil? || end_date > Date.current
  end

end
