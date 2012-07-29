FactoryGirl.define do
  factory :pair do
    pairing_day

    after(:build) do |pair|
      pair.team_memberships << FactoryGirl.build(:team_membership, team: pair.pairing_day.team)
      pair.team_memberships << FactoryGirl.build(:team_membership, team: pair.pairing_day.team)
    end
  end
end
