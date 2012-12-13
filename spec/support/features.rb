RSpec.configure do |config|
  config.before(:each) do
    if example.metadata[:type] == :feature
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      Capybara.current_driver = :selenium # or equivalent javascript driver you are using
      OmniAuth.config.test_mode = true
      # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
      OmniAuth.config.add_mock(:google_oauth2,
                               "uid"=>"12345",
                               "user_info" =>
      {
        "email"=>"test@xxxx.com",
        "name"=>"Test User"
      })
    else
      Capybara.use_default_driver # presumed to be :rack_test
    end
  end

  config.after(:each) do
    if example.metadata[:type] == :feature
      OmniAuth.config.test_mode = false
      DatabaseCleaner.clean
    end
  end

  config.include Features::SessionHelpers, type: :feature
end
