class User < ActiveRecord::Base
  attr_accessible :admin, :email, :name, :provider, :uid

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
end
