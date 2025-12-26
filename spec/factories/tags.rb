FactoryBot.define do
  factory :tag do
    name { "ゲームモードタグ" }
    category { 0 }

    trait :category_1 do
      name { "ゲームスタイルタグ" }
      category { 1 }
    end

    trait :category_2 do
      name { "アビリティタグ" }
      category { 2 }
    end

    trait :category_3 do
      name { "掲示板タグ" }
      category { 3 }
    end
  end
end
