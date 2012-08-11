FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    user
  end
end
