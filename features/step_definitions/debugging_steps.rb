When /^I console$/ do
  ->{ binding.pry }.call
end

Then /show me the response$/ do
  raise "Debug step left in" if ENV["CI"]
  require "tempfile"
  if response.body =~ /^<html/
    begin
      tempfile = Tempfile.new(["show_me_the_response", ".html"])
      tempfile << response.body
      system("open #{tempfile.path}")
    end
  end
  puts "\n" + response.body + "\n"
end

Then /^show me the .*page$/ do
  if ENV["CI"]
    raise "You committed with a debug statement. You are a bad person and you should feel bad."
  end
  save_and_open_page
  sleep 1 # Page saves use timestamps; make sure they're different.
end

Given /^this is pending ?(.*)$/ do |reason|
  raise "Do not use this step, use: Given \"<initials>\" made this pending on \"<date>\" because \"<reason>\""
end

Given /^"(.*)" made this pending on "(.*)" because "(.*)"$/ do |name, date, message|
  pending_date = Date.parse(date)
  raise "#{name} made this pending on #{date} because '#{message}' but that was more than 30 days ago. Consider deleting this test" if pending_date < 30.days.ago.to_date
  pending "#{date} - #{message} (#{name})"
end

And /Say "([^"]*)"/ do |message|
  puts message
end

And /I wait (\d+) second(?:s?)/ do |seconds|
  sleep(seconds.to_i)
end

And /^I debug$/ do
  debugger
end
