# Capistrano task for Bundler.
#
# Just add "require 'bundler/capistrano'" in your Capistrano deploy.rb, and
# Bundler will be activated after each new deployment.
require 'bundler/deployment'

after "deploy:update_code", "bundle:install"
Bundler::Deployment.define_task(self, :task, :except => { :no_release => true })
set :rake, lambda { "#{fetch(:bundle_cmd, "bundle")} exec rake" }
