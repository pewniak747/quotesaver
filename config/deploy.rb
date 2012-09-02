set :application,       'quotesaver'
set :repository,        "pewniak747.info:/opt/git/quotesaver.git"
set :scm,               :git
set :use_sudo,          false
set :host,              'pewniak747.info'

role :web,  host
role :app,  host
role :db,   host, :primary => true
default_run_options[:pty] = true

set :user,    'deployer'

namespace :deploy do

  task :start do
    run "cd #{current_path} && export RUBYOPT=-Ku && bundle install && bundle exec unicorn -c config/unicorn.rb -E production -p 7171 -D config.ru"
  end

  task :stop do
    run "kill -9 `cat #{shared_path}/pids/quotesaver.pid`"
  end

  task :restart do
    stop
    start
  end
  
end
