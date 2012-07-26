Transform /^(should|should not)$/ do |should_or_not|
  should_or_not.gsub(' ', '_').to_sym
end

CAPTURE_A_NUMBER = Transform /^\d+$/ do |number|
  number.to_i
end

Then /^I should see the "([^"]*)" warning message$/ do |warning_message|
  within(".warning") do
    page.should have_content(warning_message)
  end
end

When /^the request ip address is "([^\"]*)"$/ do |ip_address|
  @ip_address = ENV['RAILS_TEST_IP_ADDRESS'] = ip_address
end
