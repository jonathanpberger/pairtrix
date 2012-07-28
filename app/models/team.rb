class Team < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :team_memberships, dependent: :destroy
  has_many :employees, through: :team_memberships

  has_many :pairing_days, dependent: :destroy
end
