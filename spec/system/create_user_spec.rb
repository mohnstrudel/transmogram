require "rails_helper"

RSpec.describe "Create user flow", :type => :system do
  before do
    driven_by(:rack_test)
  end

  context 'when creating new user' do
    before do
      visit root_path
      click_on 'sign up now'
    end

    it 'expects to redirect to users/sign_up and display proper fields' do
      expect(current_path).to eq "/users/sign_up"
      expect(page).to have_xpath("//input[@name='user[email]']")
      expect(page).to have_xpath("//input[@name='user[nickname]']")
      expect(page).to have_xpath("//input[@name='user[password]']")
      expect(page).to have_xpath("//input[@name='user[password_confirmation]']")
    end

    it 'expects to create a user after filling out those fields and redirect him to root path' do
      # Stub Gibbon API call to Mailchimp
      allow_any_instance_of(User).to receive(:subscribe).and_return("ok")

      fill_in 'user_email', with: "sambo@mambo.five"
      fill_in 'user_nickname', with: "Leeeroy"
      fill_in 'user_password', with: "password123"
      fill_in 'user_password_confirmation', with: "password123"

      expect {
        click_on 'Proceed'
      }.to change {User.count}.from(0).to(1)

      expect(current_path).to eq root_path
      expect(User.last.nickname).to eq 'Leeeroy'
    end
  end
end