class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    can :manage, Company, user_id: user.id

    can :update, MembershipRequest, company: { user_id: user.id }
    can :create, MembershipRequest

    can :manage, CompanyMembership, company: { user_id: user.id }

    can :read, Company do |company|
      company.has_membership_for?(user)
    end

    can :manage, Employee do |employee|
      employee.company.has_membership_for?(user)
    end

    can :manage, Team do |team|
      team.company.has_membership_for?(user)
    end

    can :manage, TeamMembership do |team_membership|
      team_membership.team.company.has_membership_for?(user)
    end

    can :manage, PairingDay do |pairing_day|
      pairing_day.team.company.has_membership_for?(user)
    end

    can :manage, Pair do |pair|
      pair.pairing_day.team.company.has_membership_for?(user)
    end

    if user.admin?
      can :manage, :all
    end
  end
end
