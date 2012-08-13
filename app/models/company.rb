class Company < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :user_id

  belongs_to :user

  has_many :teams, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :membership_requests, dependent: :destroy
  has_many :company_memberships, dependent: :destroy

  def has_membership_for?(user)
    company_memberships.detect { |company_membership| company_membership.user_id == user.id }
  end
end
