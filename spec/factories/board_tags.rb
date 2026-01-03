FactoryBot.define do
  factory :board_tag do
    association :tag
    association :room
  end
end
