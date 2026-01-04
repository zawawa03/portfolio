require 'rails_helper'

RSpec.describe "Settings", type: :system do
  describe "設定画面" do
    let!(:contact) { FactoryBot.build(:contact) }

    context "設定画面" do
      it "設定画面へアクセスできる" do
        visit root_path
        click_link(href: "/setting")
        expect(page).to have_content("設定")
      end
    end

    context "利用規約" do
      it "利用規約ページへアクセスできる" do
        visit setting_path
        click_on "利用規約"
        within("#agreement_page") do
          expect(page).to have_content("利用規約")
        end
      end
    end

    context "プライバシーポリシー" do
      it "プライバシーポリシーページへアクセスできる" do
        visit setting_path
        click_on "プライバシーポリシー"
        within("#privacy_policy_page") do
          expect(page).to have_content("プライバシーポリシー")
        end
      end
    end

    context "お問い合わせ" do
      it "お問い合わせ入力フォームへアクセスできる" do
        visit setting_path
        click_on "お問い合わせ"
        expect(page).to have_content("お問い合わせ入力フォーム")
      end

      it "お問い合わせ確認ページへ遷移できる" do
        visit new_contact_path
        fill_in "名前", with: contact.name
        fill_in "メールアドレス", with: contact.email
        fill_in "お問い合わせ内容", with: contact.body
        click_on "お問い合わせ内容確認"
        within("#contact_show") do
          expect(page).to have_content("お問い合わせ内容確認")
        end
      end

      it "お問い合わせ内容が確認できる" do
        visit new_contact_path
        fill_in "名前", with: contact.name
        fill_in "メールアドレス", with: contact.email
        fill_in "お問い合わせ内容", with: contact.body
        click_on "お問い合わせ内容確認"
        within("#contact_show") do
          expect(page).to have_content(contact.name)
          expect(page).to have_content(contact.email)
          expect(page).to have_content(contact.body)
        end
      end

      it "メールアドレスを入力しないとエラー" do
        visit new_contact_path
        fill_in "名前", with: contact.name
        fill_in "お問い合わせ内容", with: contact.body
        click_on "お問い合わせ内容確認"
        expect(page).to have_content("メールアドレスを入力してください")
      end

      it "名前を入力しないとエラー" do
        visit new_contact_path
        fill_in "メールアドレス", with: contact.email
        fill_in "お問い合わせ内容", with: contact.body
        click_on "お問い合わせ内容確認"
        expect(page).to have_content("名前を入力してください")
      end

      it "内容を入力しないとエラー" do
        visit new_contact_path
        fill_in "名前", with: contact.name
        fill_in "メールアドレス", with: contact.email
        click_on "お問い合わせ内容確認"
        expect(page).to have_content("お問い合わせ内容を入力してください")
      end

      it "お問い合わせを送信できる" do
        visit new_contact_path
        fill_in "名前", with: contact.name
        fill_in "メールアドレス", with: contact.email
        fill_in "お問い合わせ内容", with: contact.body
        click_on "お問い合わせ内容確認"
        click_on "お問い合わせ送信"
        expect(page).to have_content("お問い合わせを送信しました")
      end
    end
  end
end
