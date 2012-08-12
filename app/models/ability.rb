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

    can :update, Employee, company: { user_id: user.id }
    can :create, Employee, company: { user_id: user.id }
    can :destroy, Employee, company: { user_id: user.id }

    can :update, Team, company: { user_id: user.id }
    can :create, Team, company: { user_id: user.id }
    can :destroy, Team, company: { user_id: user.id }
  end
end
