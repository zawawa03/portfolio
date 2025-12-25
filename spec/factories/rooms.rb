FactoryBot.define do
  factory :room do
    association :creator, factory: :user
    association :game
    title { "テストゲーム" }
    body { "よろしく" }
    people { 5 }
    category { 0 }
  end
end
