FactoryBot.define do
  factory :game do
    name { "テストゲーム" }

    trait :with_picture do
      after(:build) do |game|
        game.picture.attach(
          io: File.open(
            Rails.root.join("spec/fixtures/files/image/test_png.png")
          ),
          filename: "test_png.png",
          content_type: "image/png"
        )
      end
    end
  end
end
