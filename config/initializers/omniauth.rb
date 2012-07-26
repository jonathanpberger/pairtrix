Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "", "", {access_type: 'online', approval_prompt: ''}
end
