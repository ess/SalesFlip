set :stages, %w(production staging)
set :default_stage, "staging"

require "capistrano/ext/multistage"

set :use_sudo, false

set :deploy_to, "/data/salesflip"
set :git_shallow_clone, 1
set :keep_releases, 5
set :user, "root"
set :runner, "root"
set :repository,  "git@github.com:HRNewMedia/SalesFlip.git"
set :scm, :git

ssh_options[:paranoid] = false
default_run_options[:pty] = true

before 'deploy:restart', 'deploy:symlinks'
before 'deploy:restart', 'deploy:bundle'
after 'deploy:bundle', 'deploy:solr'

namespace :deploy do
  task :start do; end
  task :stop do; end

  task :autoupgrade, :roles => :app do
    run "cd #{current_path} && rake db:autoupgrade"
  end

  task :solr, :roles => :app do
    run "cd #{current_path} && /etc/init.d/solr restart"
  end

  task :restart, :roles => :app do
    run "kill -USR2 `cat /tmp/unicorn.pid`"
  end

  task :symlinks, :roles => :app do
    run "ln -s #{shared_path}/solr #{current_path}/solr"
  end

  task :bundle, :roles => :app do
    run "cd #{current_path} && bundle install --without development test"
  end
end
