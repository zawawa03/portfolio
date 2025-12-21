FactoryBot.define do
  factory :profile do
    association :user
    nickname { "らんてくん" }
    introduction { "こんにちわ" }
  end
end
