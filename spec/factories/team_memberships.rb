FactoryGirl.define do
  factory :team_membership do
    employee
    team
    start_date { Date.current }
  end
end
