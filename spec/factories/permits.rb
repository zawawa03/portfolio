FactoryBot.define do
  factory :permit do
    association :user
    association :room
  end
end
