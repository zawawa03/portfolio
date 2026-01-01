FactoryBot.define do
  factory :notification do
    association :sender, factory: :user
    association :receiver, factory: :user
    category { 0 }

    trait :frend_app do
      category { 1 }
    end

    trait :friend_noti do
      category { 2 }
    end
  end
end
