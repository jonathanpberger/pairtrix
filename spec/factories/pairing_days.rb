FactoryGirl.define do
  factory :pairing_day do
    team
    pairing_date { Date.current }
  end
end
