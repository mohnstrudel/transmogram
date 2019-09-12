require "rails_helper"

RSpec.describe "Login user flow", :type => :system do
  before do
    driven_by(:rack_test)
    # Stub Gibbon API call to Mailchimp
    allow_any_instance_of(User).to receive(:subscribe).and_return("ok")
  end

  let(:user) { create :user, nickname: "Lolipop", email: 'loli@pop.com', password: 'lolipop123'}

  it 'expects to redirect correctly after login' do
    visit root_path
    find('#header_login').click

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    find('#perform_login').click

    expect(current_path).to eq root_path
    expect(page).to have_content("Hi, Lolipop")
  end
end