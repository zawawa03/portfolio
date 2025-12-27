FactoryBot.define do
  factory :room do
    association :creator, factory: :user
    association :game
    title { "テストゲーム募集" }
    body { "よろしく" }
    people { 5 }
    category { 0 }
  end
end
