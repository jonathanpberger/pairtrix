Before('@omniauth') do
  OmniAuth.config.test_mode = true

  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.add_mock(:google_oauth2,
                           "uid"=>"12345",
                           "user_info" => {
                             "email"=>"test@xxxx.com", "name"=>"Test User"
                           }
  )
end

After('@omniauth') do
  OmniAuth.config.test_mode = false
end
