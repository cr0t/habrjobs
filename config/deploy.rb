set :application, "com.summercode.habrjobs"

set :scm, :git
set :branch, "master"
set :repository, "gitosis@git.summercode.com:habrjobs.git"

role :app, "habrjobs.summercode.com"

set :user, "cr0t"
set :use_sudo, false

set :deploy_to, "/var/www/#{application}"

set :keep_releases, 3

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
    run "/etc/unicorns/habrjobs restart"
  end
  
  after "deploy:update" do
    deploy::cleanup
  end
end