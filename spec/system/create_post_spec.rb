require "rails_helper"

RSpec.describe "Creaet post flow", :type => :system do
  before do
    driven_by(:rack_test)
    # Stub Gibbon API call to Mailchimp
    allow_any_instance_of(User).to receive(:subscribe).and_return("ok")
  end

  context 'when creating new post' do
    let(:user) { create :user }

    before do
      ["Leather", "Plate"].map{|item| ArmorType.create(value: item)}
      ["Druid", "Warlock"].map{|item| ClassType.create(value: item)}
      sign_in user
      visit root_path
      click_on 'Add Work'
    end

    it 'expects to successfully redirect to create new post page' do
      expect(current_path).to eq new_post_path
    end

    it 'expects to fill in fields and create new post' do
      attach_file('files[]', File.join(Rails.root, '/spec/support/assets/picture.png'))
      fill_in 'post_title', with: 'My transmog title'
      select "Leather", :from => "post_armor_type_id"
      select "Warlock", :from => "post_class_type_id"

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

    it 'expects to redirect user back to root if he is not logged in' do
      sign_out user
      visit root_path
      click_on 'Add Work'
      expect(current_path).to eq root_path
      expect(page).to have_content("You must be logged in to create a new post.")
    end
  end
end