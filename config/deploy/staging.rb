#############################################################
#	Application
#############################################################

set :application, "dvdpost"
set :deploy_to, "/home/webapps/dvdpost/staging"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "staging" 

#############################################################
#	Servers
#############################################################

set :user, "dvdpost"
set :domain, "dvdpost.redstorm.be"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "master"
set :scm_user, 'dvdpost'
set :scm_passphrase, "[y'|\E7U158]9*"
set :repository, "git@github.com:redstorm/dvdpost.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  after "deploy:update_code" do
    db_config = <<-EOF
    staging:    
      adapter: mysql
      encoding: utf8
      username: dvdpost
      password: p0ststrm
      database: dvdpost_staging
      host: localhost
    dvdpost_main:
      adapter: mysql
      encoding: utf8
      database: dvdpost_be_prod
      username: inspector
      password: Gr4n1B1s
      host: www.dvdpost.be
      port: 43306
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