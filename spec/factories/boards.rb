FactoryBot.define do
  factory :board do
    association :creator, factory: :user
    association :game
    title { "テスト掲示板" }
  end
end
