#############################################################
#	Application
#############################################################

set :application, "dvdpost-webservice"
set :deploy_to, "/home/webapps/dvdpost-webservice/production"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production" 

#############################################################
#	Servers
#############################################################

set :user, "dvdpost-webservice"
#set :domain, "192.168.102.15"
#set :port, 22
set :domain, "94.139.62.123"
set :port, 22012

server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "production"
set :scm_user, 'dvdpost'
set :scm_passphrase, "[y'|\E7U158]9*"
set :repository, "git@github.com:dvdpost/dvdpost-webservice.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  after "deploy:update_code" do
    db_config = <<-EOF
    production:
      adapter: mysql
      encoding: utf8
      database: dvdpost_be_prod
      username: webuser
      password: 3gallfir-
      host: matadi
      port: 3306
    common_production:
      adapter: mysql
      encoding: utf8
      database: common_production
      username: webuser
      password: 3gallfir-
      host: matadi
      port: 3306
    plush_production:
     adapter: mysql
     encoding: utf8
     database: plush_production
     username: webuser
     password: 3gallfir-
     host: matadi
     port: 3306
    EOF
    
    put db_config, "#{release_path}/config/database.yml"
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
