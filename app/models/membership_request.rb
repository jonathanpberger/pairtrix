class MembershipRequest < ActiveRecord::Base

  attr_accessible :company_id, :user_id, :status

  STATUSES = ["Pending", "Approved", "Denied"]

  belongs_to :company
  belongs_to :user

  validates_presence_of :company_id
  validates_presence_of :user_id
  validates_presence_of :status

  validates_inclusion_of :status, in: MembershipRequest::STATUSES, if: :status

  class << self
    def pending
      where(status: "Pending")
    end
  end
end
