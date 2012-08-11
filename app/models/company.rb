class Company < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :user_id

  belongs_to :user

  has_many :teams, dependent: :destroy
  has_many :employees, dependent: :destroy

end
