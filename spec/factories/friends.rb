FactoryBot.define do
  factory :friend do
    association :leader, factory: :user
    association :follower, factory: :user
    category { 0 }

    trait :friendship do
      category { 1 }
    end

    trait :blocked do
      category { 2 }
    end
  end
end
