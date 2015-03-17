require 'spec_helper'
require 'rails_helper'

feature "the goal creation process" do
  feature "when logged in" do
    before(:each) do
      sign_up('ginger baker')
      sign_in('ginger baker', 'TestPass')
    end

    scenario "has a new goal page" do
      visit new_goal_url
      expect(page).to have_content("New Goal")
    end

    scenario "alerts user of errors" do
      visit new_goal_url
      fill_in 'body', :with => ''
      choose 'priv'
      click_on "Create Goal"
      expect(page).to have_content("Body can't be blank")
    end

    scenario "redirects to show page on successful goal creation" do
      visit new_goal_url
      fill_in 'body', :with => "Run Five Miles"
      choose('Public')
      click_on 'Create Goal'
      expect(page).to have_content("Run Five Miles")
      expect(page).not_to have_content("New Goal")
      expect(page).to have_content("Public")
      expect(page).not_to have_content("Private")
    end

    scenario "should show all of a user's own goals" do
      create_goals
      visit user_url(1)

      expect(page).to have_content("Run Five Miles")
      expect(page).to have_content("Stop Eating Candy")
    end
  end

  feature "when not logged in" do
    scenario "should redirect to login page" do
      visit new_goal_url
      expect(page).to have_content("Login")
      expect(page).not_to have_content("New Goal")
      expect(current_url).to eq new_session_url
    end
  end

  feature "when logged in as wrong user" do
    before(:each) do
      create_goals
      click_on 'Logout'

      sign_up('Charlie Brown')
      sign_in('Charlie Brown', 'TestPass')
    end

    scenario "should display only public goals on other user's page" do
      visit user_url(1)
      expect(page).to have_content("Run Five Miles")
      expect(page).to_not have_content("Stop Eating Candy")
    end

    scenario "should not display other user's goal show page" do
      visit goal_url(1)
      expect(page).to_not have_content("Run Five Miles")
      expect(page).to have_content("Welcome, Charlie Brown")
      expect(current_url).to eq user_url(2)
    end
  end
end

feature "the goal update process" do
  before(:each) do
    create_goals
  end

  feature "when logged in" do
    scenario "allows user to edit their goals" do
      click_on 'Edit Goal'
      fill_in 'body', :with => "Run Ten Miles"
      choose 'priv'
      click_on 'Edit Goal'
      expect(page).to have_content("Run Ten Miles")
      expect(page).to have_content("Private")
      expect(page).to_not have_content("Five")
    end

    scenario "does not allow an invalid edit" do
      click_on 'Edit Goal'
      fill_in 'body', :with => ""
      choose 'priv'
      click_on 'Edit Goal'
      expect(page).to have_content("Body can't be blank")
      expect(page).to have_content("Edit Goal")
    end
  end
end

feature "the goal delete process" do
  before(:each) do
    create_goals
  end

  feature "when logged in" do
    scenario "allows user to delete their goals" do
      click_on "Delete Goal"
      expect(page).to_not have_content("Stop Eating Candy")
      expect(page).to have_content("Run Five Miles")
    end
  end
end

feature "the goal tracking process" do
  scenario "allows user to track completed goals" do
    create_goals
    expect(page).to have_content("Incomplete")
    expect(page).to have_button("Goal Complete")
    click_on "Goal Complete"
    expect(page).to have_content("Complete")
    expect(page).not_to have_content("Incomplete")
    expect(page).not_to have_button("Goal Complete")
  end
end
