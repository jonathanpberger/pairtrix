#############################################################
#  Application
#############################################################

set :application, 'pairtrix'
set :deploy_to, "/www/#{application}.com"

#use trunk to deploy to production
set :branch, "master"
set :rails_env, "production"

#production
set :domain, 'domain.host'
role :app, domain
role :web, domain
role :db, domain, :primary => true
role :worker, domain

#############################################################
#  Git
#############################################################

set :scm, :git
set :repository,  "git@github.com:USERNAME/#{application}.git"

#############################################################
#  Servers
#############################################################

set :user, 'USERNAME'

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false
set :ssh_options, {:forward_agent => true}
set :current_release, "#{deploy_to}/current"
set :default_environment, { 'LANG' => 'en_US.UTF-8' }

#############################################################
#  Includes
#############################################################

#############################################################
#  Post Deploy Hooks
#############################################################

after "deploy:setup", "deploy:create_symlink"
after "deploy:update_code", "deploy:write_revision"
