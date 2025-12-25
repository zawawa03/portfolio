FactoryBot.define do
  factory :room_tag do
    association :tag
    association :room
  end
end
