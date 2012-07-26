### GIVEN ###
Given /^I am not signed in$/ do
  visit '/sign_out'
end

Given /^I am signed in with provider "([^"]*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

Given /^an? (admin)? user$/ do |is_admin|
  admin = is_admin ? true : false
  @user = FactoryGirl.create(:user, admin: admin)
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Sign out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign in"
  page.should_not have_content "Sign out"
end

