set :stages, %w(staging pre_production production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'

require 'bundler/capistrano'

require "whenever/capistrano"

#after "deploy:symlink", "deploy:update_crontab"

#namespace :deploy do
#  desc "Update the crontab file"
#  task :update_crontab, :roles => :db do
#    run "cd #{release_path} && whenever --update-crontab #{application}"
#  end
#end