FactoryBot.define do
  factory :comment do
    association :board
    association :user
    body { "よろしく" }

    trait :with_parent do
      association :parent, factory: :comment
    end
  end
end
