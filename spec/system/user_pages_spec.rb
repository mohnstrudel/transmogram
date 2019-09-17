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

  context 'when trying to access admin restricted pages' do
    describe 'as regular user' do
    end
    describe 'as not signed in user' do
      it 'expects user to redirect to root path' do
        visit images_path
        expect(current_path).to eq(root_path)
      end
    end
  end
end