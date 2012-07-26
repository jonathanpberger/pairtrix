# you need to create a mail.yml based on the example
mail_config = YAML::load(File.open("#{Rails.root}/config/mail.yml"))

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :domain => mail_config['domain'],
  :user_name => mail_config['user'],
  :password => mail_config['pass'],
  :enable_starttls_auto => true
}
