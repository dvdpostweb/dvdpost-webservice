set :stages, %w(staging pre_production production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'

after 'deploy:symlink' do
  run "ln -nfs #{deploy_to}/shared/uploaded/partner_logos #{deploy_to}/#{current_dir}/public/images/logo"
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} ; export PATH=/opt/ruby/bin:$PATH ; bundle check 2>&1 > /dev/null ; if [ $? -ne 0 ] ; then sh -c 'bundle install --relock --disable-shared-gems --without test development' ; fi"
  end
end

after "deploy:symlink", "bundler:bundle_new_release"

# Thinking Sphinx
namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :index, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :reindex, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:reindex RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
  task :rebuild, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  task :conf, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :in, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :rein, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:reindex RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
  task :rebuild, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

namespace :deploy do
  task :stop_ts do
    # Stop Thinking Sphinx before the update so it finds its configuration file.
    thinking_sphinx.stop rescue nil # Don't fail if it's not running, though.
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end

  task :update_ts do
    symlink_sphinx_indexes
    thinking_sphinx.configure
    thinking_sphinx.start
  end
end

before 'deploy:update_code', 'deploy:stop_ts'
after 'deploy:symlink', 'deploy:update_ts'
