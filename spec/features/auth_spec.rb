require "rails_helper"

RSpec.feature "Authentication", :type => :feature do
  let!(:password) { Faker::Internet.password }
  let!(:usr) { FactoryGirl.create(:user, login: Faker::Internet.user_name, username: Faker::Name.name, password: password) }

  scenario "User enter to the app" do
    visit "admin"
    fill_in "login", :with => usr.login
    fill_in "password", :with => password
    click_button "Log in"
    expect(page).to have_text('Tickets')
    click_button "Log out"
  end

  scenario "Access deny" do
    visit "admin"
    fill_in "login", :with => 'bad_guy'
    fill_in "password", :with => 'bad_guys_pass'
    click_button "Log in"
    expect(page).to have_text('Wrong login or password!')
  end
end