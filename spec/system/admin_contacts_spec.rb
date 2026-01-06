require 'rails_helper'

RSpec.describe "AdminContacts", type: :system do
  describe "管理画面" do
    include AdminLoginMacros

    let!(:user) { FactoryBot.create(:user, email: "user_01@example.com", role: "admin") }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let!(:contact) { FactoryBot.create(:contact, name: "吉田") }

    before { login_admin(user) }

    context "お問い合わせ機能" do
      it "お問い合わせ一覧にアクセスできる" do
        find(".navbar-toggler").click
        click_on "お問い合わせ一覧"
        expect(page).to have_content("お問い合わせ一覧")
      end
      
      it "お問い合わせ詳細にアクセスできる" do
        find(".navbar-toggler").click
        click_on "お問い合わせ一覧"
        click_link "詳細", href: "/admin/contacts/#{contact.id}"
        expect(page).to have_content("お問い合わせ詳細")
        expect(page).to have_content("お問い合わせ内容のテスト")
      end

      it "お問い合わせを削除できる" do
        find(".navbar-toggler").click
        click_on "お問い合わせ一覧"
        click_link "削除", href: "/admin/contacts/#{contact.id}"
        accept_confirm do
          expect(page.driver.browser.switch_to.alert.text).to eq("お問い合わせを削除しますか？")
        end
        expect(page).to have_content("お問い合わせを削除しました")
      end

      it "名前で検索できる" do
        find(".navbar-toggler").click
        click_on "お問い合わせ一覧"
        fill_in "q[name]", with: "吉田"
        click_on "検索"
        expect(page).to have_content("吉田")
      end
    end
  end
end
