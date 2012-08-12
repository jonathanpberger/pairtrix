class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    can :update, Company, user_id: user.id
    can :create, Company, user_id: user.id
    can :destroy, Company, user_id: user.id
  end
end
