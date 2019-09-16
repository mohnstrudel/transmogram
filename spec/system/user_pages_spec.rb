require "rails_helper"

RSpec.describe "User pages spec", :type => :system do
  before do
    driven_by(:rack_test)
    # Stub Gibbon API call to Mailchimp
    allow_any_instance_of(User).to receive(:subscribe).and_return("ok")
  end

  context 'when viewing show page' do
    let(:user) { create :user, nickname: "Lolipop", email: 'loli@pop.com', password: 'lolipop123'}

    it 'renders the show view correctly' do
      visit user_path(user)
      expect(page).to have_content(user.nickname)
    end
  end
end