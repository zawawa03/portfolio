FactoryBot.define do
  factory :room do
    association :creator, factory: :user
    association :game
    title { "ゲーム" }
    body { "よろしく" }
    people { 5 }
    category { 0 }
  end
end
