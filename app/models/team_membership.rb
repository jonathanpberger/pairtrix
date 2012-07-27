class TeamMembership < ActiveRecord::Base

  belongs_to :team
  belongs_to :employee

  validates_presence_of :team_id, :employee_id, :start_date

end
