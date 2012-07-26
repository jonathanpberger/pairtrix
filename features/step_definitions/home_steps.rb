Given /^I view the home page$/ do
  visit(root_path)
end

Then /^I should see the navigation links$/ do
  within(".navbar") do
    page.should have_content("Sign in")
  end
end
