Rails.application.config.generators do |g|
  g.view_specs false
  g.helper_specs false
  g.template_engine :haml
  g.test_framework  :rspec
  g.fixture_replacement :factory_girl
end
