require 'spec_helper'
require 'rails_helper'

feature "the signup process" do
  scenario "has a new user page" do
    visit new_user_url
    within('h1') { expect(page).to have_content("New User") }
    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
  end

  feature "signing up a user" do
    scenario "should not allow short password" do
      visit new_user_url
      fill_in 'username', :with => "testing_username"
      fill_in 'password', :with => "b"
      click_on "Create User"
      expect(page).to have_content("Password is too short")
    end

    scenario "should not allow blank username" do
      visit new_user_url
      fill_in 'username', :with => ""
      fill_in 'password', :with => "hellohello"
      click_on "Create User"
      expect(page).to have_content("Username can't be blank")
    end

    scenario "should show user page upon successful sign-up" do
      visit new_user_url
      fill_in 'username', :with => "Capybara"
      fill_in 'password', :with => "hellohello"
      click_on "Create User"
      expect(page).to have_content("Welcome, Capybara")
    end
  end
end

feature "logging in" do
  before(:each) do
    sign_up('ginger baker')
  end

  scenario "shows login page" do
    visit new_session_url
    expect(page).to have_content("Login")
  end

  scenario "should re-display page after unsuccessful login" do
    visit new_session_url
    fill_in 'username', :with => "ginger baker"
    fill_in 'password', :with => "asdfgh"
    click_on "Login"
    expect(page).to have_content("Login failed")
  end

  scenario "should redirect to user page on successful login" do
    visit new_session_url
    fill_in 'username', :with => "ginger baker"
    fill_in 'password', :with => "TestPass"
    click_on "Login"
    expect(page).to have_content("Welcome, ginger baker")
    expect(page).to have_button("Logout")
    expect(page).not_to have_button("Login")
  end
end

feature "logging out" do
  before(:each) do
    sign_up('ginger baker')
    sign_in('ginger baker', 'TestPass')
    click_on "Logout"
  end

  scenario "should redirect to login page upon logout" do
    expect(page).to have_content("Login")
    expect(page).not_to have_content("Logout")
  end

  scenario "should not allow access to user page" do
    expect(page).not_to have_content("ginger baker")
    visit user_url(1)
    expect(page).not_to have_content("ginger baker")
    expect(page).to have_content("Login")
    expect(current_url).to eq new_session_url
  end
end
