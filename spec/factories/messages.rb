FactoryBot.define do
  factory :message do
    association :room
    association :user
    body { "よろしく" }
  end
end
