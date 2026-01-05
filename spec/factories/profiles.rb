FactoryBot.define do
  factory :profile do
    association :user
    nickname { "らんてくん" }
    introduction { "こんにちわ" }

    trait :another do
      nickname { "ゆうと" }
    end
  end
end
