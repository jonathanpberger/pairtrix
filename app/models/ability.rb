class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end

    can :create, MembershipRequest
    can :update, MembershipRequest, company: { user_id: user.id }

    can :update, Company, user_id: user.id
    can :create, Company, user_id: user.id
    can :destroy, Company, user_id: user.id


    can :update, Employee do |employee|
      employee.company.has_membership_for?(user)
    end
    can :create, Employee do |employee|
      employee.company.has_membership_for?(user)
    end
    can :destroy, Employee do |employee|
      employee.company.has_membership_for?(user)
    end

    can :update, Team do |team|
      team.company.has_membership_for?(user)
    end
    can :create, Team do |team|
      team.company.has_membership_for?(user)
    end
    can :destroy, Team do |team|
      team.company.has_membership_for?(user)
    end

    can :update, TeamMembership do |team_membership|
      team_membership.team.company.has_membership_for?(user)
    end
    can :create, TeamMembership do |team_membership|
      team_membership.team.company.has_membership_for?(user)
    end
    can :destroy, TeamMembership do |team_membership|
      team_membership.team.company.has_membership_for?(user)
    end

    can :update, PairingDay do |pairing_day|
      pairing_day.team.company.has_membership_for?(user)
    end
    can :create, PairingDay do |pairing_day|
      pairing_day.team.company.has_membership_for?(user)
    end
    can :destroy, PairingDay do |pairing_day|
      pairing_day.team.company.has_membership_for?(user)
    end

    can :update, Pair do |pair|
      pair.pairing_day.team.company.has_membership_for?(user)
    end
    can :create, Pair do |pair|
      pair.pairing_day.team.company.has_membership_for?(user)
    end
    can :destroy, Pair do |pair|
      pair.pairing_day.team.company.has_membership_for?(user)
    end
  end
end
