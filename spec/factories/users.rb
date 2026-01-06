FactoryBot.define do
  factory :user do
    first_name { "らんて" }
    last_name { "田中" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 0 }
    uid { nil }
    provider { nil }

    trait :another do
      first_name { "ゆうと" }
      last_name { "吉田" }
    end
  end
end
