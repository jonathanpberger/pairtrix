class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :provider, :uid, :last_viewed_url, :sign_in_redirect_option

  has_many :companies
  has_many :membership_requests, dependent: :destroy
  has_many :company_memberships, dependent: :destroy

  class << self
    def from_omniauth(auth)
      where(provider: auth["provider"], uid: auth["uid"]).first || create_with_omniauth(auth)
    end

    def create_with_omniauth(auth)
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"]
      end
    end
  end

  def available_teams
    Team.joins(company: :company_memberships).
      where("company_memberships.user_id = ?", id).
      order("companies.name ASC")
  end
end
