require "rails_helper"

RSpec.describe "Create post flow", :type => :system do
  def fill_in_basic
    attach_file('files[]', File.join(Rails.root, '/spec/support/assets/picture.png'))
    fill_in 'post_title', with: 'My transmog title'
    select "Leather", :from => "post_armor_type_id"
    select "Warlock", :from => "post_class_type_id"
  end

  before do
    driven_by(:rack_test)
    # Stub Gibbon API call to Mailchimp
    allow_any_instance_of(User).to receive(:subscribe).and_return("ok")
  end

  context 'when creating new post with no user' do
    it 'expects to have nickname and email fields for no user' do
      visit new_post_path
      expect(page).to have_field("user[nickname]")
      expect(page).to have_field("user[email]")
    end

    describe 'expects to create a post and a new user' do
      before do
        ["Leather", "Plate"].map{|item| ArmorType.create(value: item)}
        ["Druid", "Warlock"].map{|item| ClassType.create(value: item)}
        visit new_post_path
      end

      it 'when user fields are filled in' do
        fill_in_basic

        fill_in 'user[nickname]', with: 'Loli Pop User'
        fill_in 'user[email]', with: 'Loli@Pop.User'

        expect{
          click_button("Create Post")
        }.to change {Post.count}.from(0).to(1)
          .and change {User.count}.from(0).to(1)

        expect(Post.last.title).to eq("My transmog title")
        expect(User.last.nickname).to eq 'Loli Pop User'
        expect(User.last.email).to eq 'Loli@Pop.User'.downcase
      end

      it 'when NO user fields filled in' do
        fill_in_basic

        expect{
          click_button("Create Post")
        }.to change {Post.count}.from(0).to(1)
          .and change {User.count}.from(0).to(1)

        expect(Post.last.title).to eq("My transmog title")
        expect(User.last.roles.fetch("random_user")).to eq true
      end
    end
  end

  context 'when creating new post with a signed in user' do
    let(:user) { create :user }

    before do
      ["Leather", "Plate"].map{|item| ArmorType.create(value: item)}
      ["Druid", "Warlock"].map{|item| ClassType.create(value: item)}
      sign_in user
      visit root_path
      click_on 'UPLOAD TRANSMOGRAM PICTURES'
    end

    it 'expects not to have nickname and email fields for signed in users' do
      # they should be only visible to new users
      expect(page).not_to have_field("user[nickname]")
      expect(page).not_to have_field("user[email]")
    end

    it 'expects to successfully redirect to create new post page' do
      expect(current_path).to eq new_post_path
    end

    it 'expects to fill in fields and create new post' do
      fill_in_basic

      expect{
        click_button("Create Post")
      }.to change {Post.count}.from(0).to(1)
      expect(Post.last.title).to eq("My transmog title")
    end

    it 'expects to raise errors when no data is provided' do
      click_button("Create Post")

      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Armor type can't be blank")
      expect(page).to have_content("Class type can't be blank")
      expect(page).to have_content("Select at least one image")
    end

    # it 'expects to redirect user back to root if he is not logged in' do
    #   sign_out user
    #   visit root_path
    #   click_on 'Add Work'
    #   expect(current_path).to eq root_path
    #   expect(page).to have_content("You must be logged in to create a new post.")
    # end
  end
end