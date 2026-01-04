FactoryBot.define do
  factory :board_tag do
    association :tag
    association :board
  end
end
