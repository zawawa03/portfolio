FactoryBot.define do
  factory :contact do
    email { "user01@example.com" }
    name { "田中らんて" }
    body { "お問い合わせ内容のテスト" }
  end
end
